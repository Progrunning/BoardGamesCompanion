import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:basics/basics.dart';
import 'package:board_games_companion/utilities/caching_http_client.dart';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:xml/xml.dart';

import '../common/enums/collection_type.dart';
import '../common/enums/game_family.dart';
import '../common/exceptions/bgg_retry_exception.dart';
import '../extensions/xml_element_extensions.dart';
import '../models/bgg/bgg_import_plays.dart';
import '../models/bgg/bgg_play.dart';
import '../models/bgg/bgg_play_player.dart';
import '../models/bgg/bgg_plays_import_result.dart';
import '../models/collection_import_result.dart';
import '../models/hive/board_game_artist.dart';
import '../models/hive/board_game_category.dart';
import '../models/hive/board_game_designer.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/board_game_expansion.dart';
import '../models/hive/board_game_publisher.dart';
import '../models/hive/board_game_rank.dart';
import '../models/import_result.dart';
import '../models/parse_collection_xml_arguments.dart';
import '../models/parse_plays_xml_arguments.dart';
import '../utilities/base_http_client.dart';

const String _xmlErrorElementName = 'error';
const String _xmlItemElementName = 'item';
const String _xmlPlayElementName = 'play';
const String _xmlPlayerElementName = 'player';
const String _xmlNameElementName = 'name';
const String _xmlDescriptionElementName = 'description';
const String _xmlMinPlayersElementName = 'minplayers';
const String _xmlMaxPlayersElementName = 'maxplayers';
const String _xmlMinPlaytimeElementName = 'minplaytime';
const String _xmlMaxPlaytimeElementName = 'maxplaytime';
const String _xmlMinAgeElementName = 'minage';
const String _xmlYearPublishedElementName = 'yearpublished';
const String _xmlImageElementName = 'image';
const String _xmlThumbnailElementName = 'thumbnail';
const String _xmlLinkElementName = 'link';
const String _xmlStatisticsElementName = 'statistics';
const String _xmlStatsElementName = 'stats';
const String _xmlRatingsElementName = 'ratings';
const String _xmlRatingElementName = 'rating';
const String _xmlRanksElementName = 'ranks';
const String _xmlRankElementName = 'rank';
const String _xmlAverageElementName = 'average';
const String _xmlUsersRatedElementName = 'usersrated';
const String _xmlNumCommentsElementName = 'numcomments';
const String _xmlAverageWeightElementName = 'averageweight';
const String _xmlStatusElementName = 'status';
const String _xmlIdAttributeName = 'id';
const String _xmlTypeAttributeName = 'type';
const String _xmlValueAttributeName = 'value';
const String _xmlNameAttributeName = 'name';
const String _xmlUsernameAttributeName = 'username';
const String _xmlUserIdAttributeName = 'userid';
const String _xmlScoreAttributeName = 'score';
const String _xmlWinAttributeName = 'win';
const String _xmlRankAttributeName = 'rank';
const String _xmlFriendlyNameAttributeName = 'friendlyname';
const String _xmlCategoryAttributeTypeName = 'boardgamecategory';
const String _xmlDesignerAttributeTypeName = 'boardgamedesigner';
const String _xmlArtistAttributeTypeName = 'boardgameartist';
const String _xmlPublisherAttributeTypeName = 'boardgamepublisher';
const String _xmlExpansionAttributeTypeName = 'boardgameexpansion';
const String _xmlObjectIdAttributeTypeName = 'objectid';
const String _xmlLengthAttributeTypeName = 'length';
const String _xmlDateAttributeTypeName = 'date';
const String _xmlIncompleteAttributeTypeName = 'incomplete';
const String _xmlLastModifiedAttributeTypeName = 'lastmodified';

const int _playerWinIndicator = 1;

class BoardGamesGeekService {
  BoardGamesGeekService({
    required CachingHttpClient gameDetailsCachingHttpClient,
    required CachingHttpClient hotGamesCachingHttpClient,
    required BaseHttpClient baseHttpClient,
  })  : _gameDetailsCachingHttpClient = gameDetailsCachingHttpClient,
        _hotGamesCachingHttpClient = hotGamesCachingHttpClient,
        _baseHttpClient = baseHttpClient;

  static const String _bggApiBaseUrl = 'boardgamegeek.com';

