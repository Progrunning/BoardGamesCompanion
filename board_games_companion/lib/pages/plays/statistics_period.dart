class StatisticsPeriod {
  const StatisticsPeriod._({
    required this.from,
    required this.to,
  });

  // TODO Fix the dates
  factory StatisticsPeriod.lastWeek() =>
      StatisticsPeriod._(from: DateTime.now().add(const Duration(days: -7)), to: DateTime.now());

  final DateTime from;
  final DateTime to;
}
