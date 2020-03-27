import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;

class BoardGamesGeekService {
  static const String _xmlItemElementName = 'item';
  static const String _xmlIdAttributeName = 'id';
  static const String _xmlTypeAttributeName = 'type';
  static const String _xmlValueAttributeName = 'value';
  static const String _xmlCategoryAttributeTypeName = 'boardgamecategory';

  static const String _baseBoardGamesUrl =
      'https://www.boardgamegeek.com/xmlapi2';
  static const String _hotBoardGamesUrl = '$_baseBoardGamesUrl/hot';
  static const String _boardGamesDetailsUrl = '$_baseBoardGamesUrl/thing';

  static const int _numberOfDaysToCacheHotBoardGames = 1;
  static const String _hotBoardGamesCachePrimaryKey = 'hotBoardGames';
  static const String _hotBoardGamesCacheSubKey = 'boardgame';

  static const int _numberOfDaysToCacheBoardGameDetails = 1;

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

    final hotBoardGamesXml = await Dio().get(_hotBoardGamesUrl,
        queryParameters: {"type": "boardgame"}, options: retrievalOptions);

    try {
      if (hotBoardGamesXml is Response && hotBoardGamesXml.data is String) {
        final hotBoardGamesXmlDocument = xml.parse(hotBoardGamesXml.data);
        final hotBoardGameItems =
            hotBoardGamesXmlDocument.findAllElements(_xmlItemElementName);
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
          newHotBoardGame.id =
              hotBoardGameItem.getAttribute(_xmlIdAttributeName);
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
      }
    } catch (e) {
      print(e);
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
        forceRefresh: false);
    retrievalOptions.contentType = 'application/xml';
    retrievalOptions.responseType = ResponseType.plain;

    final boardGameDetailsXml = await Dio().get(_boardGamesDetailsUrl,
        queryParameters: {"id": id, "stats": "1"}, options: retrievalOptions);

    try {
      if (boardGameDetailsXml is Response &&
          boardGameDetailsXml.data is String) {
        final boardGameDetailsXmlDocument = xml.parse(boardGameDetailsXml.data);
        final boardGameDetailsItem = boardGameDetailsXmlDocument
            .findAllElements(_xmlItemElementName)
            .single;

        if (boardGameDetailsItem == null) {
          return null;
        }

        final boardGameDetailName = boardGameDetailsItem
            .findAllElements('name')
            .first
            .attributes
            .firstWhere((attr) {
          return attr.name.local == 'value';
        }).value;

        if (boardGameDetailName?.isEmpty ?? true) {
          return null;
        }

        final boardGameDetails = BoardGameDetails(boardGameDetailName);
        boardGameDetails.id = id;

        boardGameDetails.description =
            boardGameDetailsItem.findAllElements('description').first.text;

        boardGameDetails.imageUrl =
            boardGameDetailsItem.findAllElements('image').first.text;

        final boardGameDetailCategories =
            boardGameDetailsItem.findAllElements('link');
        for (final boardGameDetailCategory in boardGameDetailCategories) {
          if (boardGameDetailCategory.attributes.isEmpty) {
            continue;
          }

          final hasCategoryAttribute =
              boardGameDetailCategory.attributes.any((attr) {
            return attr.name.local == _xmlTypeAttributeName &&
                attr.value == _xmlCategoryAttributeTypeName;
          });

          if (!hasCategoryAttribute) {
            continue;
          }

          final boardGameCategory = BoardGameCategory();
          boardGameCategory.id =
              boardGameDetailCategory.attributes.firstWhere((attr) {
            return attr.name.local == _xmlIdAttributeName;
          })?.value;
          boardGameCategory.name =
              boardGameDetailCategory.attributes.firstWhere((attr) {
            return attr.name.local == _xmlValueAttributeName;
          })?.value;

          boardGameDetails.categories.add(boardGameCategory);
        }

        final boardGameDetailStatistics =
            boardGameDetailsItem.findAllElements('statistics').first;

        final boardGameDetailsRatings =
            boardGameDetailStatistics?.findAllElements('ratings')?.first;

        boardGameDetails.rating = double.tryParse(boardGameDetailsRatings
                ?.findAllElements('average')
                ?.first
                ?.attributes
                ?.single
                ?.value) ??
            0;

        boardGameDetails.votes = int.tryParse(boardGameDetailsRatings
                ?.findAllElements('usersrated')
                ?.first
                ?.attributes
                ?.single
                ?.value) ??
            0;

        return boardGameDetails;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
