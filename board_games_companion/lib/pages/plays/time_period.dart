import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/plays_stats_preset_time_period.dart';

part 'time_period.freezed.dart';

@freezed
class TimePeriod with _$TimePeriod {
  const factory TimePeriod({
    required PlayStatsPresetTimePeriod presetTimePeriod,
    required DateTime earliestPlaythrough,
    required DateTime from,
    required DateTime to,
  }) = _TimePeriod;

  const TimePeriod._();

  /// Returns the difference in days between [to] and [from] in the period.
  ///
  /// NOTE: Adding +1 day to the difference because the time period is between
  /// 00:00 and 23:59:59, which makes the calculation always short by a day
  int get daysInPeriod => to.difference(from).inDays + 1;
}
