import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

import '../common/app_text.dart';
import '../common/constants.dart';

extension DateTimeExtensions on DateTime? {
  String toShortMonth([String? fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    return DateFormat(Constants.shortMonthDateFormat).format(this!);
  }

  String toShortWeek([String? fallbackValue]) {
    if (this == null) {
      return fallbackValue ?? '';
    }

    return DateFormat(Constants.shortWeekDayDateFormat).format(this!);
  }

  String toDaysAgo() {
    if (this == null) {
      return sprintf(AppText.daysAgoFormat, ['-']);
    }

    if (isToday) {
      return AppText.today;
    }
    if (isYesterday) {
      return AppText.yesteday;
    }
    if (isDayBeforeYesterday) {
      return AppText.dayBeforeYesteday;
    }

    return sprintf(AppText.daysAgoFormat, [daysAgo]);
  }

  int get daysAgo {
    final nowUtc = DateTime.now().toUtc();
    return nowUtc.difference(this!).inDays;
  }

  bool get isToday {
    final nowUtc = DateTime.now().toUtc();
    final daysAgo = nowUtc.difference(this!).inDays;

    return daysAgo == 0;
  }

  bool get isYesterday {
    final nowUtc = DateTime.now().toUtc();
    final daysAgo = nowUtc.difference(this!).inDays;

    return daysAgo == 1;
  }

  bool get isDayBeforeYesterday {
    final nowUtc = DateTime.now().toUtc();
    final daysAgo = nowUtc.difference(this!).inDays;

    return daysAgo == 2;
  }

  int safeCompareTo(DateTime? dateTimeToCompare) {
    if (this == null && dateTimeToCompare == null) {
      return Constants.leaveAsIs;
    }

    if (this != null && dateTimeToCompare == null) {
      return Constants.moveAbove;
    }

    if (this == null && dateTimeToCompare != null) {
      return Constants.moveBelow;
    }

    return this!.compareTo(dateTimeToCompare!);
  }
}
