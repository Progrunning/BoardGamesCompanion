import 'package:board_games_companion/models/board_game.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;

class BoardGamesGeekService {
  static final BoardGamesGeekService _instance =
      new BoardGamesGeekService._createInstance();

  factory BoardGamesGeekService() {
    return _instance;
  }

  BoardGamesGeekService._createInstance();

  static const String _hotBoardGamesUrl =
      "https://www.boardgamegeek.com/xmlapi2/hot?type=boardgame";
  static const int _numberOfDaysToCacheHotBoardGames = 1;

  Future<List<BoardGame>> retrieveHot() async {
    final hotBoardGames = new List<BoardGame>();

    final hotBoardGamesXml = await Dio().get(_hotBoardGamesUrl,
        options: buildCacheOptions(
            Duration(days: _numberOfDaysToCacheHotBoardGames)));

    try {
      if (hotBoardGamesXml is Response && hotBoardGamesXml.data is String) {
        final hotBoardGamesXmlDocument = xml.parse(hotBoardGamesXml.data);
        final hotBoardGameItems =
            hotBoardGamesXmlDocument.findAllElements('item');
        for (var hotBoardGameItem in hotBoardGameItems) {
          var newHotBoardGame = BoardGame();
          newHotBoardGame.id = hotBoardGameItem.getAttribute('id');
          newHotBoardGame.rank =
              int.tryParse(hotBoardGameItem.getAttribute('rank'));

          newHotBoardGame.thumbnailUrl = hotBoardGameItem
              .findElements('thumbnail')
              .single
              .attributes
              .single
              .value;
          newHotBoardGame.name = hotBoardGameItem
              .findElements('name')
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
}
