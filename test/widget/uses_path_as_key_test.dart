import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:master_detail_navigation/master_detail_navigation.dart';

const _breakpoint = 700.0;
const _desktopSize = Size(1000, 800);

const _shellRouteName = 'ShellPage';
const _masterRouteName = 'MasterPage';
const _detailRouteName = 'DetailPage';

final _shellPage = PageInfo.builder(
  _shellRouteName,
  builder: (context, data) => const _ShellPage(),
);
final _masterPage = PageInfo.builder(
  _masterRouteName,
  builder: (context, data) => const _MasterPage(),
);
final _detailPage = PageInfo.builder(
  _detailRouteName,
  builder: (context, data) {
    final id = data.inheritedPathParams.getString('id');
    return _DetailPage(id: id);
  },
);

RootStackRouter _createRouter() {
  return RootStackRouter.build(
    routes: [
      AutoRoute(
        page: _shellPage,
        path: '/',
        initial: true,
        children: [
          MasterRoute(page: _masterPage, path: '', initial: true),
          DetailRoute(
            page: _detailPage,
            path: 'detail/:id',
            usesPathAsKey: true,
            transitionDuration: (_) => Duration.zero,
            reverseTransitionDuration: (_) => Duration.zero,
          ),
        ],
      ),
    ],
  );
}

Widget _buildApp(RootStackRouter router) {
  return MaterialApp.router(routerConfig: router.config());
}

void main() {
  testWidgets('todo list renders', (tester) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(_desktopSize);

    final router = _createRouter();
    await tester.pumpWidget(_buildApp(router));
    await tester.pumpAndSettle();

    expect(find.text('Write project brief'), findsOneWidget);
    expect(find.text('Review pull requests'), findsOneWidget);
  });

  testWidgets('detail updates when usesPathAsKey is enabled', (tester) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(_desktopSize);

    final router = _createRouter();
    await tester.pumpWidget(_buildApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Write project brief'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('detail-t1')), findsOneWidget);

    await tester.tap(find.text('Review pull requests'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('detail-t2')), findsOneWidget);
  });
}

class _ShellPage extends StatelessWidget {
  const _ShellPage();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutType = constraints.maxWidth < _breakpoint
            ? MasterDetailLayoutType.mobile
            : MasterDetailLayoutType.desktop;

        return MasterDetailShell(
          layoutType: layoutType,
          detailPlaceholder: const SizedBox.expand(),
          onDetailsPopped: () {},
          animationDuration: Duration.zero,
          placeholderFadeDuration: Duration.zero,
        );
      },
    );
  }
}

class _MasterPage extends StatelessWidget {
  const _MasterPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text('Write project brief'),
            onTap: () {
              MasterDetailShell.of(context).openDetails(
                const PageRouteInfo<void>(
                  _detailRouteName,
                  rawPathParams: {'id': 't1'},
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Review pull requests'),
            onTap: () {
              MasterDetailShell.of(context).openDetails(
                const PageRouteInfo<void>(
                  _detailRouteName,
                  rawPathParams: {'id': 't2'},
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  final String id;

  const _DetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey('detail-$id'),
      body: Center(child: Text('Detail $id')),
    );
  }
}
