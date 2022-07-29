import 'dart:math';

import 'package:board_games_companion/common/enums/order_by.dart';
import 'package:board_games_companion/common/enums/sort_by_option.dart';
import 'package:board_games_companion/extensions/string_extensions.dart';
import 'package:board_games_companion/models/sort_by.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/constants.dart';
import '../../common/enums/games_tab.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/double_extensions.dart';
import '../../extensions/int_extensions.dart';
import '../../extensions/string_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../stores/board_games_store.dart';

part 'games_view_model.g.dart';

enum CollectionState {
  emptyCollection,
  collection,
}

@injectable
class GamesViewModel = _GamesViewModel with _$GamesViewModel;

abstract class _GamesViewModel with Store {
  _GamesViewModel(
    this._boardGamesStore,
    this._boardGamesFiltersStore,
  );

  final BoardGamesStore _boardGamesStore;
  final BoardGamesFiltersStore _boardGamesFiltersStore;

  final Map<String, BoardGameDetails> _mainBoardGameByExpansionId = {};

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
  Map<String, BoardGameDetails> get filteredBoardGames {
    final sortBy = selectedSortBy;

    final filteredBoardGamesMap = {
      for (var boardGameDetails in _boardGamesStore.allBoardGames.where((boardGame) =>
          (_boardGamesFiltersStore.filterByRating == null ||
              boardGame.rating! >= _boardGamesFiltersStore.filterByRating!) &&
          (_boardGamesFiltersStore.numberOfPlayers == null ||
              (boardGame.maxPlayers != null &&
                  boardGame.minPlayers != null &&
                  (boardGame.maxPlayers! >= _boardGamesFiltersStore.numberOfPlayers! &&
                      boardGame.minPlayers! <= _boardGamesFiltersStore.numberOfPlayers!)))))
        boardGameDetails.id: boardGameDetails
    };

    if (sortBy == null) {
      return filteredBoardGamesMap;
    }

    final sortedFilteredBoardGames = List.of(filteredBoardGamesMap.values);
    sortedFilteredBoardGames.sort((boardGame, otherBoardGame) {
      if (sortBy.orderBy == OrderBy.Descending) {
        final buffer = boardGame;
        boardGame = otherBoardGame;
        otherBoardGame = buffer;
      }

      switch (sortBy.sortByOption) {
        case SortByOption.Name:
          return boardGame.name.safeCompareTo(otherBoardGame.name);
        case SortByOption.YearPublished:
          return boardGame.yearPublished.safeCompareTo(otherBoardGame.yearPublished);
        case SortByOption.LastUpdated:
          return boardGame.lastModified.safeCompareTo(otherBoardGame.lastModified);
        case SortByOption.Rank:
          return boardGame.rank.safeCompareTo(otherBoardGame.rank);
        case SortByOption.NumberOfPlayers:
          if (sortBy.orderBy == OrderBy.Descending) {
            return otherBoardGame.maxPlayers.safeCompareTo(boardGame.maxPlayers);
          }

          return boardGame.minPlayers.safeCompareTo(otherBoardGame.maxPlayers);
        case SortByOption.Playtime:
          return boardGame.maxPlaytime.safeCompareTo(otherBoardGame.maxPlaytime);
        case SortByOption.Rating:
          return otherBoardGame.rating.safeCompareTo(boardGame.rating);
        default:
          return boardGame.lastModified.safeCompareTo(otherBoardGame.lastModified);
      }
    });

    return {
      for (var boardGameDetails in sortedFilteredBoardGames) boardGameDetails.id: boardGameDetails
    };
  }

  @computed
  bool get anyBoardGamesInCollections => _boardGamesStore.allBoardGames
      .any((boardGame) => boardGame.isOwned! || boardGame.isOnWishlist! || boardGame.isFriends!);

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
  List<BoardGameDetails> get allBoardGames => _boardGamesStore.allBoardGames;

  @computed
  CollectionState get collectionSate {
    if (!anyBoardGamesInSelectedCollection) {
      return CollectionState.emptyCollection;
    }

    return CollectionState.collection;
  }

