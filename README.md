# master_detail_navigation

A responsive master-detail navigation shell for `auto_route`. It keeps the
master list visible on desktop and presents detail pages as overlays on mobile,
while still using a single router configuration.

![Master/detail demo](docs/master-detail.gif)

## Features ✨

- Responsive master/detail layout (mobile overlay, desktop split view)
- Route helpers for master and detail pages (`MasterRoute`, `DetailRoute`)
- Focus/semantics handling to keep master and detail accessible
- Customizable detail transitions and layout sizing

## Installation 📦

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  master_detail_navigation: ^<latest>
```

This package builds on `auto_route`, so make sure it is set up in your app.

## Basic usage 🚀

Choose the layout type and host your nested router inside `MasterDetailShell`:

```dart
const _breakpoint = 700.0;

@RoutePage()
class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutType = constraints.maxWidth < _breakpoint
            ? MasterDetailLayoutType.mobile
            : MasterDetailLayoutType.desktop;

        return MasterDetailShell(
          layoutType: layoutType,
          onDetailsPopped: () {},
          detailPlaceholder: const Center(child: Text('Select a todo')),
        );
      },
    );
  }
}
```

Configure `MasterRoute` and `DetailRoute` inside your router:

```dart
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
            ),
            DetailRoute(
              page: TodoDetailRoute.page,
              path: 'detail/:id',
              usesPathAsKey: true,
            ),
          ],
        ),
      ];
}
```

Open detail pages from the master list:

```dart
MasterDetailShell.of(context).openDetails(TodoDetailRoute(id: todo.id));
```

## License 📄

MIT. See `LICENSE`.
