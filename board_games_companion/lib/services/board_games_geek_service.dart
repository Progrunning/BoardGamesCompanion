import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:retry/retry.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml.dart' as xml;

import '../common/enums/collection_type.dart';
import '../common/exceptions/bgg_retry_exception.dart';
import '../extensions/xml_element_extensions.dart';
import '../models/board_game.dart';
import '../models/collection_sync_result.dart';
import '../models/hive/board_game_artist.dart';
import '../models/hive/board_game_category.dart';
import '../models/hive/board_game_designer.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/board_game_expansion.dart';
import '../models/hive/board_game_publisher.dart';
import '../models/hive/board_game_rank.dart';
import '../utilities/custom_http_client_adapter.dart';

@singleton
class BoardGamesGeekService {
  BoardGamesGeekService(this._httpClientAdapter) {
    _dio.httpClientAdapter = _httpClientAdapter;
    _dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: _baseBoardGamesUrl)).interceptor as Interceptor);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  static const String _xmlItemElementName = 'item';
  static const String _xmlNameElementName = 'name';
  static const String _xmlErrorElementName = 'error';
  static const String _xmlDescriptionElementName = 'description';
  static const String _xmlMinPlayersElementName = 'minplayers';
  static const String _xmlMaxPlayersElementName = 'maxplayers';
  static const String _xmlMinPlaytimeElementName = 'minplaytime';
  static const String _xmlMaxPlaytimeElementName = 'maxplaytime';
  static const String _xmlMinAgeElementName = 'minage';
  static const String _xmlYearPublishedElementName = 'yearpublished';
  static const String _xmlImageElementName = 'image';
  static const String _xmlThumbnailElementName = 'thumbnail';
  static const String _xmlLinkElementName = 'link';
  static const String _xmlStatisticsElementName = 'statistics';
  static const String _xmlStatsElementName = 'stats';
  static const String _xmlRatingsElementName = 'ratings';
  static const String _xmlRatingElementName = 'rating';
  static const String _xmlRanksElementName = 'ranks';
  static const String _xmlRankElementName = 'rank';
  static const String _xmlAverageElementName = 'average';
  static const String _xmlUsersRatedElementName = 'usersrated';
  static const String _xmlNumCommentsElementName = 'numcomments';
  static const String _xmlAverageWeightElementName = 'averageweight';
  static const String _xmlStatusElementName = 'status';
  static const String _xmlIdAttributeName = 'id';
  static const String _xmlTypeAttributeName = 'type';
  static const String _xmlValueAttributeName = 'value';
  static const String _xmlNameAttributeName = 'name';
  static const String _xmlRankAttributeName = 'rank';
  static const String _xmlFriendlyNameAttributeName = 'friendlyname';
  static const String _xmlCategoryAttributeTypeName = 'boardgamecategory';
  static const String _xmlDesignerAttributeTypeName = 'boardgamedesigner';
  static const String _xmlArtistAttributeTypeName = 'boardgameartist';
  static const String _xmlPublisherAttributeTypeName = 'boardgamepublisher';
  static const String _xmlExpansionAttributeTypeName = 'boardgameexpansion';
  static const String _xmlObjectIdAttributeTypeName = 'objectid';
  static const String _xmlLastModifiedAttributeTypeName = 'lastmodified';

  static const String _baseBoardGamesUrl = 'https://www.boardgamegeek.com/xmlapi2';
  static const String _hotBoardGamesUrl = '$_baseBoardGamesUrl/hot';
  static const String _boardGamesDetailsUrl = '$_baseBoardGamesUrl/thing';
  static const String _searchBoardGamesUrl = '$_baseBoardGamesUrl/search';
  static const String _collectionBoardGamesUrl = '$_baseBoardGamesUrl/collection';

  static const String _boardGameQueryParamterType = 'type';
  static const String _boardGameQueryParamterUsername = 'username';
  static const String _boardGameQueryParamterOwn = 'own';
  static const String _boardGameQueryParamterWishlist = 'wishlist';
  static const String _boardGameQueryParamterWantToBuy = 'wanttobuy';
  static const String _boardGameQueryParamterQuery = 'query';
  static const String _boardGameQueryParamterStats = 'stats';
  static const String _boardGameQueryParamterId = 'id';
  static const String _boardGameType = 'boardgame';
  static const String _boardGameExpansionType = 'boardgameexpansion';

  static const int _numberOfDaysToCacheHotBoardGames = 1;
  static const String _hotBoardGamesCachePrimaryKey = 'hotBoardGames';
  static const String _hotBoardGamesCacheSubKey = 'boardgame';

  static const int _numberOfDaysToCacheBoardGameDetails = 1;
  static const int _bggRetryStatusCode = 202;

  final CustomHttpClientAdapter _httpClientAdapter;
  final Dio _dio = Dio();

  Future<List<BoardGame>> getHot() async {
    final hotBoardGames = <BoardGame>[];

    final retrievalOptions = buildCacheOptions(
        const Duration(days: _numberOfDaysToCacheHotBoardGames),
        maxStale: const Duration(days: _numberOfDaysToCacheHotBoardGames),
        forceRefresh: false,
        primaryKey: _hotBoardGamesCachePrimaryKey,
        subKey: _hotBoardGamesCacheSubKey);
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

        final newHotBoardGame = BoardGame(id: hotBoardGameId, name: hotBoardGameName);
        newHotBoardGame.rank =
            int.tryParse(hotBoardGameItem.getAttribute(_xmlRankAttributeName) ?? '');

        newHotBoardGame.thumbnailUrl = hotBoardGameItem.firstOrDefaultElementsAttribute(
            _xmlThumbnailElementName, _xmlValueAttributeName);
        newHotBoardGame.yearPublished = int.tryParse(
            hotBoardGameItem.firstOrDefaultElementsAttribute(
                    _xmlYearPublishedElementName, _xmlValueAttributeName) ??
                '');

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

    final retrievalOptions = buildCacheOptions(
      const Duration(days: _numberOfDaysToCacheBoardGameDetails),
      maxStale: const Duration(days: _numberOfDaysToCacheBoardGameDetails),
      forceRefresh: false,
    );
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

      final boardGameDetails = BoardGameDetails(id: id, name: boardGameDetailName!);

      final boardGameType =
          boardGameDetailsItem.firstOrDefaultAttributeValue(_xmlTypeAttributeName);
      boardGameDetails.isExpansion = boardGameType == _boardGameExpansionType;

      boardGameDetails.description =
          boardGameDetailsItem.firstOrDefault(_xmlDescriptionElementName)?.text;

      boardGameDetails.minPlayers = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMinPlayersElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      boardGameDetails.maxPlayers = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMaxPlayersElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      boardGameDetails.minPlaytime = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMinPlaytimeElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      boardGameDetails.maxPlaytime = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMaxPlaytimeElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      boardGameDetails.minAge = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlMinAgeElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      boardGameDetails.imageUrl = boardGameDetailsItem.firstOrDefault(_xmlImageElementName)?.text;

      boardGameDetails.thumbnailUrl =
          boardGameDetailsItem.firstOrDefault(_xmlThumbnailElementName)?.text;

      boardGameDetails.yearPublished = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlYearPublishedElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final boardGameLinks = boardGameDetailsItem.findElements(_xmlLinkElementName);
      _extractBoardGameLinks(boardGameLinks, boardGameDetails);

      final boardGameDetailStatistics =
          boardGameDetailsItem.firstOrDefault(_xmlStatisticsElementName)!;

      final boardGameDetailsRatings =
          boardGameDetailStatistics.firstOrDefault(_xmlRatingsElementName)!;

      boardGameDetails.rating = double.tryParse(boardGameDetailsRatings
              .firstOrDefault(_xmlAverageElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      boardGameDetails.votes = int.tryParse(boardGameDetailsRatings
              .firstOrDefault(_xmlUsersRatedElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      boardGameDetails.commentsNumber = int.tryParse(boardGameDetailsRatings
              .firstOrDefault(_xmlNumCommentsElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      boardGameDetails.avgWeight = num.tryParse(boardGameDetailsRatings
              .firstOrDefault(_xmlAverageWeightElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      _extractBoardGameRanks(boardGameDetailsRatings, boardGameDetails);

      return boardGameDetails;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  Future<List<BoardGame>?> search(String? searchPhrase) async {
    if (searchPhrase?.isEmpty ?? true) {
      return null;
    }

    final searchResultsXml = await _dio.get<String>(
      _searchBoardGamesUrl,
      queryParameters: <String, String?>{
        _boardGameQueryParamterType: _boardGameType,
        _boardGameQueryParamterQuery: searchPhrase,
      },
    );

    final boardGames = <BoardGame>[];
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

      final boardGame = BoardGame(id: boardGameId, name: boardGameName);
      boardGame.yearPublished = int.tryParse(boardGameYearPublished ?? '');
      boardGames.add(boardGame);
    }

    return boardGames;
  }

  Future<CollectionSyncResult> syncCollection(String username) async {
    if (username.isEmpty) {
      return CollectionSyncResult();
    }

    final ownGameSyncResult = await _syncCollection(
      username,
      CollectionType.Owned,
      <String, dynamic>{_boardGameQueryParamterOwn: 1},
    );
    final wishlistGameSyncResult = await _syncCollection(
      username,
      CollectionType.Wishlist,
      <String, dynamic>{_boardGameQueryParamterWishlist: 1},
    );
    final wantToBuyGameSyncResult = await _syncCollection(
      username,
      CollectionType.Wishlist,
      <String, dynamic>{_boardGameQueryParamterWantToBuy: 1},
    );

    return CollectionSyncResult()
      ..isSuccess = ownGameSyncResult.isSuccess &&
          wishlistGameSyncResult.isSuccess &&
          wantToBuyGameSyncResult.isSuccess
      ..data = [
        ...ownGameSyncResult.data ?? <BoardGameDetails>[],
        ...wishlistGameSyncResult.data ?? <BoardGameDetails>[],
        ...wantToBuyGameSyncResult.data ?? <BoardGameDetails>[]
      ];
  }

  Future<CollectionSyncResult> _syncCollection(
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
          throw BggRetryException;
        }

        return response;
      },
      retryIf: (e) => e is BggRetryException,
    );

    final boardGames = <BoardGameDetails>[];
    final xmlDocument = _retrieveXmlDocument(collectionResultsXml);
    if (xmlDocument == null) {
      return CollectionSyncResult();
    }

    if (_hasErrors(xmlDocument)) {
      return CollectionSyncResult();
    }

    final collectionItems = xmlDocument.findAllElements(_xmlItemElementName);
    for (final collectionItem in collectionItems) {
      final String? boardGameId =
          collectionItem.firstOrDefaultAttributeValue(_xmlObjectIdAttributeTypeName);
      final String? boardGameName = collectionItem.firstOrDefault(_xmlNameElementName)?.text;

      if ((boardGameId?.isEmpty ?? true) || (boardGameName?.isEmpty ?? true)) {
        continue;
      }

      final boardGame = BoardGameDetails(id: boardGameId!, name: boardGameName!);
      boardGame.yearPublished =
          int.tryParse(collectionItem.firstOrDefault(_xmlYearPublishedElementName)?.text ?? '');
      boardGame.imageUrl = collectionItem.firstOrDefault(_xmlImageElementName)?.text;
      boardGame.thumbnailUrl = collectionItem.firstOrDefault(_xmlThumbnailElementName)?.text;
      final lastModifiedString = collectionItem.firstOrDefaultElementsAttribute(
          _xmlStatusElementName, _xmlLastModifiedAttributeTypeName);
      if (lastModifiedString?.isNotEmpty ?? false) {
        boardGame.lastModified = DateTime.tryParse(lastModifiedString!);
      }

      _extractBoardGameCollectionItemStas(collectionItem, boardGame);

      boardGame.isBggSynced = true;

      switch (collectionType) {
        case CollectionType.Owned:
          boardGame.isOwned = true;
          break;
        case CollectionType.Friends:
          break;
        case CollectionType.Wishlist:
          boardGame.isOnWishlist = true;
          break;
      }

      boardGames.add(boardGame);
    }

    return CollectionSyncResult()
      ..isSuccess = true
      ..data = boardGames;
  }

  xml.XmlDocument? _retrieveXmlDocument(Response<String> httpResponse) {
    try {
      return xml.XmlDocument.parse(httpResponse.data!);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  void _extractBoardGameLinks(
    Iterable<xml.XmlElement> boardGameLinks,
    BoardGameDetails boardGameDetails,
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
          final boardGameCategory = BoardGameCategory(id: id!, name: value!);
          boardGameDetails.categories!.add(boardGameCategory);
          break;
        case _xmlDesignerAttributeTypeName:
          final boardGameDesigner = BoardGameDesigner(id: id!, name: value!);
          boardGameDetails.desingers.add(boardGameDesigner);
          break;
        case _xmlPublisherAttributeTypeName:
          final boardGamePublisher = BoardGamePublisher(id: id!, name: value!);
          boardGameDetails.publishers.add(boardGamePublisher);
          break;
        case _xmlArtistAttributeTypeName:
          final boardGameArtist = BoardGameArtist(id: id!, name: value!);
          boardGameDetails.artists.add(boardGameArtist);
          break;
        case _xmlExpansionAttributeTypeName:
          final boardGameArtist = BoardGamesExpansion(id: id!, name: value!);
          boardGameDetails.expansions.add(boardGameArtist);
          break;
        default:
      }
    }
  }

  void _extractBoardGameRanks(
    xml.XmlElement? boardGameDetailsRatings,
    BoardGameDetails boardGameDetails,
  ) {
    if (boardGameDetailsRatings == null || boardGameDetails == null) {
      FirebaseCrashlytics.instance.log('Faild to extract board game detail rank information');
      return;
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
        FirebaseCrashlytics.instance
            .log('Faild to extract some of the board game detail rank information');
      }
      final rank = BoardGameRank(
        id: rankId!,
        name: rankName!,
        type: rankType!,
        friendlyName: rankFriendlyName,
        rank: rankRank,
      );

      if (rank.name == 'boardgame') {
        boardGameDetails.rank = rank.rank?.toInt();
      }

      boardGameDetails.ranks.add(rank);
    }
  }

  void _extractBoardGameCollectionItemStas(
    xml.XmlElement collectionItem,
    BoardGameDetails boardGameDetails,
  ) {
    final boardGameDetailsStats = collectionItem.firstOrDefault(_xmlStatsElementName);

    boardGameDetails.minPlayers = int.tryParse(
        boardGameDetailsStats?.firstOrDefaultAttributeValue(_xmlMinPlayersElementName) ?? '');
    boardGameDetails.maxPlayers = int.tryParse(
        boardGameDetailsStats?.firstOrDefaultAttributeValue(_xmlMaxPlayersElementName) ?? '');
    boardGameDetails.minPlaytime = int.tryParse(
        boardGameDetailsStats?.firstOrDefaultAttributeValue(_xmlMinPlaytimeElementName) ?? '');
    boardGameDetails.maxPlaytime = int.tryParse(
        boardGameDetailsStats?.firstOrDefaultAttributeValue(_xmlMaxPlaytimeElementName) ?? '');

    final boardGameDetailsRating = boardGameDetailsStats?.firstOrDefault(_xmlRatingElementName)!;

    boardGameDetails.rating = double.tryParse(boardGameDetailsRating
            ?.firstOrDefault(_xmlAverageElementName)
            ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
        '');

    boardGameDetails.votes = int.tryParse(boardGameDetailsRating
            ?.firstOrDefault(_xmlUsersRatedElementName)
            ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
        '');

    _extractBoardGameRanks(boardGameDetailsRating, boardGameDetails);
  }

  bool _hasErrors(xml.XmlDocument xmlDocument) {
    final errorElements = xmlDocument.findAllElements(_xmlErrorElementName);
    if (errorElements.isEmpty) {
      return false;
    }

    // for (var errorElement in errorElements) {}

    return true;
  }
}
