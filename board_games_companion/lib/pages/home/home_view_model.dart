// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:async/async.dart';
import 'package:board_games_companion/models/api/search/board_game_search_dto.dart';
import 'package:board_games_companion/services/board_games_search_service.dart';
import 'package:board_games_companion/widgets/search/board_game_search_error.dart';
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
    this.playsViewModel,
    this._appStore,
    this._searchStore,
    this._boardGamesStore,
    this._boardGameSearchServive,
  ) {
    _searchResultsStreamController.onListen = () => _searchBoardGames();
    searchResultsStream =
        ObservableStream<List<BoardGameDetails>>(_searchResultsStreamController.stream);
    // MK When restoring a backup, reload all of the data
    _backupRestoredReactionDisposer =
        reaction((_) => _appStore.backupRestored, (bool? backupRestored) {
      if (backupRestored ?? false) {
        loadData();
      }
    });
  }

  late final ReactionDisposer _backupRestoredReactionDisposer;

  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;
  final PlayersViewModel playersViewModel;
  final BoardGamesFiltersStore boardGamesFiltersStore;
  final CollectionsViewModel collectionsViewModel;
  final HotBoardGamesViewModel hotBoardGamesViewModel;
  final PlaysViewModel playsViewModel;
  final AppStore _appStore;
  final BoardGamesStore _boardGamesStore;
  final SearchStore _searchStore;
  final BoardGamesSearchService _boardGameSearchServive;

  final StreamController<List<BoardGameDetails>> _searchResultsStreamController =
      StreamController<List<BoardGameDetails>>.broadcast();

  static const Map<int, Tuple2<String, String>> _screenViewByTabIndex = {
    0: Tuple2<String, String>('Collections', 'CollectionsPage'),
    1: Tuple2<String, String>('Plays', 'PlaysPage'),
    2: Tuple2<String, String>('Players', 'PlayersPage'),
    3: Tuple2<String, String>('Hot', 'HotBoardGamesPage'),
  };

  final List<BoardGameDetails> _searchResults = [];

  String? _searchQuery;
  String? _previousSearchQuery;

  CancelableOperation<List<BoardGameSearchResultDto>>? _searchBoardGamesOperation;

  @observable
  ObservableStream<List<BoardGameDetails>> searchResultsStream = ObservableStream(Stream.value([]));

  @observable
  ObservableList<SortBy> searchSortByOptions = ObservableList.of([
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
  SortBy? get searchSelectedSortBy => searchSortByOptions.firstWhereOrNull((sb) => sb.selected);

  @action
  void loadData() => futureloadData = ObservableFuture<void>(_loadData());

  @action
  Future<List<BoardGameDetails>> searchCollections(String query) async {
    if (query.isEmpty) {
      return [];
    }

    await _captureSearchDetailsEvent(query);

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

    for (final sb in searchSortByOptions) {
      sb.selected = false;
    }

    sortBy.selected = true;

    _searchResultsStreamController.add(_searchResults..sortBy(searchSelectedSortBy));
  }

  @action
  void updateBggSearchQuery(String query) => _searchQuery = query;

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

  Future<void> _searchBoardGames() async {
    if (_searchQuery?.isEmpty ?? true) {
      return;
    }

    await _searchBoardGamesOperation?.cancel();

    if (_previousSearchQuery == _searchQuery && (searchResultsStream.value?.isNotEmpty ?? false)) {
      // Refresh data in the stream, otherwise the [ConnectionState] won't change from waiting
      _searchResultsStreamController.add(searchResultsStream.value!);
      return;
    }

    await _captureSearchDetailsEvent(_searchQuery!);

    _searchResults.clear();
    _searchBoardGamesOperation = CancelableOperation<List<BoardGameSearchResultDto>>.fromFuture(
        _boardGameSearchServive.search(_searchQuery));
    _searchBoardGamesOperation!.value.onError((error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      if (error is TimeoutException) {
        _searchResultsStreamController.addError(const BoardGameSearchError.timout());
      } else {
        _searchResultsStreamController.addError(const BoardGameSearchError.generic());
      }

      return Future.value([]);
    });

    final searchResultBoardGames = await _searchBoardGamesOperation!.value;
    for (final searchResultBoardGame in searchResultBoardGames) {
      final boardGameDetails = BoardGameDetails.fromSearchResult(searchResultBoardGame);
      _searchResults.add(boardGameDetails);

      // Add the game to the store if not present
      if (!_boardGamesStore.allBoardGamesMap.containsKey(boardGameDetails.id)) {
        await _boardGamesStore.addOrUpdateBoardGame(boardGameDetails);
      }
    }

    _previousSearchQuery = _searchQuery;
    _searchResultsStreamController.add(_searchResults..sortBy(searchSelectedSortBy));
  }

  Future<void> _captureSearchDetailsEvent(String query) async {
    // MK Intentionally unawaiting capturing of an analytic event
    unawaited(analyticsService.logEvent(
      name: Analytics.searchBoardGames,
      parameters: <String, String?>{Analytics.searchBoardGamesPhraseParameter: query},
    ));

    await _searchStore.addOrUpdateEntry(
      SearchHistoryEntry(
        query: query,
        dateTime: DateTime.now().toUtc(),
      ),
    );
  }

  void dispose() {
    _backupRestoredReactionDisposer();
    playersViewModel.dispose();
  }
}
