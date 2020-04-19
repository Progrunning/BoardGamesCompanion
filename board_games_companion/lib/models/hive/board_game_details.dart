import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/base_board_game.dart';
import 'package:board_games_companion/models/hive/board_game_artist.dart';
import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/models/hive/board_game_designer.dart';
import 'package:board_games_companion/models/hive/board_game_publisher.dart';
import 'package:board_games_companion/models/hive/board_game_rank.dart';
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

  int _minPlayers;
  @HiveField(10)
  int get minPlayers => _minPlayers;
  @HiveField(10)
  set minPlayers(int value) {
    if (_minPlayers != value) {
      _minPlayers = value;
      notifyListeners();
    }
  }

  int _minPlaytime;
  @HiveField(11)
  int get minPlaytime => _minPlaytime;
  @HiveField(11)
  set minPlaytime(int value) {
    if (_minPlaytime != value) {
      _minPlaytime = value;
      notifyListeners();
    }
  }

  int _maxPlayers;
  @HiveField(12)
  int get maxPlayers => _maxPlayers;
  @HiveField(12)
  set maxPlayers(int value) {
    if (_maxPlayers != value) {
      _maxPlayers = value;
      notifyListeners();
    }
  }

  int _maxPlaytime;
  @HiveField(13)
  int get maxPlaytime => _maxPlaytime;
  @HiveField(13)
  set maxPlaytime(int value) {
    if (_maxPlaytime != value) {
      _maxPlaytime = value;
      notifyListeners();
    }
  }

  int _minAge;
  @HiveField(14)
  int get minAge => _minAge;
  @HiveField(14)
  set minAge(int value) {
    if (_minAge != value) {
      _minAge = value;
      notifyListeners();
    }
  }

  num _avgWeight;
  @HiveField(15)
  num get avgWeight => _avgWeight;
  @HiveField(15)
  set avgWeight(num value) {
    if (_avgWeight != value) {
      _avgWeight = value;
      notifyListeners();
    }
  }

  @HiveField(16)
  List<BoardGamePublisher> publishers = List<BoardGamePublisher>();

  @HiveField(17)
  List<BoardGameArtist> artists = List<BoardGameArtist>();

  @HiveField(18)
  List<BoardGameDesigner> desingers = List<BoardGameDesigner>();

  int _commentsNumber;
  @HiveField(19)
  int get commentsNumber => _commentsNumber;
  @HiveField(19)
  set commentsNumber(int value) {
    if (_commentsNumber != value) {
      _commentsNumber = value;
      notifyListeners();
    }
  }

  @HiveField(20)
  List<BoardGameRank> ranks = List<BoardGameRank>();

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

  String get playtingFormatted {
    if (_minPlaytime == _maxPlaytime) {
      return '$minPlaytime';
    }

    return '$minPlaytime - $maxPlaytime';
  }

  String get rankFormatted {
    if (ranks?.isNotEmpty ?? false) {
      final overallRank = ranks?.first?.rank;
      return overallRank?.toString() ?? 'Not Ranked';
    }
    return null;
  }
}
