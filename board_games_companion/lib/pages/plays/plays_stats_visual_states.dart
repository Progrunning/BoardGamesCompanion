import 'package:board_games_companion/pages/plays/most_played_game.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'time_period.dart';

part 'plays_stats_visual_states.freezed.dart';

@freezed
class PlaysStatsVisualState with _$PlaysStatsVisualState {
  const factory PlaysStatsVisualState.init() = _init;
  const factory PlaysStatsVisualState.loading() = _loading;
  const factory PlaysStatsVisualState.noStatsInPeriod({
    required TimePeriod timePeriod,
  }) = _noStatsInPeriod;
  const factory PlaysStatsVisualState.stats({
    required TimePeriod timePeriod,
    required List<MostPlayedGame> mostPlayedGames,
    required int totalGamesLogged,
    required int totalGamesPlayed,
    required int totalPlaytimeInSeconds,
    required int totalDuelGamesLogged,
    required int totalMultiPlayerGamesLogged,
  }) = _stats;
  const factory PlaysStatsVisualState.empty() = _empty;
}
