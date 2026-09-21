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
