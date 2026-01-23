import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_navigation/master_detail_navigation.dart';

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
          detailPlaceholder: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.list_alt_outlined,
                    size: 48,
                    color: Colors.black38,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Select a todo',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