  static const String _boardGameQueryParamterType = 'type';
  static const String _boardGameQueryParamterUsername = 'username';
  static const String _boardGameQueryParamterOwn = 'own';
  static const String _boardGameQueryParamterWishlist = 'wishlist';
  static const String _boardGameQueryParamterWantToBuy = 'wanttobuy';
  static const String _boardGameQueryParamterStats = 'stats';
  static const String _boardGameQueryParamterId = 'id';
  static const String _boardGameQueryParamterPageNumber = 'page';
  static const String _boardGameType = 'boardgame';
  static const String _boardGameExpansionType = 'boardgameexpansion';

  static const int _bggRetryStatusCode = 202;
  static const Duration _bggRetryDelayFactor = Duration(milliseconds: 600);
  static const int _maxBackoffDurationInSeconts = 8;

  final CachingHttpClient _gameDetailsCachingHttpClient;
  final CachingHttpClient _hotGamesCachingHttpClient;
  final BaseHttpClient _baseHttpClient;

  Future<List<BoardGameDetails>> getHot({int retryCount = 0}) async {
    final hotBoardGames = <BoardGameDetails>[];

    // MK Apply exponential backoff when retrying
    if (retryCount > 0) {
      await Future<void>.delayed(
        Duration(seconds: min(pow(retryCount, 2), _maxBackoffDurationInSeconts) as int),
      );
    }

    final url = Uri.https(
      _bggApiBaseUrl,
      'xmlapi2/hot',
      <String, dynamic>{_boardGameQueryParamterType: _boardGameType},
    );
    final hotBoardGamesResponse = await _hotGamesCachingHttpClient.get(url);

    try {
      final hotBoardGamesXmlDocument = _retrieveXmlDocument(hotBoardGamesResponse.body);
      final hotBoardGameItems =
          hotBoardGamesXmlDocument?.findAllElements(_xmlItemElementName) ?? [];
      for (final hotBoardGameItem in hotBoardGameItems) {
        final hotBoardGameName = hotBoardGameItem.firstOrDefaultElementsAttribute(
            _xmlNameElementName, _xmlValueAttributeName)!;

        if (hotBoardGameName.isEmpty) {
          continue;
        }

        final String? hotBoardGameId = hotBoardGameItem.getAttribute(_xmlIdAttributeName);
        if (hotBoardGameId == null) {
          continue;
        }

        final newHotBoardGame = BoardGameDetails(
          id: hotBoardGameId,
          name: hotBoardGameName,
          rank: int.tryParse(hotBoardGameItem.getAttribute(_xmlRankAttributeName) ?? ''),
          thumbnailUrl: hotBoardGameItem.firstOrDefaultElementsAttribute(
              _xmlThumbnailElementName, _xmlValueAttributeName),
          yearPublished: int.tryParse(hotBoardGameItem.firstOrDefaultElementsAttribute(
                  _xmlYearPublishedElementName, _xmlValueAttributeName) ??
              ''),
        );

        hotBoardGames.add(newHotBoardGame);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return hotBoardGames;
  }

  Future<BoardGameDetails?> getDetails(String id) async {
    if (id.isEmpty) {
      return null;
    }

    final url = Uri.https(
      _bggApiBaseUrl,
      'xmlapi2/thing',
      <String, dynamic>{
        _boardGameQueryParamterId: id,
        _boardGameQueryParamterStats: '1',
      },
    );
    final boardGameDetailsResponse = await _gameDetailsCachingHttpClient.get(url);

    try {
      final boardGameDetailsXmlDocument = _retrieveXmlDocument(boardGameDetailsResponse.body)!;
      final boardGameDetailsItem =
          boardGameDetailsXmlDocument.findAllElements(_xmlItemElementName).single;

      if (boardGameDetailsItem == null) {
        return null;
      }

      final boardGameDetailName = boardGameDetailsItem
          .firstOrDefault(_xmlNameElementName)
          ?.firstOrDefaultAttributeWhere((attr) {
        return attr.name.local == _xmlValueAttributeName;
      })?.value;

      if (boardGameDetailName?.isEmpty ?? true) {
        return null;
      }

      final boardGameType =
          boardGameDetailsItem.firstOrDefaultAttributeValue(_xmlTypeAttributeName);
      final isExpansion = boardGameType == _boardGameExpansionType;

      // When using "value" as suggested in the deprecated instructions the string is alaways empty
      // ignore: deprecated_member_use
      final description = boardGameDetailsItem.firstOrDefault(_xmlDescriptionElementName)?.text;

      final minPlayers = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMinPlayersElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final maxPlayers = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMaxPlayersElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final minPlaytime = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMinPlaytimeElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final maxPlaytime = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMaxPlaytimeElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final minAge = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMinAgeElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      // When using "value" as suggested in the deprecated instructions the string is alaways empty
      // ignore: deprecated_member_use
      final imageUrl = boardGameDetailsItem.firstOrDefault(_xmlImageElementName)?.text;

      // When using "value" as suggested in the deprecated instructions the string is alaways empty
      // ignore: deprecated_member_use
      final thumbnailUrl = boardGameDetailsItem.firstOrDefault(_xmlThumbnailElementName)?.text;

      final yearPublished = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlYearPublishedElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final List<BoardGameCategory> categories = [];
      final List<BoardGameDesigner> desingers = [];
      final List<BoardGamePublisher> publishers = [];
      final List<BoardGameArtist> artists = [];
      final List<BoardGameExpansion> expansions = [];
      final boardGameLinks = boardGameDetailsItem.findElements(_xmlLinkElementName);
      _extractBoardGameLinks(
        boardGameLinks,
        categories,
        desingers,
        publishers,
        artists,
        expansions,
      );

      final boardGameDetailStatistics =
          boardGameDetailsItem.firstOrDefault(_xmlStatisticsElementName)!;
      final boardGameDetailsRatings =
          boardGameDetailStatistics.firstOrDefault(_xmlRatingsElementName)!;

      final rating = double.tryParse(boardGameDetailsRatings
              .firstOrDefault(_xmlAverageElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final votes = int.tryParse(boardGameDetailsRatings
              .firstOrDefault(_xmlUsersRatedElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final commentsNumber = int.tryParse(boardGameDetailsRatings
              .firstOrDefault(_xmlNumCommentsElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final avgWeight = num.tryParse(boardGameDetailsRatings
              .firstOrDefault(_xmlAverageWeightElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final List<BoardGameRank> ranks = _extractBoardGameRanks(boardGameDetailsRatings);
      final int? rank =
          ranks.firstWhereOrNull((element) => element.name == 'boardgame')?.rank?.toInt();

      return BoardGameDetails(
        id: id,
        name: boardGameDetailName!,
        isExpansion: isExpansion,
        description: description,
        minPlayers: minPlayers,
        maxPlayers: maxPlayers,
        minPlaytime: minPlaytime,
        maxPlaytime: maxPlaytime,
        minAge: minAge,
        imageUrl: imageUrl,
        thumbnailUrl: thumbnailUrl,
        yearPublished: yearPublished,
        categories: categories,
        desingers: desingers,
        publishers: publishers,
        artists: artists,
        expansions: expansions,
        rating: rating,
        votes: votes,
        commentsNumber: commentsNumber,
        avgWeight: avgWeight,
        rank: rank,
        ranks: ranks,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  Future<CollectionImportResult> importCollections(String username) async {
    if (username.isEmpty) {
      return CollectionImportResult();
    }

    final ownGameImportResult = await _importCollection(
      username,
      CollectionType.owned,
      <String, dynamic>{_boardGameQueryParamterOwn: '1'},
    );
    final wishlistGameImportResult = await _importCollection(
      username,
      CollectionType.wishlist,
      <String, dynamic>{_boardGameQueryParamterWishlist: '1'},
    );
    final wantToBuyGameImportResult = await _importCollection(
      username,
      CollectionType.wishlist,
      <String, dynamic>{_boardGameQueryParamterWantToBuy: '1'},
    );

    return CollectionImportResult()
      ..isSuccess = ownGameImportResult.isSuccess &&
          wishlistGameImportResult.isSuccess &&
          wantToBuyGameImportResult.isSuccess
      ..errors = [
        ...ownGameImportResult.errors ?? <ImportError>[],
        ...wishlistGameImportResult.errors ?? <ImportError>[],
        ...wantToBuyGameImportResult.errors ?? <ImportError>[]
      ]
      ..data = [
        ...ownGameImportResult.data ?? <BoardGameDetails>[],
        ...wishlistGameImportResult.data ?? <BoardGameDetails>[],
        ...wantToBuyGameImportResult.data ?? <BoardGameDetails>[]
      ];
  }

  Future<BggPlaysImportResult> importPlays(BggImportPlays bggImportPlays) async {
    if (bggImportPlays.username.isEmpty) {
      return BggPlaysImportResult.failure([ImportError('Username is empty')]);
    }

    final queryParamters = <String, dynamic>{
      _boardGameQueryParamterUsername: bggImportPlays.username,
      _boardGameQueryParamterId: bggImportPlays.boardGameId,
      _boardGameQueryParamterPageNumber: '${bggImportPlays.pageNumber}',
    };
    final url = Uri.https(_bggApiBaseUrl, 'xmlapi2/plays', queryParamters);

    final playsResponse = await retry(
      () async {
        final response = await _baseHttpClient.get(url);
        return response;
      },
      delayFactor: _bggRetryDelayFactor,
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    return compute(
      _parsePlaysXml,
      ParsePlaysXmlArguments(playsResponse.body, bggImportPlays.gameFamily),
    );
  }

  Future<CollectionImportResult> _importCollection(
    String username,
    CollectionType collectionType,
    Map<String, dynamic> additionalQueryParameters,
  ) async {
    final queryParamters = <String, dynamic>{
      _boardGameQueryParamterUsername: username,
      _boardGameQueryParamterStats: '1',
    };
    queryParamters.addAll(additionalQueryParameters);
    final url = Uri.https(_bggApiBaseUrl, 'xmlapi2/collection', queryParamters);

    final collectionResponse = await retry(
      () async {
        final response = await _baseHttpClient.get(url);

        if (response.statusCode == _bggRetryStatusCode) {
          throw BggRetryException();
        }

        return response;
      },
      delayFactor: _bggRetryDelayFactor,
      retryIf: (e) => e is BggRetryException,
    );

    return compute(
      _parseCollectionXml,
      ParseCollectionXmlArguments(collectionResponse.body, collectionType),
    );
  }
}

BggPlaysImportResult _parsePlaysXml(ParsePlaysXmlArguments arguments) {
  XmlDocument? playsXmlDocument;
  try {
    playsXmlDocument = XmlDocument.parse(arguments.responseData!);
  } catch (e, stack) {
    return BggPlaysImportResult.failure([ImportError.exception(e, stack)]);
  }

  final playsImportResult = BggPlaysImportResult()
    ..data = []
    ..errors = [];

  final playsElements = playsXmlDocument.findAllElements(_xmlPlayElementName);
  playsImportResult.playsToImportTotal = playsElements.length;
  for (final XmlElement playElement in playsElements) {
    final int? playId =
        int.tryParse(playElement.firstOrDefaultAttributeValue(_xmlIdAttributeName) ?? '');
    final int? playTimeInMinutes =
        int.tryParse(playElement.firstOrDefaultAttributeValue(_xmlLengthAttributeTypeName) ?? '');
    final DateTime? playDate = DateTime.tryParse(
        playElement.firstOrDefaultAttributeValue(_xmlDateAttributeTypeName) ?? '');
    final bool playCompleted = int.tryParse(
            playElement.firstOrDefaultAttributeValue(_xmlIncompleteAttributeTypeName) ?? '0') ==
        0;

    final XmlElement? playItemElement = playElement.firstOrDefault(_xmlItemElementName);
    final String? boardGameId =
        playItemElement.firstOrDefaultAttributeValue(_xmlObjectIdAttributeTypeName);

    if (playId == null || (boardGameId?.isBlank ?? false) || playDate == null) {
      playsImportResult.errors!
          .add(ImportError('Failed to parse required information (e.g. playId)'));
      continue;
    }

    var play = BggPlay(
      id: playId,
      boardGameId: boardGameId!,
      playTimeInMinutes: playTimeInMinutes,
      playDate: playDate,
      completed: playCompleted,
      players: [],
    );

    final bggPlayPlayers = <BggPlayPlayer>[];
    final playPlayersElements = playElement.findAllElements(_xmlPlayerElementName);
    for (final XmlElement playerElement in playPlayersElements) {
      final String? playerName = playerElement.firstOrDefaultAttributeValue(_xmlNameAttributeName);
      final String? playerBggName =
          playerElement.firstOrDefaultAttributeValue(_xmlUsernameAttributeName);
      final int? playerBggUserId =
          int.tryParse(playElement.firstOrDefaultAttributeValue(_xmlUserIdAttributeName) ?? '');
      final int? playerScore =
          int.tryParse(playerElement.firstOrDefaultAttributeValue(_xmlScoreAttributeName) ?? '');
      final bool playerWin =
          int.tryParse(playerElement.firstOrDefaultAttributeValue(_xmlWinAttributeName) ?? '') ==
              _playerWinIndicator;

      if (playerName.isNullOrBlank && playerBggName.isNullOrBlank) {
        playsImportResult.errors!
            .add(ImportError("Cannot import a play #$playId without player's name"));
        continue;
      }

      if (playerScore == null &&
          (arguments.gameFamily == GameFamily.HighestScore ||
              arguments.gameFamily == GameFamily.LowestScore)) {
        playsImportResult.errors!
            .add(ImportError('Cannot import a play #$playId without a numeric score'));
        continue;
      }

      bggPlayPlayers.add(
        BggPlayPlayer(
          // MK Use bgg name instead of user's name if it's not present in the game's data
          playerName: playerName.isNotNullOrBlank ? playerName! : playerBggName!,
          playerScore: playerScore,
          playerBggName: playerBggName,
          playerBggUserId: playerBggUserId,
          playerWin: playerWin,
        ),
      );
    }

    play = play.copyWith(players: bggPlayPlayers);
    if (play.players.isEmpty) {
      continue;
    }

    playsImportResult.data!.add(play);
  }

  return playsImportResult;
}

CollectionImportResult _parseCollectionXml(ParseCollectionXmlArguments arguments) {
  final boardGames = <BoardGameDetails>[];
  XmlDocument xmlDocument;

  try {
    xmlDocument = XmlDocument.parse(arguments.responseData!);
  } catch (e, stack) {
    return CollectionImportResult.failure([ImportError.exception(e, stack)]);
  }

  if (_hasErrors(xmlDocument)) {
    return CollectionImportResult.failure([ImportError('XML document has errors')]);
  }

  final collectionElements = xmlDocument.findAllElements(_xmlItemElementName);
  for (final XmlElement collectionElement in collectionElements) {
    final String? boardGameId =
        collectionElement.firstOrDefaultAttributeValue(_xmlObjectIdAttributeTypeName);
    final String? boardGameName = collectionElement.firstOrDefault(_xmlNameElementName)?.innerText;

    if ((boardGameId?.isEmpty ?? true) || (boardGameName?.isEmpty ?? true)) {
      continue;
    }

    final boardGameDetailsStats = collectionElement.firstOrDefault(_xmlStatsElementName);
    final boardGameDetailsRating = boardGameDetailsStats?.firstOrDefault(_xmlRatingElementName)!;
    final ranks = _extractBoardGameRanks(boardGameDetailsRating);

    final boardGameDetails = BoardGameDetails(
      id: boardGameId!,
      name: boardGameName!,
      yearPublished: int.tryParse(
          collectionElement.firstOrDefault(_xmlYearPublishedElementName)?.innerText ?? ''),
      imageUrl: collectionElement.firstOrDefault(_xmlImageElementName)?.innerText,
      thumbnailUrl: collectionElement.firstOrDefault(_xmlThumbnailElementName)?.innerText,
      lastModified: DateTime.tryParse(collectionElement.firstOrDefaultElementsAttribute(
              _xmlStatusElementName, _xmlLastModifiedAttributeTypeName) ??
          ''),
      minPlayers: int.tryParse(
          boardGameDetailsStats?.firstOrDefaultAttributeValue(_xmlMinPlayersElementName) ?? ''),
      maxPlayers: int.tryParse(
          boardGameDetailsStats?.firstOrDefaultAttributeValue(_xmlMaxPlayersElementName) ?? ''),
      minPlaytime: int.tryParse(
          boardGameDetailsStats?.firstOrDefaultAttributeValue(_xmlMinPlaytimeElementName) ?? ''),
      maxPlaytime: int.tryParse(
          boardGameDetailsStats?.firstOrDefaultAttributeValue(_xmlMaxPlaytimeElementName) ?? ''),
      rating: double.tryParse(boardGameDetailsRating
              ?.firstOrDefault(_xmlAverageElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          ''),
      votes: int.tryParse(boardGameDetailsRating
              ?.firstOrDefault(_xmlUsersRatedElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          ''),
      isBggSynced: true,
      isOwned: arguments.collectionType == CollectionType.owned,
      isOnWishlist: arguments.collectionType == CollectionType.wishlist,
      ranks: ranks,
      rank: ranks.firstWhereOrNull((element) => element.name == 'boardgame')?.rank?.toInt(),
    );

    boardGames.add(boardGameDetails);
  }

  return CollectionImportResult()
    ..isSuccess = true
    ..data = boardGames;
}

XmlDocument? _retrieveXmlDocument(String data) {
  try {
    return XmlDocument.parse(data);
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }

  return null;
}

bool _hasErrors(XmlDocument xmlDocument) {
  final errorElements = xmlDocument.findAllElements(_xmlErrorElementName);
  if (errorElements.isEmpty) {
    return false;
  }

  return true;
}

void _extractBoardGameLinks(
  Iterable<XmlElement> boardGameLinks,
  List<BoardGameCategory> categories,
  List<BoardGameDesigner> desingers,
  List<BoardGamePublisher> publishers,
  List<BoardGameArtist> artists,
  List<BoardGameExpansion> expansions,
) {
  for (final boardGameLink in boardGameLinks) {
    if (boardGameLink.attributes.isEmpty) {
      continue;
    }

    final type = boardGameLink.firstOrDefaultAttributeValue(_xmlTypeAttributeName);
    final id = boardGameLink.firstOrDefaultAttributeValue(_xmlIdAttributeName);
    final value = boardGameLink.firstOrDefaultAttributeValue(_xmlValueAttributeName);

    if ((type?.isEmpty ?? true) || (id?.isEmpty ?? true) || (value?.isEmpty ?? true)) {
      continue;
    }

    switch (type) {
      case _xmlCategoryAttributeTypeName:
        categories.add(BoardGameCategory(id: id!, name: value!));
        break;
      case _xmlDesignerAttributeTypeName:
        desingers.add(BoardGameDesigner(id: id!, name: value!));
        break;
      case _xmlPublisherAttributeTypeName:
        publishers.add(BoardGamePublisher(id: id!, name: value!));
        break;
      case _xmlArtistAttributeTypeName:
        artists.add(BoardGameArtist(id: id!, name: value!));
        break;
      case _xmlExpansionAttributeTypeName:
        expansions.add(BoardGameExpansion(id: id!, name: value!));
        break;
      default:
    }
  }
}

List<BoardGameRank> _extractBoardGameRanks(XmlElement? boardGameDetailsRatings) {
  final List<BoardGameRank> ranks = [];
  if (boardGameDetailsRatings == null) {
    return ranks;
  }

  final Iterable<XmlElement> boardGameDetailsRanks = boardGameDetailsRatings
          .firstOrDefault(_xmlRanksElementName)
          ?.findElements(_xmlRankElementName) ??
      [];

  for (final boardGameRank in boardGameDetailsRanks) {
    final String? rankId = boardGameRank.firstOrDefaultAttributeValue(_xmlIdAttributeName);
    final String? rankName = boardGameRank.firstOrDefaultAttributeValue(_xmlNameAttributeName);
    final String? rankType = boardGameRank.firstOrDefaultAttributeValue(_xmlTypeAttributeName);
    final String? rankFriendlyName =
        boardGameRank.firstOrDefaultAttributeValue(_xmlFriendlyNameAttributeName);
    final num? rankRank =
        num.tryParse(boardGameRank.firstOrDefaultAttributeValue(_xmlValueAttributeName) ?? '');
    if ((rankType?.isEmpty ?? true) ||
        (rankId?.isEmpty ?? true) ||
        (rankName?.isEmpty ?? true) ||
        (rankRank == null)) {
      continue;
    }

    final rank = BoardGameRank(
      id: rankId!,
      name: rankName!,
      type: rankType!,
      friendlyName: rankFriendlyName,
      rank: rankRank,
    );

    ranks.add(rank);
  }

  return ranks;
}
