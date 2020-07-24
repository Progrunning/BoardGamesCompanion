import 'package:board_games_companion/common/constants.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toShortMonth([String fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    return DateFormat(Constants.ShortMonthDateFormat).format(this);
  }

  String toShortWeek([String fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    return DateFormat(Constants.ShortWeekDayDateFormat).format(this);
  }

  String toDaysAgo() {
    final daysAgoText = 'day(s) ago';
    if (this == null) {
      return '- $daysAgoText';
    }

    final nowUtc = DateTime.now().toUtc();
    final daysAgo = nowUtc.difference(this).inDays;

    return '$daysAgo $daysAgoText';
  }

  int safeCompareTo(DateTime dateTimeToCompare) {
    if (this == null && dateTimeToCompare == null) {
      return Constants.LeaveAsIs;
    }

    if (this != null && dateTimeToCompare == null) {
      return Constants.MoveAbove;
    }

    if (this == null && dateTimeToCompare != null) {
      return Constants.MoveBelow;
    }

    return this.compareTo(dateTimeToCompare);
  }
}
