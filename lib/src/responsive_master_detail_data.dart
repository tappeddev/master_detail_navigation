import 'package:flutter/cupertino.dart';

class ResponsiveMasterDetailData extends InheritedWidget {
  final double masterWidth;
  final double detailWidth;
  final double detailX;
  final double maxHeight;
  final bool detailsVisible;

  /// [true] when the detail route completely covers the master route.
  /// This only happens on mobile screen sizes.
  final bool isDetailOverMaster;

  const ResponsiveMasterDetailData({
    super.key,
    required super.child,
    required this.masterWidth,
    required this.detailWidth,
    required this.detailX,
    required this.maxHeight,
    required this.detailsVisible,
    required this.isDetailOverMaster,
  });

  static ResponsiveMasterDetailData of(BuildContext context) {
    final ResponsiveMasterDetailData? result = context
        .dependOnInheritedWidgetOfExactType<ResponsiveMasterDetailData>();
    assert(result != null, 'No ResponsiveMasterDetailData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ResponsiveMasterDetailData old) {
    return masterWidth != old.masterWidth ||
        detailWidth != old.detailWidth ||
        detailX != old.detailX ||
        maxHeight != old.maxHeight ||
        detailsVisible != old.detailsVisible ||
        isDetailOverMaster != old.isDetailOverMaster;
  }
}
