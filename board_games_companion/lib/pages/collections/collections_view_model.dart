// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:basics/basics.dart';
import 'package:board_games_companion/models/sort_by.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/stores/scores_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../common/constants.dart';
import '../../common/enums/games_tab.dart';
import '../../extensions/int_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../stores/board_games_store.dart';
import '../../stores/players_store.dart';

part 'collections_view_model.g.dart';

@injectable
class CollectionsViewModel = _CollectionsViewModel with _$CollectionsViewModel;

abstract class _CollectionsViewModel with Store {
  _CollectionsViewModel(
    this._userStore,
    this._boardGamesStore,
    this._boardGamesFiltersStore,
    this._scoresStore,
    this._playthroughsStore,
    this._playersStore,
  );

  final UserStore _userStore;
  final BoardGamesStore _boardGamesStore;
  final BoardGamesFiltersStore _boardGamesFiltersStore;
  final ScoresStore _scoresStore;
  final PlaythroughsStore _playthroughsStore;
  final PlayersStore _playersStore;

  @observable
  GamesTab selectedTab = GamesTab.owned;

  @observable
  ObservableFuture<void>? futureLoadBoardGames;

  @computed
  List<BoardGameDetails> get allMainGames =>
      allBoardGames.where((BoardGameDetails boardGame) => boardGame.isMainGame).toList();

  @computed
  ObservableMap<String, BoardGameDetails> get _mainBoardGameByExpansionId {
    final mainBoardGameMap = <String, BoardGameDetails>{};
    for (final mainBoardGame in allMainGames) {
      for (final expansion in mainBoardGame.expansions) {
        mainBoardGameMap[expansion.id] = mainBoardGame;
      }
    }

    return ObservableMap.of(mainBoardGameMap);
  }

  @computed
  List<SortBy> get sortByOptions => _boardGamesFiltersStore.sortByOptions;

  @computed
  SortBy? get selectedSortBy => _boardGamesFiltersStore.sortByOptions.firstWhereOrNull(
        (sb) => sb.selected,
      );

  @computed
  bool get anyFiltersApplied => _boardGamesFiltersStore.anyFiltersApplied;

  @computed
  double? get filterByRating => _boardGamesFiltersStore.filterByRating;

  @computed
  ObservableList<BoardGameDetails> get filteredBoardGames {
    final sortBy = selectedSortBy;

    final filteredBoardGames = allBoardGames
        .where((BoardGameDetails boardGame) =>
            (_boardGamesFiltersStore.filterByRating == null ||
                (boardGame.rating ?? 0) >= _boardGamesFiltersStore.filterByRating!) &&
            (_boardGamesFiltersStore.numberOfPlayers == null ||
                (boardGame.maxPlayers != null &&
                    boardGame.minPlayers != null &&
                    (boardGame.maxPlayers! >= _boardGamesFiltersStore.numberOfPlayers! &&
                        boardGame.minPlayers! <= _boardGamesFiltersStore.numberOfPlayers!))))
        .toList();

    if (sortBy == null) {
      return ObservableList.of(filteredBoardGames);
    }

    filteredBoardGames.sortBy(sortBy);

    return ObservableList.of(filteredBoardGames);
  }

  @computed
  bool get anyBoardGamesInCollections =>
      _boardGamesStore.allBoardGames.any((boardGame) => boardGame.isInAnyCollection);

  @computed
  bool get anyBoardGames => _boardGamesStore.allBoardGames.isNotEmpty;

  @computed
  double get minNumberOfPlayers => max(
          allBoardGames
              .where((boardGameDetails) => boardGameDetails.minPlayers != null)
              .map((boardGameDetails) => boardGameDetails.minPlayers!)
              .reduce(min),
          Constants.minNumberOfPlayers)
      .toDouble();

  // MK Saved filter by number of players number might be larger than current MAX of players
  //    because a game in a different collection might have higher MAX players count
  @computed
  int? get filterByNumberOfPlayers => _boardGamesFiltersStore.numberOfPlayers;

  @computed
  String get numberOfPlayersSliderValue => filterByNumberOfPlayers.toSliderValue();

