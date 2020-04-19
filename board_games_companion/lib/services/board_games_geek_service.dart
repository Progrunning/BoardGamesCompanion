import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/models/hive/board_game_artist.dart';
import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/models/hive/board_game_designer.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/extensions/xml_element_extensions.dart';
import 'package:board_games_companion/models/hive/board_game_publisher.dart';
import 'package:board_games_companion/models/hive/board_game_rank.dart';
import 'package:board_games_companion/utilities/bgg_retry_interceptor.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:xml/xml.dart' as xml;

class BoardGamesGeekService {
  static const String _xmlItemElementName = 'item';
  static const String _xmlNameElementName = 'name';
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
  static const String _xmlRatingsElementName = 'ratings';
  static const String _xmlRanksElementName = 'ranks';
  static const String _xmlRankElementName = 'rank';
  static const String _xmlAverageElementName = 'average';
  static const String _xmlUsersRatedElementName = 'usersrated';
  static const String _xmlNumCommentsElementName = 'numcomments';
  static const String _xmlAverageWeightElementName = 'averageweight';
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
  static const String _xmlObjectIdAttributeTypeName = 'objectid';

  static const String _baseBoardGamesUrl =
      'https://www.boardgamegeek.com/xmlapi2';
  static const String _hotBoardGamesUrl = '$_baseBoardGamesUrl/hot';
  static const String _boardGamesDetailsUrl = '$_baseBoardGamesUrl/thing';
  static const String _searchBoardGamesUrl = '$_baseBoardGamesUrl/search';
  static const String _collectionBoardGamesUrl =
      '$_baseBoardGamesUrl/collection';

  static const String _boardGameQueryParamterType = 'type';
  static const String _boardGameQueryParamterUsername = 'username';
  static const String _boardGameQueryParamterOwn = 'own';
  static const String _boardGameQueryParamterQuery = 'query';
  static const String _boardGameType = 'boardgame';

  static const int _numberOfDaysToCacheHotBoardGames = 1;
  static const String _hotBoardGamesCachePrimaryKey = 'hotBoardGames';
  static const String _hotBoardGamesCacheSubKey = 'boardgame';

  static const int _numberOfDaysToCacheBoardGameDetails = 1;

  final HttpClientAdapter _httpClientAdapter;
  final Dio _dio = Dio();

