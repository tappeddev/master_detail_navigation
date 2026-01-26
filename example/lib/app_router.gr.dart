// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:master_detail_navigation_example/pages/shell_page.dart' as _i1;
import 'package:master_detail_navigation_example/pages/todo_detail_page.dart'
    as _i2;
import 'package:master_detail_navigation_example/pages/todo_list_page.dart'
    as _i3;

/// generated route for
/// [_i1.ShellPage]
class ShellRoute extends _i4.PageRouteInfo<void> {
  const ShellRoute({List<_i4.PageRouteInfo>? children})
    : super(ShellRoute.name, initialChildren: children);

  static const String name = 'ShellRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.ShellPage();
    },
  );
}

/// generated route for
/// [_i2.TodoDetailPage]
class TodoDetailRoute extends _i4.PageRouteInfo<TodoDetailRouteArgs> {
  TodoDetailRoute({
    _i5.Key? key,
    required String id,
    List<_i4.PageRouteInfo>? children,
  }) : super(
         TodoDetailRoute.name,
         args: TodoDetailRouteArgs(key: key, id: id),
         rawPathParams: {'id': id},
         initialChildren: children,
       );

  static const String name = 'TodoDetailRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TodoDetailRouteArgs>(
        orElse: () => TodoDetailRouteArgs(id: pathParams.getString('id')),
      );
      return _i2.TodoDetailPage(key: args.key, id: args.id);
    },
  );
}

class TodoDetailRouteArgs {
  const TodoDetailRouteArgs({this.key, required this.id});

  final _i5.Key? key;

  final String id;

  @override
  String toString() {
    return 'TodoDetailRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TodoDetailRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i3.TodoListPage]
class TodoListRoute extends _i4.PageRouteInfo<void> {
  const TodoListRoute({List<_i4.PageRouteInfo>? children})
    : super(TodoListRoute.name, initialChildren: children);

  static const String name = 'TodoListRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.TodoListPage();
    },
  );
}
