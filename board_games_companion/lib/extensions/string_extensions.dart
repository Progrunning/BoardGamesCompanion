import '../common/constants.dart';

extension StringExtensions on String? {
  int safeCompareTo(String? stringToCompare) {
    if (this == null && stringToCompare == null) {
      return Constants.leaveAsIs;
    }

    if (this != null && stringToCompare == null) {
      return Constants.moveAbove;
    }

    if (this == null && stringToCompare != null) {
      return Constants.moveBelow;
    }

    return this!.compareTo(stringToCompare!);
  }
}
