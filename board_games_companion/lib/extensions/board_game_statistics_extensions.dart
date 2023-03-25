import 'package:board_games_companion/models/board_game_statistics.dart';

extension BoardGameStatisticsExtensions on ScoreBoardGameStatistics {
  int? get averagePlaytimeInSeconds {
    if (totalPlaytimeInSeconds == null || numberOfGamesPlayed == null) {
      return null;
    }

    return (totalPlaytimeInSeconds! / numberOfGamesPlayed!).floor();
  }
}
