import 'dart:io';

import 'package:board_games_companion/models/hive/board_game_settings.dart';
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

@HiveType(typeId: HiveBoxes.boardGamesDetailsTypeId)
class BoardGameDetails extends BaseBoardGame {
  BoardGameDetails({required String id, required String name}) : super(id: id, name: name);

  final RegExp onlyLettersOrNumbersRegex = RegExp(r'[a-zA-Z0-9\-]+');
  final Set<String> bggNotUsedUrlEncodedNameParts = {
    'the',
    'of',
    'for',
    'a',
    'with',
    'on',
    'at',
    'by',
    'to',
    'from',
    'into',
    'but',
    'off',
    'up',
  };

  String? _imageUrl;
  @HiveField(5)
  String? get imageUrl => _imageUrl;
  @HiveField(5)
  set imageUrl(String? value) {
    if (_imageUrl != value) {
      _imageUrl = value;
      notifyListeners();
    }
  }

  String? _description;
  @HiveField(6)
  String? get description => _description;
  @HiveField(6)
  set description(String? value) {
    if (_description != value) {
      _description = value;
      notifyListeners();
    }
  }

  @HiveField(7)
  List<BoardGameCategory>? categories = <BoardGameCategory>[];

  double? _rating;
  @HiveField(8)
  double? get rating => _rating;
  @HiveField(8)
  set rating(double? value) {
    if (_rating != value) {
      _rating = value;
      notifyListeners();
    }
  }

  int? _votes;
  @HiveField(9)
  int? get votes => _votes;
  @HiveField(9)
  set votes(int? value) {
    if (_votes != value) {
      _votes = value;
      notifyListeners();
    }
  }

  int? _minPlayers;
  @HiveField(10)
  int? get minPlayers => _minPlayers;
  @HiveField(10)
  set minPlayers(int? value) {
    if (_minPlayers != value) {
      _minPlayers = value;
      notifyListeners();
    }
  }

  int? _minPlaytime;
  @HiveField(11)
  int? get minPlaytime => _minPlaytime;
  @HiveField(11)
  set minPlaytime(int? value) {
    if (_minPlaytime != value) {
      _minPlaytime = value;
      notifyListeners();
    }
  }

  int? _maxPlayers;
  @HiveField(12)
  int? get maxPlayers => _maxPlayers;
  @HiveField(12)
  set maxPlayers(int? value) {
    if (_maxPlayers != value) {
      _maxPlayers = value;
      notifyListeners();
    }
  }

  int? _maxPlaytime;
  @HiveField(13)
  int? get maxPlaytime => _maxPlaytime;
  @HiveField(13)
  set maxPlaytime(int? value) {
    if (_maxPlaytime != value) {
      _maxPlaytime = value;
      notifyListeners();
    }
  }

  int? _minAge;
  @HiveField(14)
  int? get minAge => _minAge;
  @HiveField(14)
  set minAge(int? value) {
    if (_minAge != value) {
      _minAge = value;
      notifyListeners();
    }
  }

  num? _avgWeight;
  @HiveField(15)
  num? get avgWeight => _avgWeight;
  @HiveField(15)
  set avgWeight(num? value) {
    if (_avgWeight != value) {
      _avgWeight = value;
      notifyListeners();
    }
  }

  @HiveField(16)
  List<BoardGamePublisher> publishers = <BoardGamePublisher>[];

  @HiveField(17)
  List<BoardGameArtist> artists = <BoardGameArtist>[];

  @HiveField(18)
  List<BoardGameDesigner> desingers = <BoardGameDesigner>[];

  int? _commentsNumber;
  @HiveField(19)
  int? get commentsNumber => _commentsNumber;
  @HiveField(19)
  set commentsNumber(int? value) {
    if (_commentsNumber != value) {
      _commentsNumber = value;
      notifyListeners();
    }
  }

  @HiveField(20)
  List<BoardGameRank> ranks = <BoardGameRank>[];

  DateTime? _lastModified;
  @HiveField(21)
  DateTime? get lastModified => _lastModified;
  @HiveField(21)
  set lastModified(DateTime? value) {
    if (_lastModified != value) {
      _lastModified = value;
      notifyListeners();
    }
  }

  @HiveField(22)
  List<BoardGamesExpansion> expansions = <BoardGamesExpansion>[];

