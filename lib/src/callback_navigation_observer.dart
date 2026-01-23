import 'package:flutter/cupertino.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

/// A [AutoRouterObserver] that triggers individual callbacks for each navigation event.
///
/// You can optionally provide handlers for:
/// - push
/// - pop
/// - replace
/// - remove
///
/// All callbacks are optional – if not provided, nothing happens for that event.
class CallbackNavigationObserver extends AutoRouterObserver {
  final void Function(Route<dynamic> route, Route<dynamic>? previousRoute)?
  onPush;
  final void Function(Route<dynamic> route, Route<dynamic>? previousRoute)?
  onPop;
  final void Function(Route<dynamic>? newRoute, Route<dynamic>? oldRoute)?
  onReplace;
  final void Function(Route<dynamic> route, Route<dynamic>? previousRoute)?
  onRemove;

  CallbackNavigationObserver({
    this.onPush,
    this.onPop,
    this.onReplace,
    this.onRemove,
  });

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onPush?.call(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onPop?.call(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    onReplace?.call(newRoute, oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRemove?.call(route, previousRoute);
  }
}
