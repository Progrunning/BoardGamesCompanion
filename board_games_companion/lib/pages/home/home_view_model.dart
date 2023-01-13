// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:board_games_companion/stores/app_store.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/search_store.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../common/analytics.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/search_history_entry.dart';
import '../../services/analytics_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/board_games_filters_store.dart';
import '../collections/collections_view_model.dart';
import '../hot_board_games/search_board_games_view_model.dart';
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
  ) {
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

  static const Map<int, Tuple2<String, String>> _screenViewByTabIndex = {
    0: Tuple2<String, String>('Collections', 'CollectionsPage'),
    1: Tuple2<String, String>('Plays', 'PlaysPage'),
    2: Tuple2<String, String>('Players', 'PlayersPage'),
    3: Tuple2<String, String>('Hot', 'HotBoardGamesPage'),
  };

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

  @action
  void loadData() => futureloadData = ObservableFuture<void>(_loadData());

  @action
  Future<List<BoardGameDetails>> search(String query) async {
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

    final queryLowercased = query.toLowerCase();
    return allBoardGames
        .where(
            (BoardGameDetails boardGame) => boardGame.name.toLowerCase().contains(queryLowercased))
        .toList();
  }

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
}
