import 'package:board_games_companion/pages/plays/most_played_game.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plays_stats_visual_states.freezed.dart';

@freezed
class PlaysStatsVisualState with _$PlaysStatsVisualState {
  const factory PlaysStatsVisualState.init() = _init;
  const factory PlaysStatsVisualState.loading() = _loading;
  const factory PlaysStatsVisualState.stats({
    required List<MostPlayedGame> mostPlayedGames,
    required int totalGamesLogged,
    required int totalGamesPlayed,
    required int totalPlaytimeInSeconds,
    required int totalDuelGamesLogged,
    required int totalMultiPlayerGamesLogged,
  }) = _stats;
  const factory PlaysStatsVisualState.empty() = _empty;
}
