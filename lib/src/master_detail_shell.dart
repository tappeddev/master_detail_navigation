import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'master_detail_change_observer.dart';
import 'master_detail_layout.dart';
import 'responsive_master_detail_data.dart';

/// The [MasterDetailShell] lays out the master and detail routes in a
/// responsive master-detail UI.
///
/// On [MasterDetailLayoutType.desktop], it shows the master list on the left
/// and the detail panel on the right. On [MasterDetailLayoutType.mobile], the
/// detail page sits on top of the master.
///
/// Sizing is driven by the available constraints. The master width is
/// `maxWidth * masterSizeRatio`, and the detail width fills the remaining
/// space. Use [contentConstraintsBuilder] to clamp the overall width/height.
///
/// **Required Parameters:**
///
/// * [layoutType]:
///     The current layout type.
/// * [onDetailsPopped]:
///     A callback function that is called when the detail page is popped.
///     This is needed for actions like resetting the selected id.
/// * [detailPlaceholder]:
///     The placeholder that is shown before the details are pushed.
class MasterDetailShell extends StatefulWidget {
  final MasterDetailLayoutType layoutType;
  final Widget detailPlaceholder;
  final VoidCallback onDetailsPopped;
  final Duration animationDuration;
  final Duration placeholderFadeDuration;
  final Curve animationCurve;

  /// Optional constraints applied to the shell before layout.
  final BoxConstraints Function(MasterDetailLayoutType layoutType)?
  contentConstraintsBuilder;

  /// Optional declarative routes builder for the inner [AutoRouter].
  final RoutesBuilder? routesBuilder;

  /// Fraction of available width reserved for the master on desktop.
  final double masterSizeRatio;

  const MasterDetailShell({
    super.key,
    required this.layoutType,
    required this.detailPlaceholder,
    required this.onDetailsPopped,
    this.contentConstraintsBuilder,
    this.animationDuration = const Duration(milliseconds: 300),
    this.placeholderFadeDuration = const Duration(milliseconds: 50),
    this.animationCurve = Curves.easeInOut,
    this.routesBuilder,
    this.masterSizeRatio = 0.6,
  });

  @override
  State<MasterDetailShell> createState() => _MasterDetailShellState();

  static ResponsiveListDetailController of(BuildContext context) {
    return context.findAncestorStateOfType<_MasterDetailShellState>()!;
  }
}

