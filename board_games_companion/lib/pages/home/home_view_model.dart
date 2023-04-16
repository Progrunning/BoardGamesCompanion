// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../common/analytics.dart';
import '../../common/enums/order_by.dart';
import '../../common/enums/sort_by_option.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/search_history_entry.dart';
import '../../models/sort_by.dart';
import '../../services/analytics_service.dart';
import '../../services/board_games_geek_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/app_store.dart';
import '../../stores/board_games_filters_store.dart';
import '../../stores/board_games_store.dart';
import '../../stores/search_store.dart';
import '../collections/collections_view_model.dart';
import '../hot_board_games/hot_board_games_view_model.dart';
import '../players/players_view_model.dart';
import '../plays/plays_view_model.dart';

part 'home_view_model.g.dart';

@injectable
class HomeViewModel = _HomeViewModelBase with _$HomeViewModel;

abstract class _HomeViewModelBase with Store {
  _HomeViewModelBase(
    this.analyticsService,
    this.rateAndReviewService,
    this.playersViewModel,
    this.boardGamesFiltersStore,
    this.collectionsViewModel,
    this.hotBoardGamesViewModel,
    this.playthroughsHistoryViewModel,
    this._appStore,
    this._searchStore,
    this._boardGamesStore,
    this._boardGameGeekService,
  ) {
    _bggSearchResultsStreamController.onListen = () => _searchBgg();
    bggSearchResultsStream =
        ObservableStream<List<BoardGameDetails>>(_bggSearchResultsStreamController.stream);
    // MK When restoring a backup, reload all of the data
    reaction((_) => _appStore.backupRestored, (bool? backupRestored) {
      if (backupRestored ?? false) {
        loadData();
      }
    });
  }

  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;
  final PlayersViewModel playersViewModel;
  final BoardGamesFiltersStore boardGamesFiltersStore;
  final CollectionsViewModel collectionsViewModel;
  final HotBoardGamesViewModel hotBoardGamesViewModel;
  final PlaysViewModel playthroughsHistoryViewModel;
  final AppStore _appStore;
  final BoardGamesStore _boardGamesStore;
  final SearchStore _searchStore;
  final BoardGamesGeekService _boardGameGeekService;

  final StreamController<List<BoardGameDetails>> _bggSearchResultsStreamController =
      StreamController<List<BoardGameDetails>>.broadcast();

  static const Map<int, Tuple2<String, String>> _screenViewByTabIndex = {
    0: Tuple2<String, String>('Collections', 'CollectionsPage'),
    1: Tuple2<String, String>('Plays', 'PlaysPage'),
    2: Tuple2<String, String>('Players', 'PlayersPage'),
    3: Tuple2<String, String>('Hot', 'HotBoardGamesPage'),
  };

  final List<BoardGameDetails> _bggSearchResults = [];

  String? _bggSearchQuery;
  String? _previousBggSearchQuery;

  @observable
  ObservableStream<List<BoardGameDetails>> bggSearchResultsStream =
      ObservableStream(Stream.value([]));

  @observable
  ObservableList<SortBy> bggSearchSortByOptions = ObservableList.of([
    SortBy(sortByOption: SortByOption.Name)
      ..selected = true
      ..orderBy = OrderBy.Ascending,
    SortBy(sortByOption: SortByOption.YearPublished),
  ]);

  @observable
  ObservableFuture<void>? futureloadData;

  @computed
  List<BoardGameDetails> get allBoardGames => _boardGamesStore.allBoardGamesInCollections;

  @computed
  bool get anyBoardGamesInCollections =>
      allBoardGames.any((boardGame) => boardGame.isInAnyCollection);

  @computed
  List<SearchHistoryEntry> get searchHistory => _searchStore.searchHistory
    ..sort((entry, otherEntry) => otherEntry.dateTime.compareTo(entry.dateTime))
    ..toList();

  @computed
  SortBy? get bggSearchSelectedSortBy =>
      bggSearchSortByOptions.firstWhereOrNull((sb) => sb.selected);

  @action
  void loadData() => futureloadData = ObservableFuture<void>(_loadData());

  @action
  Future<List<BoardGameDetails>> searchCollections(String query) async {
    if (query.isEmpty) {
      return [];
    }

    await _captureSearchDetails(query);

    final queryLowercased = query.toLowerCase();
    return allBoardGames
        .where(
            (BoardGameDetails boardGame) => boardGame.name.toLowerCase().contains(queryLowercased))
        .toList();
  }

  @action
  void updateBggSearchSortByOption(SortBy sortBy) {
    // MK If already selected, update ordering direction
    if (sortBy.selected) {
      if (sortBy.orderBy == OrderBy.Ascending) {
        sortBy.orderBy = OrderBy.Descending;
      } else {
        sortBy.orderBy = OrderBy.Ascending;
      }
    }

    for (final sb in bggSearchSortByOptions) {
      sb.selected = false;
    }

    sortBy.selected = true;

    _bggSearchResultsStreamController.add(_bggSearchResults..sortBy(bggSearchSelectedSortBy));
  }

  @action
  void updateBggSearchQuery(String query) => _bggSearchQuery = query;

  /// Refresh the results in the stream.
  @action
  void refreshSearchResults() => _searchBgg();

  ValueNotifier<bool> isSearchDialContextMenuOpen = ValueNotifier(false);

  Future<void> trackTabChange(int tabIndex) async {
    await analyticsService.logScreenView(
      screenName: _screenViewByTabIndex[tabIndex]!.item1,
      screenClass: _screenViewByTabIndex[tabIndex]!.item2,
    );
  }

  Future<void> _loadData() async {
    collectionsViewModel.loadBoardGames();
    await _searchStore.loadSearchHistory();
  }

  Future<void> _searchBgg() async {
    if (_bggSearchQuery?.isEmpty ?? true) {
      return;
    }

    if (_previousBggSearchQuery == _bggSearchQuery &&
        (bggSearchResultsStream.value?.isNotEmpty ?? false)) {
      // Refresh data in the stream, otherwise the [ConnectionState] won't change from waiting
      _bggSearchResultsStreamController.add(bggSearchResultsStream.value!);
      return;
    }

    await _captureSearchDetails(_bggSearchQuery!);

    try {
      _bggSearchResults.clear();
      final foundBoardGames = await _boardGameGeekService.search(_bggSearchQuery);
      for (final boardGame in foundBoardGames) {
        // Enrich game details, if game details are available.
        // Otherwise add the game to the store.
        if (_boardGamesStore.allBoardGamesMap.containsKey(boardGame.id)) {
          _bggSearchResults.add(_boardGamesStore.allBoardGamesMap[boardGame.id]!);
          continue;
        } else {
          await _boardGamesStore.addOrUpdateBoardGame(boardGame);
        }

        _bggSearchResults.add(boardGame);
      }

      _previousBggSearchQuery = _bggSearchQuery;
      _bggSearchResultsStreamController.add(_bggSearchResults..sortBy(bggSearchSelectedSortBy));
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      _bggSearchResultsStreamController.addError(e);
      rethrow;
    }
  }

  Future<void> _captureSearchDetails(String query) async {
    // MK Intentionally unawaiting capturing of an analytic event
    unawaited(analyticsService.logEvent(
      name: Analytics.searchBoardGames,
      parameters: <String, String?>{Analytics.searchBoardGamesPhraseParameter: query},
    ));

    await _searchStore.addOrUpdateScore(
      SearchHistoryEntry(
        query: query,
        dateTime: DateTime.now().toUtc(),
      ),
    );
  }
}
