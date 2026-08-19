import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/player_overall_statistics.dart';

part 'player_statistics_visual_state.freezed.dart';

@freezed
class PlayerStatisticsVisualState with _$PlayerStatisticsVisualState {
  const factory PlayerStatisticsVisualState.loading() = PlayerStatisticsLoading;
  const factory PlayerStatisticsVisualState.empty() = PlayerStatisticsEmpty;
  const factory PlayerStatisticsVisualState.loaded(PlayerOverallStatistics statistics) =
      PlayerStatisticsLoaded;
}