class _MasterDetailShellState extends State<MasterDetailShell>
    with TickerProviderStateMixin
    implements ResponsiveListDetailController {
  final _navigatorKey = GlobalKey<AutoRouterState>(
    debugLabel: "MasterDetailShellRouterKey",
  );

  late final AnimationController _hideDetailAreaController;
  late final AnimationController _showPlaceholderController;

  var _isDetailsVisible = false;

  @override
  void initState() {
    super.initState();

    _hideDetailAreaController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 1.0,
    );

    _showPlaceholderController = AnimationController(
      vsync: this,
      duration: widget.placeholderFadeDuration,
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant MasterDetailShell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationDuration != widget.animationDuration) {
      _hideDetailAreaController.duration = widget.animationDuration;
    }

    if (oldWidget.placeholderFadeDuration != widget.placeholderFadeDuration) {
      _showPlaceholderController.duration = widget.placeholderFadeDuration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hideDetailAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _hideDetailAreaController,
        curve: widget.animationCurve,
      ),
    );

    final showPlaceholderAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _showPlaceholderController,
        curve: widget.animationCurve,
      ),
    );

    final contentConstraints =
        widget.contentConstraintsBuilder?.call(widget.layoutType) ??
        const BoxConstraints();

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: contentConstraints,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;

            return AnimatedBuilder(
              animation: hideDetailAnimation,
              builder: (context, _) {
                final detailExpandScale = hideDetailAnimation.value;

                final masterWidth = maxWidth * widget.masterSizeRatio;

                final detailWidth =
                    (maxWidth - masterWidth) * detailExpandScale;

                final effectiveDetailWidth = widget.layoutType.when(
                  ifMobile: () => constraints.maxWidth,
                  ifDesktop: () => detailWidth,
                );

                final detailX = widget.layoutType.when(
                  ifMobile: () => 0.0,
                  ifDesktop: () => masterWidth,
                );

                final detailsInVisibleArea = detailX < maxWidth;
                final isDetailOverMaster = detailX == 0 && _isDetailsVisible;

                return ResponsiveMasterDetailData(
                  masterWidth: widget.layoutType.when(
                    ifMobile: () => constraints.maxWidth,
                    ifDesktop: () => masterWidth,
                  ),
                  detailWidth: effectiveDetailWidth,
                  detailX: detailX,
                  maxHeight: maxHeight,
                  detailsVisible: detailsInVisibleArea,
                  isDetailOverMaster: isDetailOverMaster,
                  child: Stack(
                    children: [
                      if (widget.layoutType == MasterDetailLayoutType.desktop)
                        Positioned(
                          left: detailX,
                          width: effectiveDetailWidth,
                          height: constraints.maxHeight,
                          child: AnimatedBuilder(
                            animation: showPlaceholderAnimation,
                            builder: (context, child) {
                              final value = showPlaceholderAnimation.value;

                              final placeholderFullTransparent = value == 0.0;

                              return Opacity(
                                opacity: value,
                                child: ExcludeSemantics(
                                  excluding:
                                      placeholderFullTransparent ||
                                      !detailsInVisibleArea,
                                  child: ExcludeFocus(
                                    excluding:
                                        placeholderFullTransparent ||
                                        !detailsInVisibleArea,
                                    child: widget.detailPlaceholder,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      Focus(
                        debugLabel: "MasterDetailLayout",
                        canRequestFocus: false,
                        child: _buildRouter(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRouter() {
    final navigatorObservers = () => [
      HeroController(),
      MasterDetailChangeObserver(
        onDetailsPop: _onDetailsPopped,
        onDetailsPushed: _onDetailsPushed,
      ),
    ];

    if (widget.routesBuilder != null) {
      return AutoRouter.declarative(
        key: _navigatorKey,
        inheritNavigatorObservers: true,
        routes: widget.routesBuilder!,
        navigatorObservers: navigatorObservers,
      );
    }

    return AutoRouter(
      key: _navigatorKey,
      inheritNavigatorObservers: true,
      navigatorObservers: navigatorObservers,
    );
  }

  void _setDetailsVisible(bool value) {
    if (!mounted) return;
    setState(() => _isDetailsVisible = value);
  }

  Future<void> _onDetailsPopped(TransitionRoute<dynamic> route) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDetailsVisible(false);
    });

    widget.onDetailsPopped();

    await Future<void>.delayed(route.reverseTransitionDuration);

    if (!mounted) return;
    await _showPlaceholderController.forward();
  }

  Future<void> _onDetailsPushed(TransitionRoute<dynamic> route) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDetailsVisible(true);
    });

    final transitionDuration = route.transitionDuration;

    final safeDuration = transitionDuration == Duration.zero
        ? const Duration(milliseconds: 10)
        : transitionDuration ~/ 2;

    if (!mounted) return;
    await _showPlaceholderController.animateTo(0.0, duration: safeDuration);
  }

  @override
  void dispose() {
    _showPlaceholderController.dispose();
    _hideDetailAreaController.dispose();

    super.dispose();
  }

  @override
  void openDetails(PageRouteInfo<void> page) {
    if (_isDetailsVisible) {
      router.replace(page);
    } else {
      router.push(page);
    }
  }

  @override
  void showDetails() {
    _hideDetailAreaController.forward();
  }

  @override
  void hideDetails() {
    _hideDetailAreaController.reverse();
  }

  @override
  StackRouter get router => _navigatorKey.currentState!.controller!;
}

abstract class ResponsiveListDetailController {
  StackRouter get router;

  void openDetails(PageRouteInfo<void> page);

  void hideDetails();

  void showDetails();
}
