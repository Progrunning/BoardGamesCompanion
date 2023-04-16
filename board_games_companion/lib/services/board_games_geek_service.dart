import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:basics/basics.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:retry/retry.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml.dart' as xml;

import '../common/enums/collection_type.dart';
import '../common/enums/game_family.dart';
import '../common/exceptions/bgg_retry_exception.dart';
import '../common/hive_boxes.dart';
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
import '../utilities/custom_http_client_adapter.dart';

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

@singleton
class BoardGamesGeekService {
  BoardGamesGeekService(this._httpClientAdapter) {
    _dio
      ..httpClientAdapter = _httpClientAdapter
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions requestOptions, handler) async {
          final String cacheKey = _dioCacheOptions.keyBuilder(requestOptions);
          final CacheResponse? cachedResponse = await _dioCacheOptions.store?.get(cacheKey);
          if (cachedResponse != null) {
            // MK Hot board games cache expiration check
            if (requestOptions.uri.toString().contains(_hotBoardGamesUrl) &&
                DateTime.now().difference(cachedResponse.responseDate).inHours <
                    _hotBoardGamesCacheExpirationInHours) {
              Fimber.d('Getting hot board games from cache');
              return handler.resolve(cachedResponse.toResponse(requestOptions, fromNetwork: false));
            }

            // MK board game details cache expiration check
            if (requestOptions.uri.toString().contains(_boardGamesDetailsUrl) &&
                DateTime.now().difference(cachedResponse.responseDate).inHours <
                    _boardGameDetailsCacheExpirationInHours) {
              Fimber.d('Getting board game details from cache');
              return handler.resolve(cachedResponse.toResponse(requestOptions, fromNetwork: false));
            }
          }

          return handler.next(requestOptions);
        },
      ))
      ..interceptors.add(DioCacheInterceptor(options: _dioCacheOptions))
      ..interceptors.add(LogInterceptor(responseBody: true));
  }

  static const String _baseBoardGamesUrl = 'https://www.boardgamegeek.com/xmlapi2';
  static const String _hotBoardGamesUrl = '$_baseBoardGamesUrl/hot';
  static const String _boardGamesDetailsUrl = '$_baseBoardGamesUrl/thing';
  static const String _searchBoardGamesUrl = '$_baseBoardGamesUrl/search';
  static const String _collectionBoardGamesUrl = '$_baseBoardGamesUrl/collection';
  static const String _playesBoardGamesUrl = '$_baseBoardGamesUrl/plays';

  static const String _boardGameQueryParamterType = 'type';
  static const String _boardGameQueryParamterUsername = 'username';
  static const String _boardGameQueryParamterOwn = 'own';
  static const String _boardGameQueryParamterWishlist = 'wishlist';
  static const String _boardGameQueryParamterWantToBuy = 'wanttobuy';
  static const String _boardGameQueryParamterQuery = 'query';
  static const String _boardGameQueryParamterStats = 'stats';
  static const String _boardGameQueryParamterId = 'id';
  static const String _boardGameQueryParamterPageNumber = 'page';
  static const String _boardGameType = 'boardgame';
  static const String _boardGameExpansionType = 'boardgameexpansion';

  static const int _hotBoardGamesCacheExpirationInHours = Duration.hoursPerDay;

  static const int _boardGameDetailsCacheExpirationInHours = Duration.hoursPerDay * 7;
  static const int _bggRetryStatusCode = 202;
  static const Duration _bggRetryDelayFactor = Duration(milliseconds: 600);
  static const int _maxBackoffDurationInSeconts = 8;

  final CacheOptions _dioCacheOptions = CacheOptions(
    store: HiveCacheStore(null, hiveBoxName: HiveBoxes.dioCache),
  );

  final CustomHttpClientAdapter _httpClientAdapter;
  final Dio _dio = Dio();

  Future<List<BoardGameDetails>> getHot({int retryCount = 0}) async {
    final hotBoardGames = <BoardGameDetails>[];

    // MK Apply exponential backoff when retrying
    if (retryCount > 0) {
      await Future<void>.delayed(
          Duration(seconds: min(pow(retryCount, 2), _maxBackoffDurationInSeconts) as int));
    }

    final retrievalOptions = _dioCacheOptions.toOptions();
    retrievalOptions.contentType = 'application/xml';
    retrievalOptions.responseType = ResponseType.plain;

    final hotBoardGamesXml = await _dio.get<String>(
      _hotBoardGamesUrl,
      queryParameters: <String, dynamic>{_boardGameQueryParamterType: _boardGameType},
      options: retrievalOptions,
    );

    try {
      final hotBoardGamesXmlDocument = _retrieveXmlDocument(hotBoardGamesXml);
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

    final retrievalOptions = _dioCacheOptions.toOptions();
    retrievalOptions.contentType = 'application/xml';
    retrievalOptions.responseType = ResponseType.plain;

    final boardGameDetailsXml = await _dio.get<String>(
      _boardGamesDetailsUrl,
      queryParameters: <String, dynamic>{
        _boardGameQueryParamterId: id,
        _boardGameQueryParamterStats: 1,
      },
      options: retrievalOptions,
    );

    try {
      final boardGameDetailsXmlDocument = _retrieveXmlDocument(boardGameDetailsXml)!;
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

      final imageUrl = boardGameDetailsItem.firstOrDefault(_xmlImageElementName)?.text;

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

  Future<List<BoardGameDetails>> search(String? searchPhrase) async {
    if (searchPhrase?.isEmpty ?? true) {
      return [];
    }

    final searchResultsXml = await _dio.get<String>(
      _searchBoardGamesUrl,
      queryParameters: <String, String?>{
        _boardGameQueryParamterType: _boardGameType,
        _boardGameQueryParamterQuery: searchPhrase,
      },
    );

    final boardGames = <BoardGameDetails>[];
    final xmlDocument = _retrieveXmlDocument(searchResultsXml);
    if (xmlDocument == null) {
      return boardGames;
    }

    final searchResultItems = xmlDocument.findAllElements(_xmlItemElementName);
    for (final searchResult in searchResultItems) {
      final boardGameId = searchResult.firstOrDefaultAttributeValue(_xmlIdAttributeName);
      final boardGameName =
          searchResult.firstOrDefaultElementsAttribute(_xmlNameElementName, _xmlValueAttributeName);
      if (boardGameId == null || boardGameName == null) {
        return boardGames;
      }

      final boardGameYearPublished = searchResult.firstOrDefaultElementsAttribute(
          _xmlYearPublishedElementName, _xmlValueAttributeName);

      boardGames.add(BoardGameDetails(
        id: boardGameId,
        name: boardGameName,
        yearPublished: int.tryParse(boardGameYearPublished ?? ''),
      ));
    }

    return boardGames;
  }

  Future<CollectionImportResult> importCollections(String username) async {
    if (username.isEmpty) {
      return CollectionImportResult();
    }

    final ownGameImportResult = await _importCollection(
      username,
      CollectionType.owned,
      <String, dynamic>{_boardGameQueryParamterOwn: 1},
    );
    final wishlistGameImportResult = await _importCollection(
      username,
      CollectionType.wishlist,
      <String, dynamic>{_boardGameQueryParamterWishlist: 1},
    );
    final wantToBuyGameImportResult = await _importCollection(
      username,
      CollectionType.wishlist,
      <String, dynamic>{_boardGameQueryParamterWantToBuy: 1},
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
      _boardGameQueryParamterPageNumber: bggImportPlays.pageNumber,
    };

    final playsResultXml = await retry(
      () async {
        final response = await _dio.get<String>(
          _playesBoardGamesUrl,
          queryParameters: queryParamters,
        );

        return response;
      },
      delayFactor: _bggRetryDelayFactor,
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    return compute(
      parsePlaysXml,
      ParsePlaysXmlArguments(playsResultXml.data, bggImportPlays.gameFamily),
    );
  }

  Future<CollectionImportResult> _importCollection(
    String username,
    CollectionType collectionType,
    Map<String, dynamic> additionalQueryParameters,
  ) async {
    final queryParamters = <String, dynamic>{
      _boardGameQueryParamterUsername: username,
      _boardGameQueryParamterStats: 1,
    };
    queryParamters.addAll(additionalQueryParameters);

    final collectionResultsXml = await retry(
      () async {
        final response = await _dio.get<String>(
          _collectionBoardGamesUrl,
          queryParameters: queryParamters,
        );

        if (response.statusCode == _bggRetryStatusCode) {
          throw BggRetryException();
        }

        return response;
      },
      delayFactor: _bggRetryDelayFactor,
      retryIf: (e) => e is BggRetryException,
    );

    return compute(
      parseCollectionXml,
      ParseCollectionXmlArguments(collectionResultsXml.data, collectionType),
    );
  }
}

BggPlaysImportResult parsePlaysXml(ParsePlaysXmlArguments arguments) {
  XmlDocument? playsXmlDocument;
  try {
    playsXmlDocument = xml.XmlDocument.parse(arguments.responseData!);
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

      if (playerName?.isBlank ?? true) {
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

      bggPlayPlayers.add(BggPlayPlayer(
        playerName: playerName!,
        playerScore: playerScore,
        playerBggName: playerBggName,
        playerBggUserId: playerBggUserId,
        playerWin: playerWin,
      ));
    }

    play = play.copyWith(players: bggPlayPlayers);
    if (play.players.isEmpty) {
      continue;
    }

    playsImportResult.data!.add(play);
  }

  return playsImportResult;
}

CollectionImportResult parseCollectionXml(ParseCollectionXmlArguments arguments) {
  final boardGames = <BoardGameDetails>[];
  XmlDocument xmlDocument;

  try {
    xmlDocument = xml.XmlDocument.parse(arguments.responseData!);
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
    final String? boardGameName = collectionElement.firstOrDefault(_xmlNameElementName)?.text;

    if ((boardGameId?.isEmpty ?? true) || (boardGameName?.isEmpty ?? true)) {
      continue;
    }

    final boardGameDetailsStats = collectionElement.firstOrDefault(_xmlStatsElementName);
    final boardGameDetailsRating = boardGameDetailsStats?.firstOrDefault(_xmlRatingElementName)!;
    final ranks = _extractBoardGameRanks(boardGameDetailsRating);

    final boardGameDetails = BoardGameDetails(
      id: boardGameId!,
      name: boardGameName!,
      yearPublished:
          int.tryParse(collectionElement.firstOrDefault(_xmlYearPublishedElementName)?.text ?? ''),
      imageUrl: collectionElement.firstOrDefault(_xmlImageElementName)?.text,
      thumbnailUrl: collectionElement.firstOrDefault(_xmlThumbnailElementName)?.text,
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

XmlDocument? _retrieveXmlDocument(Response<String> httpResponse) {
  try {
    return XmlDocument.parse(httpResponse.data!);
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }

  return null;
}

bool _hasErrors(xml.XmlDocument xmlDocument) {
  final errorElements = xmlDocument.findAllElements(_xmlErrorElementName);
  if (errorElements.isEmpty) {
    return false;
  }

  return true;
}

void _extractBoardGameLinks(
  Iterable<xml.XmlElement> boardGameLinks,
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

List<BoardGameRank> _extractBoardGameRanks(xml.XmlElement? boardGameDetailsRatings) {
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
