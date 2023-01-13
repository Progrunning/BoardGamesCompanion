// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../services/analytics_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/board_games_filters_store.dart';
import '../collections/collections_view_model.dart';
import '../players/players_view_model.dart';
import '../plays/plays_view_model.dart';
import '../search_board_games/search_board_games_view_model.dart';

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
    this.searchBoardGamesViewModel,
    this.playthroughsHistoryViewModel,
  );

  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;
  final PlayersViewModel playersViewModel;
  final BoardGamesFiltersStore boardGamesFiltersStore;
  final CollectionsViewModel collectionsViewModel;
  final SearchBoardGamesViewModel searchBoardGamesViewModel;
  final PlaysViewModel playthroughsHistoryViewModel;

  static const Map<int, Tuple2<String, String>> _screenViewByTabIndex = {
    0: Tuple2<String, String>('Collections', 'CollectionsPage'),
    1: Tuple2<String, String>('Search', 'SearchBoardGamesPage'),
    2: Tuple2<String, String>('Plays', 'PlaysPage'),
    3: Tuple2<String, String>('Players', 'PlayersPage'),
  };

  @observable
  ObservableFuture<void>? futureloadData;

  @computed
  bool get anyBoardGamesInCollections => collectionsViewModel.anyBoardGamesInCollections;

  @action
  void loadData() => futureloadData = ObservableFuture<void>(_loadData());

  ValueNotifier<bool> isSearchDialContextMenuOpen = ValueNotifier(false);

  Future<void> trackTabChange(int tabIndex) async {
    await analyticsService.logScreenView(
      screenName: _screenViewByTabIndex[tabIndex]!.item1,
      screenClass: _screenViewByTabIndex[tabIndex]!.item2,
    );
  }

  Future<void> _loadData() async {
    collectionsViewModel.loadBoardGames();
  }
}
