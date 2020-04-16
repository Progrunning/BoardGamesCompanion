import 'package:async/async.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/stores/search_bar_board_games_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class SearchBoardGamesStore with ChangeNotifier {
  final BoardGamesGeekService _boardGameGeekService;
  final SearchBarBoardGamesStore _searchBarBoardGamesStore;

  List<BoardGame> _searchResults;

  List<BoardGame> get searchResults => _searchResults;

  AsyncMemoizer<List<BoardGame>> _searchResultsMemoizer =
      new AsyncMemoizer<List<BoardGame>>();

  SearchBoardGamesStore(
    this._boardGameGeekService,
    this._searchBarBoardGamesStore,
  );

  Future<List<BoardGame>> search() async {
    return _searchResultsMemoizer.runOnce(
      () async {
        if (_searchBarBoardGamesStore.searchPhrase?.isEmpty ?? true) {
          _searchResults?.clear();
          return List<BoardGame>();
        }

        try {
          _searchResults = await _boardGameGeekService
              .search(_searchBarBoardGamesStore.searchPhrase);
        } catch (e, stack) {
          Crashlytics.instance.recordError(e, stack);
        }

        return _searchResults ?? List<BoardGame>();
      },
    );
  }

  void updateSearchResults() {
    _searchResultsMemoizer = new AsyncMemoizer<List<BoardGame>>();
    notifyListeners();
  }
}
