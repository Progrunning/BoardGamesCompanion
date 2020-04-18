import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/models/hive/board_game_artist.dart';
import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/models/hive/board_game_designer.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/extensions/xml_element_extensions.dart';
import 'package:board_games_companion/models/hive/board_game_publisher.dart';
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
  static const String _xmlLinkElementName = 'link';
  static const String _xmlStatisticsElementName = 'statistics';
  static const String _xmlRatingsElementName = 'ratings';
  static const String _xmlAverageElementName = 'average';
  static const String _xmlUsersRatedElementName = 'usersrated';
  static const String _xmlAverageWeightElementName = 'averageweight';
  static const String _xmlIdAttributeName = 'id';
  static const String _xmlTypeAttributeName = 'type';
  static const String _xmlValueAttributeName = 'value';
  static const String _xmlCategoryAttributeTypeName = 'boardgamecategory';
  static const String _xmlDesignerAttributeTypeName = 'boardgamedesigner';
  static const String _xmlArtistAttributeTypeName = 'boardgameartist';
  static const String _xmlPublisherAttributeTypeName = 'boardgamepublisher';

  static const String _baseBoardGamesUrl =
      'https://www.boardgamegeek.com/xmlapi2';
  static const String _hotBoardGamesUrl = '$_baseBoardGamesUrl/hot';
  static const String _boardGamesDetailsUrl = '$_baseBoardGamesUrl/thing';
  static const String _searchBoardGamesUrl = '$_baseBoardGamesUrl/search';

  static const String _boardGameQueryParamterType = 'type';
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
        var hotBoardGameName = hotBoardGameItem
            .findElements('name')
            .single
            .attributes
            .single
            .value;

        if (hotBoardGameName.isEmpty) {
          continue;
        }

        var newHotBoardGame = BoardGame(hotBoardGameName);
        newHotBoardGame.id = hotBoardGameItem.getAttribute(_xmlIdAttributeName);
        newHotBoardGame.rank =
            int.tryParse(hotBoardGameItem.getAttribute('rank'));

        newHotBoardGame.thumbnailUrl = hotBoardGameItem
            .findElements('thumbnail')
            .single
            .attributes
            .single
            .value;
        newHotBoardGame.yearPublished = int.tryParse(hotBoardGameItem
            .findElements('yearpublished')
            .single
            .attributes
            .single
            .value);

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
          boardGameDetailsItem.findAllElements(_xmlLinkElementName);
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

      boardGameDetails.avgWeight = num.tryParse(boardGameDetailsRatings
                  ?.firstOrDefault(_xmlAverageWeightElementName)
                  ?.firstOrDefaultAttributeValue(_xmlValueAttributeName) ??
              '') ??
          0;

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
        "query": searchPhrase,
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
          'name', _xmlValueAttributeName);
      final boardGameYearPublished =
          searchResult.firstOrDefaultElementsAttribute(
              'yearpublished', _xmlValueAttributeName);

      final boardGame = BoardGame(boardGameName);
      boardGame.id = boardGameId;
      boardGame.yearPublished = int.tryParse(boardGameYearPublished);
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

  void _extractBoardGameLinks(Iterable<xml.XmlElement> boardGameLinks,
      BoardGameDetails boardGameDetails) {
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
}
