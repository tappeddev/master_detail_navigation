import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class NonExclusiveModalScope<T> extends StatelessWidget {
  const NonExclusiveModalScope({
    super.key,
    required this.builder,
    required this.sortKey,
    required this.isFocusable,
  });

  final WidgetBuilder builder;
  final double sortKey;
  final bool isFocusable;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      excluding: !isFocusable,
      child: ExcludeFocus(
        excluding: !isFocusable,
        child: Semantics(
          sortKey: OrdinalSortKey(sortKey),
          child: builder(context),
        ),
      ),
    );
  }
}