  int get expansionsOwned {
    return expansions.where((expansion) => expansion.isInCollection ?? false).length;
  }

  bool? _isExpansion;
  @HiveField(23)
  bool? get isExpansion => _isExpansion;
  @HiveField(23)
  set isExpansion(bool? value) {
    if (_isExpansion != value) {
      _isExpansion = value;
      notifyListeners();
    }
  }

  bool get isMainGame => !(isExpansion ?? false);

  bool? _isOwned;
  @HiveField(24)
  bool? get isOwned => _isOwned ?? false;
  @HiveField(24)
  set isOwned(bool? value) {
    if (_isOwned != value) {
      _isOwned = value;
      notifyListeners();
    }
  }

  bool? _isOnWishlist;
  @HiveField(25)
  bool? get isOnWishlist => _isOnWishlist ?? false;
  @HiveField(25)
  set isOnWishlist(bool? value) {
    if (_isOnWishlist != value) {
      _isOnWishlist = value;
      notifyListeners();
    }
  }

  bool? _isFriends;
  @HiveField(26)
  bool? get isFriends => _isFriends ?? false;
  @HiveField(26)
  set isFriends(bool? value) {
    if (_isFriends != value) {
      _isFriends = value;
      notifyListeners();
    }
  }

  // MK Flag to indicate that the board game got synced from BGG
  //    This is important when removing BGG's user account (only these games will be removed)
  bool? _isBggSynced;
  @HiveField(27)
  bool? get isBggSynced => _isBggSynced ?? false;
  @HiveField(27)
  set isBggSynced(bool? value) {
    if (_isBggSynced != value) {
      _isBggSynced = value;
      notifyListeners();
    }
  }

  @HiveField(28)
  BoardGameSettings? settings;

  String get playtimeFormatted {
    if (_minPlaytime == _maxPlaytime) {
      return '$minPlaytime';
    }

    return '$minPlaytime - $maxPlaytime';
  }

  String? get rankFormatted {
    if (rank != null) {
      return rank.toString();
    } else if (ranks.isNotEmpty) {
      final overallRank = ranks.first.rank;
      return overallRank?.toString() ?? 'Not Ranked';
    }

    return null;
  }

  bool get hasIncompleteDetails =>
      (isBggSynced ?? false) &&
      (avgWeight == null || rating == null || commentsNumber == null || votes == null);

  String get bggOverviewUrl => '$_baseBggBoardGameUrl/$id/$_bggUrlEncodedName';

  String get bggHotVideosUrl => '$bggOverviewUrl/videos/all?sort=hot';

  String get bggHotForumUrl => '$bggOverviewUrl/forums/0?sort=hot';

  String get boardGameOraclePriceUrl {
    final String currentCulture = Platform.localeName.replaceFirst('_', '-');
    if (!Constants.boardGameOracleSupportedCultureNames.contains(currentCulture) ||
        currentCulture == Constants.boardGameOracleUsaCultureName) {
      return '${Constants.boardGameOracleBaseUrl}boardgame/price/$_boardGameOracleUrlEncodedName';
    }

    return '${Constants.boardGameOracleBaseUrl}$currentCulture/boardgame/price/$_boardGameOracleUrlEncodedName';
  }

  String get _baseBggBoardGameUrl => '${Constants.boardGameGeekBaseUrl}boardgame';

  String get _bggUrlEncodedName {
    final List<String> spaceSeparatedNameParts = name.toLowerCase().split(' ');
    return spaceSeparatedNameParts.where((part) {
      final String trimmedAndLoweredPart = part.trim();
      return !bggNotUsedUrlEncodedNameParts.contains(trimmedAndLoweredPart);
    }).map((part) {
      final String trimmedAndLoweredPart = part.trim();
      final String? regexMatch = onlyLettersOrNumbersRegex.stringMatch(trimmedAndLoweredPart);
      return regexMatch;
    }).join('-');
  }

  String get _boardGameOracleUrlEncodedName {
    final List<String> spaceSeparatedNameParts = name.toLowerCase().split(' ');
    return spaceSeparatedNameParts.map((part) {
      final String trimmedAndLoweredPart = part.trim();
      final String? regexMatch = onlyLettersOrNumbersRegex.stringMatch(trimmedAndLoweredPart);
      return regexMatch;
    }).join('-');
  }
}
