import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_navigation/master_detail_navigation.dart';
import 'package:master_detail_navigation/src/responsive_master_detail_data.dart';

/// A [CustomRoute] for detail pages in a master-detail UI.
///
/// Use this for pages that show item details when paired with a `MasterRoute`
/// inside `MasterDetailShell`. The route positions its overlay using
/// [ResponsiveMasterDetailData.detailX] and
/// [ResponsiveMasterDetailData.detailWidth], and manages focus/semantics so
/// details can be hidden on desktop or cover the master on mobile.
///
/// To configure master/detail sizing, see `MasterDetailShell.masterSizeRatio`
/// and `MasterDetailShell.contentConstraintsBuilder`.
///
/// Provide [transitionBuilder] or custom durations to control how the detail
/// page animates.
class DetailRoute<R extends Object> extends CustomRoute<R> {
  /// Creates a detail route.
  factory DetailRoute({
    required PageInfo page,
    required String path,
    Duration Function(BuildContext context)? transitionDuration,
    Duration Function(BuildContext context)? reverseTransitionDuration,
    DetailTransitionBuilder? transitionBuilder,
    List<AutoRouteGuard> guards = const [],
    bool usesPathAsKey = false,
  }) {
    final CustomRouteBuilder customRouteBuilder = <T>(context, child, page) {
      return _DetailPageRoute<T>(
        builder: (context) => child,
        settings: page,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        transitionBuilder: transitionBuilder,
      );
    };
    return DetailRoute._(
      page: page,
      path: path,
      usesPathAsKey: usesPathAsKey,
      guards: guards,
      customRouteBuilder: customRouteBuilder,
    );
  }

  DetailRoute._({
    required super.page,
    required super.path,
    required super.customRouteBuilder,
    super.guards,
    super.usesPathAsKey,
  });

  static bool isPageRoute(Route<dynamic>? route) => route is _DetailPageRoute;
}

/// Signature for customizing detail transitions.
///
/// Use [buildDefaultTransition] to wrap the default material transition if
/// you only want to add effects on top.
typedef DetailTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      WidgetBuilder buildDefaultTransition,
      Widget child,
    );

class _DetailPageRoute<T> extends PageRouteBuilder<T>
    with MaterialRouteTransitionMixin<T> {
  final WidgetBuilder builder;
  final Duration Function(BuildContext context)? _transitionDuration;
  final Duration Function(BuildContext context)? _reverseTransitionDuration;
  final DetailTransitionBuilder? _transitionBuilder;

  _DetailPageRoute({
    required this.builder,
    required Duration Function(BuildContext context)? transitionDuration,
    required Duration Function(BuildContext context)? reverseTransitionDuration,
    required DetailTransitionBuilder? transitionBuilder,
    required super.settings,
  }) : _transitionDuration = transitionDuration,
       _reverseTransitionDuration = reverseTransitionDuration,
       _transitionBuilder = transitionBuilder,
       super(pageBuilder: (context, _, _) => builder(context));

  @override
  DelegatedTransitionBuilder? get delegatedTransition => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration {
    final defaultDuration = super.transitionDuration;

    final context = navigator?.context;
    if (context == null) return defaultDuration;

    return _transitionDuration?.call(context) ?? defaultDuration;
  }

  @override
  Duration get reverseTransitionDuration {
    final defaultDuration = super.reverseTransitionDuration;

    final context = navigator?.context;
    if (context == null) return defaultDuration;

    return _reverseTransitionDuration?.call(context) ?? defaultDuration;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _transitionBuilder?.call(
          context,
          animation,
          secondaryAnimation,
          (context) => super.buildTransitions(
            context,
            animation,
            secondaryAnimation,
            child,
          ),
          child,
        ) ??
        super.buildTransitions(context, animation, secondaryAnimation, child);
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() sync* {
    final entries = super.createOverlayEntries();
    assert(entries.length == 2);

    for (final (index, entry) in entries.indexed) {
      // Skip the modal barrier for master route
      if (index == 0) continue;

      // Wrap modal scope with non-exclusive focus behavior
      yield OverlayEntry(
        builder: (context) {
          final data = ResponsiveMasterDetailData.of(context);
          final excludeDetails = !data.detailsVisible;

          return Positioned(
            left: data.detailX,
            top: 0,
            width: data.detailWidth,
            height: data.maxHeight,
            child: Focus(
              canRequestFocus: false,
              debugLabel: "DetailRoute ($this)",
              child: ExcludeSemantics(
                excluding: excludeDetails,
                child: ExcludeFocus(
                  excluding: excludeDetails,
                  // This FocusNodes gives Detail pages the ability to move
                  // the focus to the root of the page if the layout needs to
                  // focus on the detail page manually.
                  child: Focus(
                    debugLabel: "DetailRouteFocusScope",
                    child: NonExclusiveModalScope(
                      builder: entry.builder,
                      sortKey: 1,
                      isFocusable: true,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        opaque: false,
        maintainState: entry.maintainState,
        canSizeOverlay: entry.canSizeOverlay,
      );
    }
  }

  @override
  Widget buildContent(BuildContext context) => builder(context);
}