  @computed
  double get maxNumberOfPlayers => min(
          allBoardGames
              .where((boardGameDetails) => boardGameDetails.maxPlayers != null)
              .map((boardGameDetails) => boardGameDetails.maxPlayers!)
              .reduce(max),
          Constants.maxNumberOfPlayers)
      .toDouble();

  @computed
  List<BoardGameDetails> get allBoardGames => _boardGamesStore.allBoardGamesInCollections;

  @computed
  List<BoardGameDetails> get boardGamesInCollection {
    switch (selectedTab) {
      case GamesTab.owned:
        return filteredBoardGames.where((boardGame) => boardGame.isOwned ?? false).toList();
      case GamesTab.friends:
        return filteredBoardGames.where((boardGame) => boardGame.isFriends ?? false).toList();
      case GamesTab.wishlist:
        return filteredBoardGames.where((boardGame) => boardGame.isOnWishlist ?? false).toList();
    }
  }

  @computed
  bool get isCollectionEmpty => boardGamesInCollection.isEmpty;

  @computed
  List<BoardGameDetails> get mainGamesInCollection =>
      boardGamesInCollection.where((boardGame) => boardGame.isMainGame).toList();

  @computed
  List<BoardGameDetails> get expansionsInCollection =>
      boardGamesInCollection.where((boardGame) => boardGame.isExpansion ?? false).toList();

  @computed
  bool get anyMainGamesInCollection => mainGamesInCollection.isNotEmpty;

  @computed
  int get totalMainGamesInCollection => mainGamesInCollection.length;

  @computed
  int get totalExpansionsInCollection => expansionsInCollection.length;

  @computed
  bool get anyExpansionsInCollection => expansionsInCollection.isNotEmpty;

  @computed
  Map<Tuple2<String, String>, List<BoardGameDetails>> get expansionsInCollectionMap {
    final Map<Tuple2<String, String>, List<BoardGameDetails>> expansionsGrouped = {};
    for (final expansion in expansionsInCollection) {
      final mainGame = _mainBoardGameByExpansionId[expansion.id];
      final key = Tuple2<String, String>(mainGame?.id ?? '', mainGame?.name ?? 'Other');
      if (!expansionsGrouped.containsKey(key)) {
        expansionsGrouped[key] = [];
      }

      expansionsGrouped[key]!.add(expansion);
    }

    return expansionsGrouped;
  }

  @computed
  List<BoardGameDetails> get _allExpansions =>
      allBoardGames.where((boardGame) => boardGame.isExpansion ?? false).toList();

  @computed
  String? get userName => _userStore.user?.name;

  @computed
  bool get isUserNameEmpty => userName.isNullOrBlank;

  @action
  void setSelectedTab(GamesTab newlySelectedTab) => selectedTab = newlySelectedTab;

  @action
  void loadBoardGames() => futureLoadBoardGames = ObservableFuture<void>(_loadBoardGames());

  @action
  void updateSortBySelection(SortBy sortBy) =>
      _boardGamesFiltersStore.updateSortBySelection(sortBy);

  @action
  Future<void> clearFilters() => _boardGamesFiltersStore.clearFilters();

  @action
  Future<void> changeNumberOfPlayers(int? numberOfPlayers) =>
      _boardGamesFiltersStore.changeNumberOfPlayers(numberOfPlayers);

  @action
  Future<void> updateNumberOfPlayersFilter() =>
      _boardGamesFiltersStore.updateNumberOfPlayersFilter();

  @action
  Future<void> updateFilterByRating(double? rating) =>
      _boardGamesFiltersStore.updateFilterByRating(rating);

  Future<void> _loadBoardGames() async {
    try {
      // TODO MK Think about if we could potentially load all of the data once and then use it across the app
      //      What impact on the startup time and memory usage would it have?
      // NOTE: Could be better if this was in the HomeViewModel
      await _userStore.loadUser();
      await _boardGamesStore.loadBoardGames();
      await _boardGamesFiltersStore.loadFilterPreferences();
      await _playthroughsStore.loadPlaythroughs();
      await _scoresStore.loadScores();
      await _playersStore.loadPlayers();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
