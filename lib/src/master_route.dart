import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_navigation/src/responsive_master_detail_data.dart';

import 'non_exclusive_modal_route.dart';

class MasterRoute<R extends Object> extends CustomRoute<R> {
  MasterRoute({
    required super.page,
    required super.path,
    super.guards,
    super.initial,
  }) : super(customRouteBuilder: _buildShiftedRoute);

  static Route<T> _buildShiftedRoute<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) {
    return _MasterPageRoute(
      settings: page,
      builder: (context) {
        final data = ResponsiveMasterDetailData.of(context);

        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(width: data.masterWidth, child: child),
        );
      },
    );
  }

  static bool isPageRoute(Route<dynamic>? route) => route is _MasterPageRoute;
}

class _MasterPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  _MasterPageRoute({required this.builder, super.settings})
    : super(
        pageBuilder: (context, _, _) => builder(context),
        transitionDuration: Duration.zero,
      );

  @override
  bool get opaque => false;

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
          final canRequestFocus = !data.isDetailOverMaster;

          return Focus(
            debugLabel: "MasterRoute ($this)",
            canRequestFocus: false,
            child: NonExclusiveModalScope(
              sortKey: 0,
              route: this,
              // Only allow focus of the master layout of
              isFocusable: canRequestFocus,
            ),
          );
        },
        opaque: false,
        maintainState: entry.maintainState,
        canSizeOverlay: entry.canSizeOverlay,
      );
    }
  }
}
