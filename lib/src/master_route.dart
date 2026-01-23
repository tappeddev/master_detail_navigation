import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_navigation/src/responsive_master_detail_data.dart';

import 'non_exclusive_modal_route.dart';

/// A [CustomRoute] for the master/list side of a master-detail UI.
///
/// Use this for the route that renders the list (master) inside
/// `MasterDetailShell`. The page is aligned to the left and sized to
/// [ResponsiveMasterDetailData.masterWidth], so it stays visible on desktop and
/// sits underneath the detail page on mobile. It also uses a non-exclusive
/// modal scope so the master can remain focusable when the detail panel is
/// visible.
///
/// To configure master/detail sizing, see `MasterDetailShell.masterSizeRatio`
/// and `MasterDetailShell.contentConstraintsBuilder`.
///
/// Detail pages are detected by `MasterDetailChangeObserver` when a
/// `DetailRoute` is pushed on top of a master route.
class MasterRoute<R extends Object> extends CustomRoute<R> {
  /// Creates a master route.
  ///
  /// Use [wrapChild] to decorate the master widget (e.g., add padding, a
  /// scaffold, or a vertical separator) without affecting detail routes.
  factory MasterRoute({
    required PageInfo page,
    required String path,
    List<AutoRouteGuard> guards = const [],
    required bool initial,
    Widget Function(BuildContext context, Widget child)? wrapChild,
  }) {
    final customRouteBuilder = <T>(context, child, page) {
      return _MasterPageRoute<T>(
        settings: page,
        builder: (context) {
          final data = ResponsiveMasterDetailData.of(context);

          return Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: data.masterWidth,
              child: wrapChild?.call(context, child) ?? child,
            ),
          );
        },
      );
    };
    return MasterRoute._(
      path: path,
      page: page,
      initial: initial,
      guards: guards,
      customRouteBuilder: customRouteBuilder,
    );
  }

  MasterRoute._({
    required super.page,
    required super.path,
    required super.customRouteBuilder,
    super.guards,
    super.initial,
  });

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
