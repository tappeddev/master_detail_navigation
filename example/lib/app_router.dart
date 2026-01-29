import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_navigation/master_detail_navigation.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: ShellRoute.page,
      path: '/',
      initial: true,
      children: [
        MasterRoute(
          page: TodoListRoute.page,
          path: '',
          initial: true,
          wrapChild: (context, child) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F7FB),
                border: Border(
                  right: BorderSide(color: Color(0x33000000), width: 1),
                ),
              ),
              child: child,
            );
          },
        ),
        _createDetailRoute(page: TodoDetailRoute.page, path: 'detail/:id'),
      ],
    ),
  ];
}

DetailRoute<R> _createDetailRoute<R extends Object>({
  required PageInfo page,
  required String path,
  List<AutoRouteGuard> guards = const [],
  bool withDefaultAnimation = true,
}) {
  Duration animationDuration(BuildContext context) {
    return const Duration(milliseconds: 300);
  }

  Widget transitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    WidgetBuilder buildDefaultTransition,
    Widget child,
  ) {
    if (withDefaultAnimation) {
      return buildDefaultTransition(context);
    }
    return FadeTransition(opacity: animation, child: child);
  }

  return DetailRoute<R>(
    path: path,
    page: page,
    guards: guards,
    usesPathAsKey: true,
    transitionDuration: animationDuration,
    reverseTransitionDuration: animationDuration,
    transitionBuilder: transitionBuilder,
  );
}
