// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/enums/order_by.dart';
import 'package:board_games_companion/common/enums/sort_by_option.dart';
import 'package:board_games_companion/models/sort_by.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../common/constants.dart';
import '../../common/enums/games_tab.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/double_extensions.dart';
import '../../extensions/int_extensions.dart';
import '../../extensions/string_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../stores/board_games_store.dart';

part 'games_view_model.g.dart';

@injectable
class GamesViewModel = _GamesViewModel with _$GamesViewModel;

abstract class _GamesViewModel with Store {
  _GamesViewModel(
    this._userStore,
    this._boardGamesStore,
    this._boardGamesFiltersStore,
  );

  final UserStore _userStore;
  final BoardGamesStore _boardGamesStore;
  final BoardGamesFiltersStore _boardGamesFiltersStore;

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
                boardGame.rating! >= _boardGamesFiltersStore.filterByRating!) &&
            (_boardGamesFiltersStore.numberOfPlayers == null ||
                (boardGame.maxPlayers != null &&
                    boardGame.minPlayers != null &&
                    (boardGame.maxPlayers! >= _boardGamesFiltersStore.numberOfPlayers! &&
                        boardGame.minPlayers! <= _boardGamesFiltersStore.numberOfPlayers!))))
        .toList();

    if (sortBy == null) {
      return ObservableList.of(filteredBoardGames);
    }

    filteredBoardGames.sort((boardGame, otherBoardGame) {
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

  @observable
  GamesTab selectedTab = GamesTab.owned;

  @observable
  ObservableFuture<void>? futureLoadBoardGames;

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
      await _userStore.loadUser();
      await _boardGamesStore.loadBoardGames();
      await _boardGamesFiltersStore.loadFilterPreferences();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
