import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/models/player_statistics.dart';

extension PlayerStatisticsExtensions on Iterable<PlayerStatistics> {
  Iterable<PlayerStatistics> get sortByResult => [...this]..sort((playerStats, otherPlayerStats) {
      return playerStats.when(
        scoreGames: (player, personalBest, averageScore, totalGamesPlayed) {
          return otherPlayerStats.maybeWhen(
            scoreGames:
                (otherPlayer, otherPersonalBest, otherAverageScore, otherTotalGamesPlayed) =>
                    otherPersonalBest.compareTo(personalBest),
            orElse: () => Constants.moveAbove,
          );
        },
        noScoreGames: (player, totalGamesPlayed, totalWins, totalLosses) {
          return otherPlayerStats.maybeWhen(
            noScoreGames: (otherPlayer, otherTotalGamesPlayed, otherTotalWins, otherTotalLosses) =>
                otherTotalWins.compareTo(totalWins),
            orElse: () => Constants.moveAbove,
          );
        },
      );
    });
}
