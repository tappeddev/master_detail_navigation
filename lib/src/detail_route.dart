import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_navigation/src/responsive_master_detail_data.dart';

import 'non_exclusive_modal_route.dart';

class DetailRoute<R extends Object> extends CustomRoute<R> {
  DetailRoute({required super.page, required super.path, super.guards})
    : super(customRouteBuilder: _buildRoute);

  static Route<T> _buildRoute<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) {
    return _DetailPageRoute(builder: (context) => child, settings: page);
  }

  static bool isPageRoute(Route<dynamic>? route) => route is _DetailPageRoute;
}

class _DetailPageRoute<T> extends PageRouteBuilder<T>
    with MaterialRouteTransitionMixin<T> {
  final WidgetBuilder builder;

  _DetailPageRoute({required this.builder, required super.settings})
    : super(pageBuilder: (context, _, _) => builder(context));

  @override
  DelegatedTransitionBuilder? get delegatedTransition => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  /*
  @override
  Duration get transitionDuration {
    if (navigator == null) return const Duration(milliseconds: 300);

    final layoutType = ResponsiveBreakpoints.of(navigator!.context).layoutType;

    return switch (layoutType) {
      MasterDetailLayoutType.mobile => const Duration(milliseconds: 300),
      MasterDetailLayoutType.desktop => Duration.zero,
    };
  }

  @override
  Duration get reverseTransitionDuration {
    if (navigator == null) return const Duration(milliseconds: 300);

    final layoutType = ResponsiveBreakpoints.of(navigator!.context).layoutType;

    return switch (layoutType) {
      MasterDetailLayoutType.mobile => const Duration(milliseconds: 300),
      MasterDetailLayoutType.desktop => Duration.zero,
    };
  }


  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (UniversalPlatform.isWeb) {
      return child;
    }

    final layoutType = ResponsiveBreakpoints.of(context).layoutType;

    if (layoutType == MasterDetailLayoutType.mobile) {
      return super.buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      );
    } else {
      return FadeTransition(opacity: animation, child: child);
    }
  }*/

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
                      route: this,
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
