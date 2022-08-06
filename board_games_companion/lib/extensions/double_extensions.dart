import 'dart:math';

import '../common/constants.dart';

extension NullableDoubleExtensions on double? {
  int safeCompareTo(double? doubleToCompare) {
    if (this == null && doubleToCompare == null) {
      return Constants.leaveAsIs;
    }

    if (this != null && doubleToCompare == null) {
      return Constants.moveAbove;
    }

    if (this == null && doubleToCompare != null) {
      return Constants.moveBelow;
    }

    return this!.compareTo(doubleToCompare!);
  }
}

extension DoubleExtensions on double {
  bool isBetween(double from, double to, {bool inclusive = false}) {
    if (inclusive) {
      return from <= this && this <= to;
    }

    return from < this && this < to;
  }

  double toRadians() {
    return this * pi / 180;
  }
}