  @computed
  List<BoardGameDetails> get boardGamesInSelectedCollection {
    switch (selectedTab) {
      case GamesTab.owned:
        return filteredBoardGames.values.where((boardGame) => boardGame.isOwned!).toList();
      case GamesTab.friends:
        return filteredBoardGames.values.where((boardGame) => boardGame.isFriends!).toList();
      case GamesTab.wishlist:
        return filteredBoardGames.values.where((boardGame) => boardGame.isOnWishlist!).toList();
    }
  }

  @computed
  bool get anyBoardGamesInSelectedCollection => boardGamesInSelectedCollection.isNotEmpty;

  @computed
  List<BoardGameDetails> get mainGamesInCollections => boardGamesInSelectedCollection
      .where((boardGame) => !(boardGame.isExpansion ?? false))
      .toList();

  @computed
  bool get hasAnyMainGameInSelectedCollection => mainGamesInCollections.isNotEmpty;

  @computed
  int get totalMainGamesInCollections => mainGamesInCollections.length;

  @computed
  int get totalExpansionsInCollections => _expansionsInSelectedCollection.length;

  @computed
  bool get hasAnyExpansionsInSelectedCollection => _expansionsInSelectedCollection.isNotEmpty;

  @computed
  Map<BoardGameDetails, List<BoardGameDetails>> get expansionsGroupedByMainGame {
    final Map<BoardGameDetails, List<BoardGameDetails>> expansionsGrouped = {};
    for (final expansion in _allExpansions) {
      final mainGame = _mainBoardGameByExpansionId[expansion.id];
      if (mainGame == null) {
        continue;
      }

      if (!expansionsGrouped.containsKey(mainGame)) {
        expansionsGrouped[mainGame] = [];
      }

      expansionsGrouped[mainGame]!.add(expansion);
    }

    return expansionsGrouped;
  }

  @computed
  Map<BoardGameDetails, List<BoardGameDetails>>
      get expansionsInSelectedCollectionGroupedByMainGame {
    final Map<BoardGameDetails, List<BoardGameDetails>> expansionsGrouped = {};
    for (final expansion in _expansionsInSelectedCollection) {
      final mainGame = _mainBoardGameByExpansionId[expansion.id];
      if (mainGame == null) {
        continue;
      }

      if (!expansionsGrouped.containsKey(mainGame)) {
        expansionsGrouped[mainGame] = [];
      }

      expansionsGrouped[mainGame]!.add(expansion);
    }

    return expansionsGrouped;
  }

  @observable
  GamesTab selectedTab = GamesTab.owned;

  @action
  void setSelectedTab(GamesTab newlySelectedTab) => selectedTab = newlySelectedTab;

  List<BoardGameDetails> get _allExpansions =>
      allBoardGames.where((boardGame) => boardGame.isExpansion ?? false).toList();

  List<BoardGameDetails> get _expansionsInSelectedCollection =>
      boardGamesInSelectedCollection.where((boardGame) => boardGame.isExpansion ?? false).toList();

  @observable
  ObservableFuture<void>? futureLoadBoardGames;

  @action
  void loadBoardGames() => futureLoadBoardGames = ObservableFuture<void>(_loadBoardGames());

  @action
  Future<void> refreshBoardGameDetails(String boardGameId) async {
    await _boardGamesStore.refreshBoardGameDetails(boardGameId);
    _updateCachedBoardGameDetails();
  }

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
      await _boardGamesStore.loadBoardGames();
      _updateCachedBoardGameDetails();

      await _boardGamesFiltersStore.loadFilterPreferences();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  void _updateCachedBoardGameDetails() {
    for (final boardGameDetails in _boardGamesStore.allBoardGames) {
      filteredBoardGames[boardGameDetails.id] = boardGameDetails;
      if (boardGameDetails.isMainGame) {
        for (final boardGameExpansion in boardGameDetails.expansions) {
          _mainBoardGameByExpansionId[boardGameExpansion.id] = boardGameDetails;
        }
      }
    }
  }
}
