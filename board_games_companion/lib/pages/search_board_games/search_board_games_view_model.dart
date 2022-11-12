// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/search_board_games/search_results.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/analytics.dart';
import '../../models/board_game.dart';
import '../../services/analytics_service.dart';
import '../../services/board_games_geek_service.dart';

part 'search_board_games_view_model.g.dart';

@singleton
class SearchBoardGamesViewModel = _SearchBoardGamesViewModel with _$SearchBoardGamesViewModel;

abstract class _SearchBoardGamesViewModel with Store {
  _SearchBoardGamesViewModel(
    this._boardGamesStore,
    this._boardGameGeekService,
    this._analyticsService,
  );

  final BoardGamesStore _boardGamesStore;
  final BoardGamesGeekService _boardGameGeekService;
  final AnalyticsService _analyticsService;

  int _refreshRetryCount = 0;

  @observable
  ObservableList<BoardGame>? hotBoardGames;

  @observable
  SearchResults searchResults = const SearchResults.init();

  @observable
  ObservableFuture<void>? futureLoadHotBoardGames;

  @observable
  ObservableFuture<void>? futureSearchBoardGames;

  @observable
  String? searchPhrase;

  @computed
  bool get hasAnyHotBoardGames => hotBoardGames?.isNotEmpty ?? false;

  @computed
  bool get isSearchPhraseEmpty => searchPhrase.isNullOrBlank;

  @action
  void loadHotBoardGames() =>
      futureLoadHotBoardGames = ObservableFuture<void>(_loadHotBoardGames());

  @action
  void searchBoardGames() => futureSearchBoardGames = ObservableFuture<void>(_searchBoardGames());

  @action
  void setSearchPhrase(String? searchPhrase) => this.searchPhrase = searchPhrase;

  BoardGameDetails? getHotBoardGameDetails(String boardGameId) =>
      _boardGamesStore.allBoardGamesMap[boardGameId];

  void trackViewHotBoardGame(BoardGame boardGame) {
    _analyticsService.logEvent(
      name: Analytics.viewHotBoardGame,
      parameters: <String, String?>{
        Analytics.boardGameIdParameter: boardGame.id,
        Analytics.boardGameNameParameter: boardGame.name,
      },
    );
  }

  void refresh() => _refreshRetryCount++;

  Future<void> _searchBoardGames() async {
    if (searchPhrase?.isEmpty ?? true) {
      searchResults = const SearchResults.init();
      return;
    }

    try {
      searchResults = SearchResults.searching(searchPhrase!);
      searchResults = SearchResults.results(await _boardGameGeekService.search(searchPhrase));

      _analyticsService.logEvent(
        name: Analytics.searchBoardGames,
        parameters: <String, String?>{Analytics.searchBoardGamesPhraseParameter: searchPhrase},
      );
    } catch (e, stack) {
      searchResults = const SearchResults.failure();
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
  void clearSearchResults() {
    searchPhrase = '';
    searchResults = const SearchResults.init();
  }

  Future<void> _loadHotBoardGames() async {
    try {
      hotBoardGames =
          ObservableList.of(await _boardGameGeekService.getHot(retryCount: _refreshRetryCount));
      _refreshRetryCount = 0;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
