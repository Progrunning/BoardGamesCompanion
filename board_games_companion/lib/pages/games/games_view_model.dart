import 'package:board_games_companion/common/enums/order_by.dart';
import 'package:board_games_companion/common/enums/sort_by_option.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../../common/enums/enums.dart';
import '../../common/enums/games_tab.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/double_extensions.dart';
import '../../extensions/int_extensions.dart';
import '../../extensions/string_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../stores/board_games_store.dart';

enum CollectionState {
  emptySearchResult,
  emptyCollection,
  collection,
}

class GamesViewModel with ChangeNotifier {
  GamesViewModel(
    this._boardGamesStore,
    this._boardGamesFiltersStore,
  );

  final BoardGamesStore _boardGamesStore;
  final BoardGamesFiltersStore _boardGamesFiltersStore;

  String? _searchPhrase;

  final Map<String, BoardGameDetails> _mainBoardGameByExpansionId = {};
  Map<String, BoardGameDetails> _filteredBoardGames = {};

  bool get anyBoardGamesInCollections => _boardGamesStore.allBoardGames
      .any((boardGame) => boardGame.isOwned! || boardGame.isOnWishlist! || boardGame.isFriends!);

  bool get anyBoardGames => _boardGamesStore.allBoardGames.isNotEmpty;

  LoadDataState _loadDataState = LoadDataState.none;
  LoadDataState get loadDataState => _loadDataState;

  CollectionState get collectionSate {
    if (!anyBoardGamesInSelectedCollection) {
      if (!isSearchPhraseEmpty) {
        return CollectionState.emptySearchResult;
      }

      return CollectionState.emptyCollection;
    }

    return CollectionState.collection;
  }

  GamesTab _selectedTab = GamesTab.owned;

  String? get searchPhrase => _searchPhrase;

  bool get isSearchPhraseEmpty => _searchPhrase?.isEmpty ?? true;

  List<BoardGameDetails> get boardGamesInSelectedCollection {
    switch (selectedTab) {
      case GamesTab.owned:
        return _filteredBoardGames.values.where((boardGame) => boardGame.isOwned!).toList();
      case GamesTab.friends:
        return _filteredBoardGames.values.where((boardGame) => boardGame.isFriends!).toList();
      case GamesTab.wishlist:
        return _filteredBoardGames.values.where((boardGame) => boardGame.isOnWishlist!).toList();
    }
  }

  bool get anyBoardGamesInSelectedCollection => boardGamesInSelectedCollection.isNotEmpty;

  List<BoardGameDetails> get mainGamesInCollections => boardGamesInSelectedCollection
      .where((boardGame) => !(boardGame.isExpansion ?? false))
      .toList();

  bool get hasAnyMainGameInSelectedCollection => mainGamesInCollections.isNotEmpty;

  int get totalMainGamesInCollections => mainGamesInCollections.length;

  List<BoardGameDetails> get _expansionsInSelectedCollection =>
      boardGamesInSelectedCollection.where((boardGame) => boardGame.isExpansion ?? false).toList();

  int get totalExpansionsInCollections => _expansionsInSelectedCollection.length;

  bool get hasAnyExpansionsInSelectedCollection => _expansionsInSelectedCollection.isNotEmpty;

  Map<BoardGameDetails, List<BoardGameDetails>> get expansionGroupedByMainGame {
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

  GamesTab get selectedTab => _selectedTab;
  set selectedTab(GamesTab value) {
    if (_selectedTab != value) {
      _selectedTab = value;
      notifyListeners();
    }
  }

  Future<void> loadBoardGames() async {
    notifyListeners();
    _loadDataState = LoadDataState.loading;
    try {
      await _boardGamesStore.loadBoardGames();
      for (final boardGameDetails in _boardGamesStore.allBoardGames) {
        _filteredBoardGames[boardGameDetails.id] = boardGameDetails;
        if (boardGameDetails.isMainGame) {
          for (final boardGameExpansion in boardGameDetails.expansions) {
            _mainBoardGameByExpansionId[boardGameExpansion.id] = boardGameDetails;
          }
        }
      }

      await _boardGamesFiltersStore.loadFilterPreferences();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      _loadDataState = LoadDataState.error;
    }

    _loadDataState = LoadDataState.loaded;
    notifyListeners();
  }

  void updateSearchResults(String searchPhrase) {
    if (searchPhrase.isEmpty == true && _searchPhrase?.isEmpty == true) {
      return;
    }

    _searchPhrase = searchPhrase;

    if (searchPhrase.isEmpty) {
      applyFilters();
      return;
    }

    final searchPhraseLowerCase = searchPhrase.toLowerCase();

    _filteredBoardGames = {
      for (var boardGameDetails in _boardGamesStore.allBoardGames.where((boardGameDetails) =>
          boardGameDetails.name.toLowerCase().contains(searchPhraseLowerCase)))
        boardGameDetails.id: boardGameDetails
    };

    notifyListeners();
  }

  void applyFilters() {
    final selectedSortBy = _boardGamesFiltersStore.sortBy.firstWhereOrNull(
      (sb) => sb.selected,
    );

    _filteredBoardGames = {
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

    if (selectedSortBy != null) {
      final sortedFilteredBoardGames = List.of(_filteredBoardGames.values);
      sortedFilteredBoardGames.sort((a, b) {
        if (selectedSortBy.orderBy == OrderBy.Descending) {
          final buffer = a;
          a = b;
          b = buffer;
        }

        switch (selectedSortBy.sortByOption) {
          case SortByOption.Name:
            return a.name.safeCompareTo(b.name);
          case SortByOption.YearPublished:
            return a.yearPublished.safeCompareTo(b.yearPublished);
          case SortByOption.LastUpdated:
            return a.lastModified.safeCompareTo(b.lastModified);
          case SortByOption.Rank:
            return a.rank.safeCompareTo(b.rank);
          case SortByOption.NumberOfPlayers:
            if (selectedSortBy.orderBy == OrderBy.Descending) {
              return b.maxPlayers.safeCompareTo(a.maxPlayers);
            }

            return a.minPlayers.safeCompareTo(b.maxPlayers);
          case SortByOption.Playtime:
            return a.maxPlaytime.safeCompareTo(b.maxPlaytime);
          case SortByOption.Rating:
            return b.rating.safeCompareTo(a.rating);
          default:
            return a.lastModified.safeCompareTo(b.lastModified);
        }
      });
      _filteredBoardGames = {
        for (var boardGameDetails in sortedFilteredBoardGames) boardGameDetails.id: boardGameDetails
      };
    }

    notifyListeners();
  }
}
