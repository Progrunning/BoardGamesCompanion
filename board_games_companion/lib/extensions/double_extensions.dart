import 'package:board_games_companion/common/constants.dart';

extension DoubleExtensions on double {
  int safeCompareTo(double doubleToCompare) {
    if (this == null && doubleToCompare == null) {
      return Constants.LeaveAsIs;
    }

    if (this != null && doubleToCompare == null) {
      return Constants.MoveAbove;
    }

    if (this == null && doubleToCompare != null) {
      return Constants.MoveBelow;
    }

    return compareTo(doubleToCompare);
  }
}
