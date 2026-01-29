import 'package:flutter/material.dart';

import 'app_router.dart';

void main() {
  runApp(const TodoExampleApp());
}

class TodoExampleApp extends StatefulWidget {
  const TodoExampleApp({super.key});

  @override
  State<TodoExampleApp> createState() => _TodoExampleAppState();
}

class _TodoExampleAppState extends State<TodoExampleApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routerConfig: _router.config(
        // Needed to build the full stack when the user adds a url to e.g. Chrome
        // and not just the last matching page / route.
        includePrefixMatches: true,
      ),
    );
  }
}
