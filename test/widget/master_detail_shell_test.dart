import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:master_detail_navigation/master_detail_navigation.dart';
import 'package:spot/spot.dart';

const _breakpoint = 600.0;
const _desktopSize = Size(1000, 800);
const _mobileSize = Size(500, 800);

const _shellRouteName = 'ShellPage';
const _masterRouteName = 'MasterPage';
const _detailRouteName = 'DetailPage';

final _detailContentKey = GlobalKey();

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
  builder: (context, data) => const _DetailPage(),
);

RootStackRouter _createRouter() {
  return RootStackRouter.build(
    routes: [
      AutoRoute(
        page: _shellPage,
        path: '/',
        initial: true,
        children: [
          MasterRoute(
            page: _masterPage,
            path: '',
            initial: true,
            wrapChild: (context, child) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: const Border(
                    right: BorderSide(color: Colors.black26, width: 1),
                  ),
                ),
                child: child,
              );
            },
          ),
          DetailRoute(
            page: _detailPage,
            path: 'detail',
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
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
  testWidgets('shows master and detail content when pushed', (tester) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(_desktopSize);

    final router = _createRouter();
    await tester.pumpWidget(_buildApp(router));
    await tester.pumpAndSettle();

    spotText('Master Page', exact: true).existsOnce();

    await act.tap(spotText('Open Detail', exact: true));
    await tester.pumpAndSettle();

    spotText('Detail Page', exact: true).existsOnce();
  });

  testWidgets('detail layout responds to resize', (tester) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(_desktopSize);

    final router = _createRouter();
    await tester.pumpWidget(_buildApp(router));
    await tester.pumpAndSettle();

    await act.tap(spotText('Open Detail', exact: true));
    await tester.pumpAndSettle();

    var data = tester.widget<ResponsiveMasterDetailData>(
      find.byType(ResponsiveMasterDetailData),
    );
    var detailBox =
        tester.renderObject(find.byKey(_detailContentKey)) as RenderBox;
    var detailTopLeft = detailBox.localToGlobal(Offset.zero);

    expect(detailTopLeft.dx, moreOrLessEquals(data.masterWidth));
    expect(detailTopLeft.dx, greaterThan(0));
    expect(detailBox.size.width, moreOrLessEquals(data.detailWidth));
    expect(data.isDetailOverMaster, isFalse);

    await tester.binding.setSurfaceSize(_mobileSize);
    await tester.pumpAndSettle();

    data = tester.widget<ResponsiveMasterDetailData>(
      find.byType(ResponsiveMasterDetailData),
    );
    detailBox = tester.renderObject(find.byKey(_detailContentKey)) as RenderBox;
    detailTopLeft = detailBox.localToGlobal(Offset.zero);

    expect(detailTopLeft.dx, moreOrLessEquals(0));
    expect(detailBox.size.width, moreOrLessEquals(_mobileSize.width));
    expect(data.isDetailOverMaster, isTrue);
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
          detailPlaceholder: const ColoredBox(
            color: Colors.black12,
            child: SizedBox.expand(),
          ),
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
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Master Page'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                MasterDetailShell.of(
                  context,
                ).openDetails(const PageRouteInfo<void>(_detailRouteName));
              },
              child: const Text('Open Detail'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SizedBox.expand(
        key: _detailContentKey,
        child: const Center(child: Text('Detail Page')),
      ),
    );
  }
}
