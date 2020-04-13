import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class SearchBoardGamesStore with ChangeNotifier {
  BoardGamesGeekService _boardGameGeekService;

  String _searchPhrase;

  List<BoardGame> _searchResults;

  List<BoardGame> get searchResults => _searchResults;

  String get searchPhrase => _searchPhrase;

  SearchBoardGamesStore(this._boardGameGeekService);

  Future<List<BoardGame>> search(String searchPhrase) async {
    _searchPhrase = searchPhrase;

    if (_searchPhrase?.isNotEmpty ?? true) {
      _searchResults.clear();
      return List<BoardGame>();
    }

    try {
      _searchResults = await _boardGameGeekService.search(_searchPhrase);
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return _searchResults ?? List<BoardGame>();
  }
}
