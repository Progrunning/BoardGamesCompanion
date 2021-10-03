import 'package:intl/intl.dart';

import '../common/constants.dart';

extension DateTimeExtensions on DateTime? {
  String toShortMonth([String? fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    return DateFormat(Constants.ShortMonthDateFormat).format(this!);
  }

  String toShortWeek([String? fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    return DateFormat(Constants.ShortWeekDayDateFormat).format(this!);
  }

  String toDaysAgo() {
    const String daysAgoText = 'days ago';
    if (this == null) {
      return '- $daysAgoText';
    }

    final nowUtc = DateTime.now().toUtc();
    final daysAgo = nowUtc.difference(this!).inDays;
    if (daysAgo == 0) {
      return 'today';
    }
    if (daysAgo == 1) {
      return 'yesterday';
    }
    if (daysAgo == 2) {
      return 'day before yesterday';
    }

    return '$daysAgo $daysAgoText';
  }

  int safeCompareTo(DateTime? dateTimeToCompare) {
    if (this == null && dateTimeToCompare == null) {
      return Constants.LeaveAsIs;
    }

    if (this != null && dateTimeToCompare == null) {
      return Constants.MoveAbove;
    }

    if (this == null && dateTimeToCompare != null) {
      return Constants.MoveBelow;
    }

    return compareTo(dateTimeToCompare!);
  }
}
