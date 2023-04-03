import 'package:freezed_annotation/freezed_annotation.dart';

import 'hive/player.dart';

export '../extensions/player_statistics_extensions.dart';

part 'player_statistics.freezed.dart';

@freezed
class PlayerStatistics with _$PlayerStatistics {
  const factory PlayerStatistics.scoreGames({
    required Player player,
    required int personalBestScore,
    required num averageScore,
    required int totalGamesPlayed,
  }) = _scoreGames;
  const factory PlayerStatistics.noScoreGames({
    required Player player,
    required int totalGamesPlayed,
    required int totalWins,
    required int totalLosses,
  }) = _noScoreGames;
}
