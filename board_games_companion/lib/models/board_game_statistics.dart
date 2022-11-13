import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuple/tuple.dart';

import 'hive/player.dart';
import 'player_score.dart';
import 'player_statistics.dart';

part 'board_game_statistics.freezed.dart';

class BoardGameStatistics {
  DateTime? lastPlayed;

  PlayerScore? lastWinner;

  int? numberOfGamesPlayed;

  int? totalPlaytimeInSeconds;

  int? get averagePlaytimeInSeconds {
    if (totalPlaytimeInSeconds == null || numberOfGamesPlayed == null) {
      return null;
    }

    return (totalPlaytimeInSeconds! / numberOfGamesPlayed!).floor();
  }

  num? bestScore;

  double? averageScore;

  double? averageNumberOfPlayers;

  List<Tuple2<Player, String>>? topScoreres;

  List<PlayerStatistics>? playersStatistics;

  List<PlayerCountStatistics>? playerCountPercentage;

  List<PlayerWinsStatistics>? playerWinsPercentage;

  Map<Player, int>? playerWins;
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
