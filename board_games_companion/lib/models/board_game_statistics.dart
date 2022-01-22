import 'package:tuple/tuple.dart';

import 'hive/player.dart';
import 'player_score.dart';

class BoardGameStatistics {
  DateTime? _lastPlayed;
  DateTime? get lastPlayed => _lastPlayed;
  set lastPlayed(DateTime? value) {
    if (_lastPlayed != value) {
      _lastPlayed = value;
    }
  }

  PlayerScore? _lastWinner;
  PlayerScore? get lastWinner => _lastWinner;
  set lastWinner(PlayerScore? value) {
    if (_lastWinner != value) {
      _lastWinner = value;
    }
  }

  int? _numberOfGamesPlayed;
  int? get numberOfGamesPlayed => _numberOfGamesPlayed;
  set numberOfGamesPlayed(int? value) {
    if (_numberOfGamesPlayed != value) {
      _numberOfGamesPlayed = value;
    }
  }

  int? _averagePlaytimeInSeconds;
  int? get averagePlaytimeInSeconds => _averagePlaytimeInSeconds;
  set averagePlaytimeInSeconds(int? value) {
    if (_averagePlaytimeInSeconds != value) {
      _averagePlaytimeInSeconds = value;
    }
  }

  num? _highscore;
  num? get highscore => _highscore;
  set highscore(num? value) {
    if (_highscore != value) {
      _highscore = value;
    }
  }

  double? _averageScore;
  double? get averageScore => _averageScore;
  set averageScore(double? value) {
    if (_averageScore != value) {
      _averageScore = value;
    }
  }

  double? _averageNumberOfPlayers;
  double? get averageNumberOfPlayers => _averageNumberOfPlayers;
  set averageNumberOfPlayers(double? value) {
    if (_averageNumberOfPlayers != value) {
      _averageNumberOfPlayers = value;
    }
  }

  List<Tuple2<Player, String>>? topScoreres;
  
  Map<Player, String>? personalBests;

  Map<int, double>? playerCountPercentage;
  
  Map<Player, int>? playerWins;
}
