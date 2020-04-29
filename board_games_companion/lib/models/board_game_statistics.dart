import 'package:board_games_companion/models/player_score.dart';

class BoardGameStatistics {
  DateTime _lastPlayed;
  DateTime get lastPlayed => _lastPlayed;
  set lastPlayed(DateTime value) {
    if (_lastPlayed != value) {
      _lastPlayed = value;
    }
  }

  PlayerScore _lastWinner;
  PlayerScore get lastWinner => _lastWinner;
  set lastWinner(PlayerScore value) {
    if (_lastWinner != value) {
      _lastWinner = value;
    }
  }

  int _numberOfGamesPlayed;
  int get numberOfGamesPlayed => _numberOfGamesPlayed;
  set numberOfGamesPlayed(int value) {
    if (_numberOfGamesPlayed != value) {
      _numberOfGamesPlayed = value;
    }
  }

  int _averagePlaytimeInSeconds;
  int get averagePlaytimeInSeconds => _averagePlaytimeInSeconds;
  set averagePlaytimeInSeconds(int value) {
    if (_averagePlaytimeInSeconds != value) {
      _averagePlaytimeInSeconds = value;
    }
  }

  String _highscore;
  String get highscore => _highscore;
  set highscore(String value) {
    if (_highscore != value) {
      _highscore = value;
    }
  }
}
