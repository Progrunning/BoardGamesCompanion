import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/base_board_game.dart';
import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:hive/hive.dart';

part 'board_game_details.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesDetailsTypeId)
class BoardGameDetails extends BaseBoardGame {
  BoardGameDetails([String name]) : super(name);

  String _imageUrl;
  @HiveField(5)
  String get imageUrl => _imageUrl;
  @HiveField(5)
  set imageUrl(String value) {
    if (_imageUrl != value) {
      _imageUrl = value;
      notifyListeners();
    }
  }

  String _description;
  @HiveField(6)
  String get description => _description;
  @HiveField(6)
  set description(String value) {
    if (_description != value) {
      _description = value;
      notifyListeners();
    }
  }

  @HiveField(7)
  List<BoardGameCategory> categories = List<BoardGameCategory>();

  double _rating;
  @HiveField(8)
  double get rating => _rating;
  @HiveField(8)
  set rating(double value) {
    if (_rating != value) {
      _rating = value;
      notifyListeners();
    }
  }

  int _votes;
  @HiveField(9)
  int get votes => _votes;
  @HiveField(9)
  set votes(int value) {
    if (_votes != value) {
      _votes = value;
      notifyListeners();
    }
  }

  DateTime _lastPlayed;
  DateTime get lastPlayed => _lastPlayed;
  set lastPlayed(DateTime value) {
    if (_lastPlayed != value) {
      _lastPlayed = value;
      notifyListeners();
    }
  }

  PlayerScore _lastWinner;
  PlayerScore get lastWinner => _lastWinner;
  set lastWinner(PlayerScore value) {
    if (_lastWinner != value) {
      _lastWinner = value;
      notifyListeners();
    }
  }

  int _numberOfGamesPlayed;
  int get numberOfGamesPlayed => _numberOfGamesPlayed;
  set numberOfGamesPlayed(int value) {
    if (_numberOfGamesPlayed != value) {
      _numberOfGamesPlayed = value;
      notifyListeners();
    }
  }

  int _averagePlaytimeInSeconds;
  int get averagePlaytimeInSeconds => _averagePlaytimeInSeconds;
  set averagePlaytimeInSeconds(int value) {
    if (_averagePlaytimeInSeconds != value) {
      _averagePlaytimeInSeconds = value;
      notifyListeners();
    }
  }

  String _highscore;
  String get highscore => _highscore;
  set highscore(String value) {
    if (_highscore != value) {
      _highscore = value;
      notifyListeners();
    }
  }
}
