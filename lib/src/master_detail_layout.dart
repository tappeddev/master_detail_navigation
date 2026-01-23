import 'package:flutter/widgets.dart';

enum MasterDetailLayoutType {
  mobile,
  desktop,
}

extension MasterDetailLayoutTypeX on MasterDetailLayoutType {
  T when<T>({
    required T Function() ifMobile,
    required T Function() ifDesktop,
  }) {
    return switch (this) {
      MasterDetailLayoutType.mobile => ifMobile(),
      MasterDetailLayoutType.desktop => ifDesktop(),
    };
  }
}

class MasterDetailLayoutValues {
  static const double _infinite = double.infinity;

  /// Returns content constraints for the current layout.
  ///
  /// By default this is unconstrained; pass max widths to apply limits.
  static BoxConstraints homeContentConstraints(
    MasterDetailLayoutType layoutType, {
    double? mobileMaxWidth,
    double? desktopMaxWidth,
  }) {
    final maxWidth = switch (layoutType) {
      MasterDetailLayoutType.mobile => mobileMaxWidth ?? _infinite,
      MasterDetailLayoutType.desktop => desktopMaxWidth ?? _infinite,
    };

    if (maxWidth.isInfinite) return const BoxConstraints();
    return BoxConstraints(maxWidth: maxWidth);
  }
}
