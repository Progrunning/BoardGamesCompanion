import 'hive/player.dart';

class PlayerStatistics {
  PlayerStatistics(this.player);

  final Player player;

  num? personalBestScore;

  num? averageScore;

  int? numberOfGamesPlayed;
}
