import 'package:flutter/widgets.dart';

enum MasterDetailLayoutType { mobile, desktop }

extension MasterDetailLayoutTypeX on MasterDetailLayoutType {
  T when<T>({required T Function() ifMobile, required T Function() ifDesktop}) {
    return switch (this) {
      MasterDetailLayoutType.mobile => ifMobile(),
      MasterDetailLayoutType.desktop => ifDesktop(),
    };
  }
}
