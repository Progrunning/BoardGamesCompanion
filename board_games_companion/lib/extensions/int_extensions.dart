import 'package:sprintf/sprintf.dart';

import '../common/app_text.dart';
import '../common/constants.dart';

extension IntExtensions on int? {
  String toOrdinalAbbreviations() {
    if (this == null) {
      return '';
    }

    switch (this! % 100) {
      case 11:
      case 12:
      case 13:
        return 'th';
      default:
        switch (this! % 10) {
          case 1:
            return 'st';
          case 2:
            return 'nd';
          case 3:
            return 'rd';
          default:
            return 'th';
        }
    }
  }

  String toPlaytimeDuration([String? fallbackValue, bool showSeconds = true]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    final days = (this! / Duration.secondsPerDay).floor();
    final hours = (this! / Duration.secondsPerHour).floor();
    final minutes = (this! / Duration.secondsPerMinute).floor();

    if (days > 0) {
      return sprintf(
        AppText.playtimeDurationDaysFormat,
        [days, if (days > 1) 's' else '', hours - days * Duration.hoursPerDay],
      );
    }
    if (hours > 0) {
      return sprintf(
        AppText.playtimeDurationHoursFormat,
        [hours, minutes % Duration.minutesPerHour],
      );
    }
    if (hours == 0 && showSeconds) {
      return '${minutes}m ${this! - minutes * Duration.secondsPerMinute}s';
    }

    return '${minutes}min';
  }

  int safeCompareTo(int? intToCompare) {
    if (this == null && intToCompare == null) {
      return Constants.LeaveAsIs;
    }

    if (this != null && intToCompare == null) {
      return Constants.MoveAbove;
    }

    if (this == null && intToCompare != null) {
      return Constants.MoveBelow;
    }

    return this!.compareTo(intToCompare!);
  }
}
