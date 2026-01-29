import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class NonExclusiveModalScope<T> extends StatefulWidget {
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
  State<NonExclusiveModalScope<T>> createState() =>
      _NonExclusiveModalScopeState<T>();
}

class _NonExclusiveModalScopeState<T> extends State<NonExclusiveModalScope<T>> {
  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      excluding: !widget.isFocusable,
      child: ExcludeFocus(
        excluding: !widget.isFocusable,
        child: Semantics(
          sortKey: OrdinalSortKey(widget.sortKey),
          child: widget.builder(context),
        ),
      ),
    );
  }
}
