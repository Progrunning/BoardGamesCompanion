import '../common/constants.dart';

extension StringExtensions on String? {
  int safeCompareTo(String? stringToCompare) {
    if (this == null && stringToCompare == null) {
      return Constants.LeaveAsIs;
    }

    if (this != null && stringToCompare == null) {
      return Constants.MoveAbove;
    }

    if (this == null && stringToCompare != null) {
      return Constants.MoveBelow;
    }

    return this!.compareTo(stringToCompare!);
  }
}
