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

  String toPlaythroughDuration([String? fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    final hours = (this! / Duration.secondsPerHour).floor();
    final minutes = (this! / Duration.secondsPerMinute).floor();

    if (hours == 0) {
      return '${minutes}m ${this! - minutes * Duration.secondsPerMinute}s';
    }
    if (hours > 0) {
      return '${hours}h ${minutes - hours * Duration.minutesPerHour}min';
    }

    return '${minutes}min';
  }

  String toAverageDuration([String? fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    final hours = (this! / Duration.secondsPerHour).floor();
    final minutes = (this! / Duration.secondsPerMinute).floor();

    if (hours > 0) {
      return '~${hours}h ${minutes % Duration.minutesPerHour}min';
    }

    return '~${minutes}min';
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
