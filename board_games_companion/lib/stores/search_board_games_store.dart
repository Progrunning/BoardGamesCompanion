import 'package:async/async.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import '../common/analytics.dart';
import '../models/board_game.dart';
import '../services/analytics_service.dart';
import '../services/board_games_geek_service.dart';
import 'search_bar_board_games_store.dart';

class SearchBoardGamesStore with ChangeNotifier {
  final BoardGamesGeekService _boardGameGeekService;
  final SearchBarBoardGamesStore _searchBarBoardGamesStore;
  final AnalyticsService _analyticsService;

  List<BoardGame> _searchResults;

  List<BoardGame> get searchResults => _searchResults;

  AsyncMemoizer<List<BoardGame>> _searchResultsMemoizer = new AsyncMemoizer<List<BoardGame>>();

  SearchBoardGamesStore(
    this._boardGameGeekService,
    this._searchBarBoardGamesStore,
    this._analyticsService,
  );

  Future<List<BoardGame>> search() async {
    return _searchResultsMemoizer.runOnce(
      () async {
        if (_searchBarBoardGamesStore.searchPhrase?.isEmpty ?? true) {
          _searchResults?.clear();
          return <BoardGame>[];
        }

        try {
          await _analyticsService.logEvent(
            name: Analytics.SearchBoardGames,
            parameters: <String, String>{
              Analytics.SearchBoardGamesPhraseParameter: _searchBarBoardGamesStore.searchPhrase,
            },
          );

          _searchResults =
              await _boardGameGeekService.search(_searchBarBoardGamesStore.searchPhrase);
        } catch (e, stack) {
          FirebaseCrashlytics.instance.recordError(e, stack);
        }

        return _searchResults ?? <BoardGame>[];
      },
    );
  }

  void updateSearchResults() {
    _searchResultsMemoizer = new AsyncMemoizer<List<BoardGame>>();
    notifyListeners();
  }
}
