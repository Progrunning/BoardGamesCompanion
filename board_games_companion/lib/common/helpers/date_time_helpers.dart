/// The [weekday] may be 0 for Sunday, 1 for Monday, etc. up to 7 for Sunday.
DateTime mostRecentWeekday(DateTime date, int weekday) =>
    DateTime(date.year, date.month, date.day - (date.weekday - weekday) % 7);
