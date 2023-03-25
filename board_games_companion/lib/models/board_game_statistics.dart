import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuple/tuple.dart';

import 'hive/player.dart';
import 'player_score.dart';
import 'player_statistics.dart';

export '../extensions/board_game_statistics_extensions.dart';

part 'board_game_statistics.freezed.dart';

@freezed
class BoardGameStatistics with _$BoardGameStatistics {
  const factory BoardGameStatistics.none() = _none;
  const factory BoardGameStatistics.loading() = _loading;
  const factory BoardGameStatistics.score({
    required ScoreBoardGameStatistics scoreBoardGameStatistics,
  }) = _score;
  const factory BoardGameStatistics.noScore() = _noScore;
}

@unfreezed
class ScoreBoardGameStatistics with _$ScoreBoardGameStatistics {
  factory ScoreBoardGameStatistics({
    int? numberOfGamesPlayed,
    double? averageNumberOfPlayers,
    DateTime? lastPlayed,
    PlayerScore? lastWinner,
    int? totalPlaytimeInSeconds,
    num? bestScore,
    double? averageScore,
    @Default(0) int averageScorePrecision,
    List<Tuple2<Player, String>>? topScoreres,
    List<PlayerStatistics>? playersStatistics,
    List<PlayerCountStatistics>? playerCountPercentage,
    List<PlayerWinsStatistics>? playerWinsPercentage,
    Map<Player, int>? playerWins,
  }) = _ScoreBoardGameStatistics;

  ScoreBoardGameStatistics._();
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
