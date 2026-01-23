import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class NonExclusiveModalScope<T> extends StatefulWidget {
  const NonExclusiveModalScope({
    super.key,
    required this.route,
    required this.sortKey,
    required this.isFocusable,
  });

  final PageRouteBuilder<T> route;
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
          child: _buildModalScopeContent(),
        ),
      ),
    );
  }

  Widget _buildModalScopeContent() {
    final animation = widget.route.animation ?? kAlwaysCompleteAnimation;
    final secondaryAnimation =
        widget.route.secondaryAnimation ?? kAlwaysDismissedAnimation;

    return RepaintBoundary(
      child: widget.route.buildTransitions(
        context,
        animation,
        secondaryAnimation,
        RepaintBoundary(
          child: Builder(
            builder: (context) =>
                widget.route.buildPage(context, animation, secondaryAnimation),
          ),
        ),
      ),
    );
  }
}
