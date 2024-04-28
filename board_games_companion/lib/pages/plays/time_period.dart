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

  int get daysInPeriod => to.difference(from).inDays;
}
