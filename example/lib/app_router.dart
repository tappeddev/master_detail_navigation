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
        DetailRoute(
          page: TodoDetailRoute.page,
          path: 'detail/:id',
          // Use path-based keys so the detail page refreshes when data changes.
          // Include a unique path param (like the todo id) so the key changes.
          usesPathAsKey: true,
          transitionBuilder:
              (
                context,
                animation,
                secondaryAnimation,
                buildDefaultTransition,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
        ),
      ],
    ),
  ];
}
