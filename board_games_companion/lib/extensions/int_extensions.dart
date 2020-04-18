import 'package:board_games_companion/common/constants.dart';

extension IntExtensions on int {
  String toOrdinalAbbreviations() {
    if (this == null) {
      return '';
    }

    switch (this % 100) {
      case 11:
      case 12:
      case 13:
        return "th";
      default:
        switch (this % 10) {
          case 1:
            return "st";
          case 2:
            return "nd";
          case 3:
            return "rd";
          default:
            return "th";
        }
    }
  }

  String toPlaythroughDuration([String fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    final hours = (this / Constants.NumberOfSecondsInHour).floor();
    final minutes = (this / Constants.NumberOfSecondsInMinute).floor();

    if (hours == 0) {
      return '${minutes}m ${this - minutes * Constants.NumberOfSecondsInMinute}s';
    }
    if (hours > 0) {
      return '${hours}h ${minutes - hours * Constants.NumberOfMinutesInHour}min';
    }

    return '${minutes}min';
  }
  
  String toAverageDuration([String fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    final hours = (this / Constants.NumberOfSecondsInHour).floor();
    final minutes = (this / Constants.NumberOfSecondsInMinute).floor();

    if (hours > 0) {
      return '~$hours.${(minutes / Constants.NumberOfMinutesInHour * 100).floor()}h';
    }

    return '~${minutes}min';
  }
}
