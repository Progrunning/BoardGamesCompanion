import 'dart:io';

import 'package:hive/hive.dart';

import '../../common/constants.dart';
import '../../common/hive_boxes.dart';
import 'base_board_game.dart';
import 'board_game_artist.dart';
import 'board_game_category.dart';
import 'board_game_designer.dart';
import 'board_game_expansion.dart';
import 'board_game_publisher.dart';
import 'board_game_rank.dart';

part 'board_game_details.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesDetailsTypeId)
class BoardGameDetails extends BaseBoardGame {
  BoardGameDetails([String name]) : super(name);

  final RegExp onlyLettersOrNumbersRegex = RegExp(r'[a-zA-Z0-9]+');

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

  DateTime _lastModified;
  @HiveField(21)
  DateTime get lastModified => _lastModified;
  @HiveField(21)
  set lastModified(DateTime value) {
    if (_lastModified != value) {
      _lastModified = value;
      notifyListeners();
    }
  }

  @HiveField(22)
  List<BoardGamesExpansion> expansions = List<BoardGamesExpansion>();

  int get expansionsOwned {
    return expansions
            ?.where((expansion) => expansion?.isInCollection ?? false)
            ?.length ??
        0;
  }

  bool _isExpansion;
  @HiveField(23)
  bool get isExpansion => _isExpansion;
  @HiveField(23)
  set isExpansion(bool value) {
    if (_isExpansion != value) {
      _isExpansion = value;
      notifyListeners();
    }
  }

  String get playtimeFormatted {
    if (_minPlaytime == _maxPlaytime) {
      return '$minPlaytime';
    }

    return '$minPlaytime - $maxPlaytime';
  }

  String get rankFormatted {
    if (rank != null) {
      return rank.toString();
    } else if (ranks?.isNotEmpty ?? false) {
      final overallRank = ranks?.first?.rank;
      return overallRank?.toString() ?? 'Not Ranked';
    }

    return null;
  }

  String get bggOverviewUrl => '$_baseBggBoardGameUrl/$id/$_urlEncodeName';

  String get bggHotVideosUrl => '$bggOverviewUrl/videos/all?sort=hot';

  String get bggHotForumUrl => '$bggOverviewUrl/forums/0?sort=hot';

  String get boardGameOraclePriceUrl {
    final String currentCulture = Platform.localeName.replaceFirst('_', '-');
    if (!Constants.BoardGameOracleSupportedCultureNames.contains(
            currentCulture) ||
        currentCulture == Constants.BoardGameOracleUsaCultureName) {
      return '${Constants.BoardGameOracleBaseUrl}boardgame/price/$_urlEncodeName';
    }

    return '${Constants.BoardGameOracleBaseUrl}$currentCulture/boardgame/price/$_urlEncodeName';
  }

  String get _baseBggBoardGameUrl =>
      '${Constants.BoardGameGeekBaseUrl}boardgame';

  String get _urlEncodeName {
    final List<String> spaceSeparatedNameParts = name.split(' ');
    return spaceSeparatedNameParts
        .map((part) {
          final String trimmedAndLoweredPart = part.trim().toLowerCase();
          final String regexMatch =
              onlyLettersOrNumbersRegex.stringMatch(trimmedAndLoweredPart);
          return regexMatch;
        })
        .where((part) => part != null)
        .join('-');
  }
}
