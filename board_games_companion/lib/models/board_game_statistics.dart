import 'package:tuple/tuple.dart';

import 'hive/player.dart';
import 'player_score.dart';
import 'player_statistics.dart';

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

  num? highscore;

  double? averageScore;

  double? averageNumberOfPlayers;

  List<Tuple2<Player, String>>? topScoreres;

  List<PlayerStatistics>? playersStatistics;

  Map<int, double>? playerCountPercentage;

  Map<Player, double>? playerWinsPercentage;

  Map<Player, int>? playerWins;
}
