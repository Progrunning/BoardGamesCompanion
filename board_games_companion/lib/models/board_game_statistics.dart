import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuple/tuple.dart';

import 'hive/player.dart';
import 'player_score.dart';
import 'player_statistics.dart';

part 'board_game_statistics.freezed.dart';

@freezed
class BoardGameStatistics with _$BoardGameStatistics {
  const factory BoardGameStatistics.none() = _none;
  const factory BoardGameStatistics.loading() = _loading;
  const factory BoardGameStatistics.score({
    required ScoreBoardGameStatistics boardGameStatistics,
  }) = _score;
  const factory BoardGameStatistics.noScore({
    required NoScoreBoardGameStatistics boardGameStatistics,
  }) = _noScore;
}

@unfreezed
class ScoreBoardGameStatistics with _$ScoreBoardGameStatistics {
  factory ScoreBoardGameStatistics({
    required int numberOfGamesPlayed,
    required double averageNumberOfPlayers,
    required DateTime lastTimePlayed,
    required int totalPlaytimeInSeconds,
    required int averagePlaytimeInSeconds,
    required int averageScorePrecision,
    PlayerScore? lastWinner,
    num? bestScore,
    double? averageScore,
    List<Tuple2<Player, double>>? topScoreres,
    @Default(<PlayerStatistics>[]) List<PlayerStatistics> playersStatistics,
    @Default(<PlayerCountStatistics>[]) List<PlayerCountStatistics> playerCountPercentage,
    @Default(<PlayerWinsStatistics>[]) List<PlayerWinsStatistics> playerWinsPercentage,
    Map<Player, int>? playerWins,
  }) = _ScoreBoardGameStatistics;

  ScoreBoardGameStatistics._();
}

@unfreezed
class NoScoreBoardGameStatistics with _$NoScoreBoardGameStatistics {
  factory NoScoreBoardGameStatistics({
    required int numberOfGamesPlayed,
    required double averageNumberOfPlayers,
    required DateTime lastTimePlayed,
    required int totalWins,
    required int totalLosses,
    required int totalPlaytimeInSeconds,
    required int averagePlaytimeInSeconds,
    @Default(<PlayerStatistics>[]) List<PlayerStatistics> playersStatistics,
    @Default(<PlayerCountStatistics>[]) List<PlayerCountStatistics> playerCountPercentage,
  }) = _NoScoreBoardGameStatitics;

  const NoScoreBoardGameStatistics._();
}

@freezed
class PlayerWinsStatistics with _$PlayerWinsStatistics {
  const factory PlayerWinsStatistics({
    required Player player,
    required int numberOfWins,
    required double winsPercentage,
  }) = _PlayerWinsStatistics;
}

@freezed
class PlayerCountStatistics with _$PlayerCountStatistics {
  const factory PlayerCountStatistics({
    required int numberOfPlayers,
    required int numberOfGamesPlayed,
    required double gamesPlayedPercentage,
  }) = _PlayerCountStatistics;
}