  BoardGamesGeekService(this._httpClientAdapter) {
    _dio.httpClientAdapter = _httpClientAdapter;
    _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: _baseBoardGamesUrl)).interceptor);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<List<BoardGame>> retrieveHot() async {
    final hotBoardGames = List<BoardGame>();

    final retrievalOptions = buildCacheOptions(
        Duration(days: _numberOfDaysToCacheHotBoardGames),
        maxStale: Duration(days: _numberOfDaysToCacheHotBoardGames),
        forceRefresh: false,
        primaryKey: _hotBoardGamesCachePrimaryKey,
        subKey: _hotBoardGamesCacheSubKey);
    retrievalOptions.contentType = 'application/xml';
    retrievalOptions.responseType = ResponseType.plain;

    final hotBoardGamesXml = await _dio.get(
      _hotBoardGamesUrl,
      queryParameters: {_boardGameQueryParamterType: _boardGameType},
      options: retrievalOptions,
    );

    try {
      final hotBoardGamesXmlDocument = _retrieveXmlDocument(hotBoardGamesXml);
      final hotBoardGameItems =
          hotBoardGamesXmlDocument?.findAllElements(_xmlItemElementName);
      for (var hotBoardGameItem in hotBoardGameItems) {
        var hotBoardGameName = hotBoardGameItem.firstOrDefaultElementsAttribute(
            _xmlNameElementName, _xmlValueAttributeName);

        if (hotBoardGameName.isEmpty) {
          continue;
        }

        var newHotBoardGame = BoardGame(hotBoardGameName);
        newHotBoardGame.id = hotBoardGameItem.getAttribute(_xmlIdAttributeName);
        newHotBoardGame.rank = int.tryParse(
            hotBoardGameItem.getAttribute(_xmlRankAttributeName) ?? '');

        newHotBoardGame.thumbnailUrl =
            hotBoardGameItem.firstOrDefaultElementsAttribute(
                _xmlThumbnailElementName, _xmlValueAttributeName);
        newHotBoardGame.yearPublished = int.tryParse(
            hotBoardGameItem.firstOrDefaultElementsAttribute(
                    _xmlYearPublishedElementName, _xmlValueAttributeName) ??
                '');

        hotBoardGames.add(newHotBoardGame);
      }
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return hotBoardGames;
  }

  Future<BoardGameDetails> retrieveDetails(String id) async {
    if (id?.isEmpty ?? true) {
      return null;
    }

    final retrievalOptions = buildCacheOptions(
      Duration(days: _numberOfDaysToCacheBoardGameDetails),
      maxStale: Duration(days: _numberOfDaysToCacheBoardGameDetails),
      forceRefresh: false,
    );
    retrievalOptions.contentType = 'application/xml';
    retrievalOptions.responseType = ResponseType.plain;

    final boardGameDetailsXml = await _dio.get(
      _boardGamesDetailsUrl,
      queryParameters: {"id": id, "stats": "1"},
      options: retrievalOptions,
    );

    try {
      final boardGameDetailsXmlDocument =
          _retrieveXmlDocument(boardGameDetailsXml);
      final boardGameDetailsItem = boardGameDetailsXmlDocument
          ?.findAllElements(_xmlItemElementName)
          ?.single;

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

      final boardGameDetails = BoardGameDetails(boardGameDetailName);
      boardGameDetails.id = id;

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

      boardGameDetails.imageUrl =
          boardGameDetailsItem.firstOrDefault(_xmlImageElementName)?.text;

      boardGameDetails.yearPublished = int.tryParse(boardGameDetailsItem
              .firstOrDefault(_xmlYearPublishedElementName)
              ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
          '');

      final boardGameLinks =
          boardGameDetailsItem.findElements(_xmlLinkElementName);
      _extractBoardGameLinks(boardGameLinks, boardGameDetails);

      final boardGameDetailStatistics =
          boardGameDetailsItem.firstOrDefault(_xmlStatisticsElementName);

      final boardGameDetailsRatings =
          boardGameDetailStatistics.firstOrDefault(_xmlRatingsElementName);

      boardGameDetails.rating = double.tryParse(boardGameDetailsRatings
                  ?.firstOrDefault(_xmlAverageElementName)
                  ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
              '') ??
          0;

      boardGameDetails.votes = int.tryParse(boardGameDetailsRatings
                  ?.firstOrDefault(_xmlUsersRatedElementName)
                  ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
              '') ??
          0;

      boardGameDetails.commentsNumber = int.tryParse(boardGameDetailsRatings
                  ?.firstOrDefault(_xmlNumCommentsElementName)
                  ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
              '') ??
          0;

      boardGameDetails.avgWeight = num.tryParse(boardGameDetailsRatings
                  ?.firstOrDefault(_xmlAverageWeightElementName)
                  ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
              '') ??
          0;

      _extractBoardGameRanks(boardGameDetailsRatings, boardGameDetails);

      return boardGameDetails;
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  Future<List<BoardGame>> search(String searchPhrase) async {
    if (searchPhrase?.isEmpty ?? true) {
      return null;
    }

    final searchResultsXml = await _dio.get(
      _searchBoardGamesUrl,
      queryParameters: {
        _boardGameQueryParamterType: _boardGameType,
        _boardGameQueryParamterQuery: searchPhrase,
      },
    );

    final boardGames = List<BoardGame>();
    final xmlDocument = _retrieveXmlDocument(searchResultsXml);
    if (xmlDocument == null) {
      return boardGames;
    }

    final searchResultItems = xmlDocument?.findAllElements(_xmlItemElementName);
    for (var searchResult in searchResultItems) {
      final boardGameId =
          searchResult.firstOrDefaultAttributeValue(_xmlIdAttributeName);
      final boardGameName = searchResult.firstOrDefaultElementsAttribute(
          _xmlNameElementName, _xmlValueAttributeName);
      final boardGameYearPublished =
          searchResult.firstOrDefaultElementsAttribute(
              _xmlYearPublishedElementName, _xmlValueAttributeName);

      final boardGame = BoardGame(boardGameName);
      boardGame.id = boardGameId;
      boardGame.yearPublished = int.tryParse(boardGameYearPublished ?? '');
      boardGames.add(boardGame);
    }

    return boardGames;
  }

  Future<List<BoardGameDetails>> syncCollection(String username) async {
    if (username?.isEmpty ?? true) {
      return List<BoardGameDetails>();
    }

    final dioWithRetry = _dio
      ..interceptors.add(
        RetryInterceptor(
          dio: _dio,
        ),
      );

    final collectionResultsXml = await dioWithRetry.get(
      _collectionBoardGamesUrl,
      queryParameters: {
        _boardGameQueryParamterUsername: username,
        _boardGameQueryParamterOwn: 1,
      },
    );

    final boardGames = List<BoardGameDetails>();
    final xmlDocument = _retrieveXmlDocument(collectionResultsXml);
    if (xmlDocument == null) {
      return boardGames;
    }
    final collectionItems = xmlDocument?.findAllElements(_xmlItemElementName);
    for (var collectionItem in collectionItems) {
      final boardGame = BoardGameDetails();
      boardGame.id = collectionItem
          .firstOrDefaultAttributeValue(_xmlObjectIdAttributeTypeName);

      if (boardGame.id?.isEmpty ?? true) {
        continue;
      }

      boardGame.name = collectionItem.firstOrDefault(_xmlNameElementName)?.text;
      boardGame.yearPublished = int.tryParse(
          collectionItem.firstOrDefault(_xmlYearPublishedElementName)?.text ??
              '');
      boardGame.imageUrl =
          collectionItem.firstOrDefault(_xmlImageElementName)?.text;
      boardGame.thumbnailUrl =
          collectionItem.firstOrDefault(_xmlThumbnailElementName)?.text;

      boardGames.add(boardGame);
    }

    return boardGames;
  }

  xml.XmlDocument _retrieveXmlDocument(Response<dynamic> httpResponse) {
    try {
      if (httpResponse?.data is String) {
        return xml.parse(httpResponse.data);
      }
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  void _extractBoardGameLinks(
    Iterable<xml.XmlElement> boardGameLinks,
    BoardGameDetails boardGameDetails,
  ) {
    for (final boardGameLink in boardGameLinks) {
      if (boardGameLink.attributes?.isEmpty ?? true) {
        continue;
      }

      final type =
          boardGameLink.firstOrDefaultAttributeValue(_xmlTypeAttributeName);
      final id =
          boardGameLink.firstOrDefaultAttributeValue(_xmlIdAttributeName);
      final value =
          boardGameLink.firstOrDefaultAttributeValue(_xmlValueAttributeName);

      if ((type?.isEmpty ?? true) ||
          (id?.isEmpty ?? true) ||
          (value?.isEmpty ?? true)) {
        continue;
      }

      switch (type) {
        case _xmlCategoryAttributeTypeName:
          final boardGameCategory = BoardGameCategory();
          boardGameCategory.id = id;
          boardGameCategory.name = value;
          boardGameDetails.categories.add(boardGameCategory);
          break;
        case _xmlDesignerAttributeTypeName:
          final boardGameDesigner = BoardGameDesigner();
          boardGameDesigner.id = id;
          boardGameDesigner.name = value;
          boardGameDetails.desingers.add(boardGameDesigner);
          break;
        case _xmlPublisherAttributeTypeName:
          final boardGamePublisher = BoardGamePublisher();
          boardGamePublisher.id = id;
          boardGamePublisher.name = value;
          boardGameDetails.publishers.add(boardGamePublisher);
          break;
        case _xmlArtistAttributeTypeName:
          final boardGameArtist = BoardGameArtist();
          boardGameArtist.id = id;
          boardGameArtist.name = value;
          boardGameDetails.artists.add(boardGameArtist);
          break;
        default:
      }
    }
  }

  void _extractBoardGameRanks(
    xml.XmlElement boardGameDetailsRatings,
    BoardGameDetails boardGameDetails,
  ) {
    final boardGameDetailsRanks = boardGameDetailsRatings
        .firstOrDefault(_xmlRanksElementName)
        ?.findElements(_xmlRankElementName);

    for (final boardGameRank in boardGameDetailsRanks) {
      final rank = BoardGameRank();
      rank.type =
          boardGameRank.firstOrDefaultAttributeValue(_xmlTypeAttributeName);
      rank.id = boardGameRank.firstOrDefaultAttributeValue(_xmlIdAttributeName);
      rank.name =
          boardGameRank.firstOrDefaultAttributeValue(_xmlNameAttributeName);
      rank.friendlyName = boardGameRank
          .firstOrDefaultAttributeValue(_xmlFriendlyNameAttributeName);
      rank.rank = num.tryParse(boardGameRank
                  .firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
              '') ??
          null;

      boardGameDetails.ranks.add(rank);
    }
  }
}
