import 'package:board_games_companion/common/enums/order_by.dart';
import 'package:board_games_companion/common/enums/sort_by_option.dart';
import 'package:board_games_companion/extensions/string_extensions.dart';
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

  List<BoardGameDetails> _filteredBoardGames = [];
  List<BoardGameDetails>? get filteredBoardGames => _filteredBoardGames;

  bool get anyBoardGamesInCollections => _boardGamesStore.allboardGames
      .any((boardGame) => boardGame.isOwned! || boardGame.isOnWishlist! || boardGame.isFriends!);

  bool get anyBoardGames => _boardGamesStore.allboardGames.isNotEmpty;

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

  GamesTab _selectedTab = GamesTab.Owned;

  String? get searchPhrase => _searchPhrase;

  bool get isSearchPhraseEmpty => _searchPhrase?.isEmpty ?? true;

  List<BoardGameDetails> get boardGamesInSelectedCollection {
    switch (selectedTab) {
      case GamesTab.Owned:
        return _filteredBoardGames.where((boardGame) => boardGame.isOwned!).toList();
      case GamesTab.Friends:
        return _filteredBoardGames.where((boardGame) => boardGame.isFriends!).toList();
      case GamesTab.Wishlist:
        return _filteredBoardGames.where((boardGame) => boardGame.isOnWishlist!).toList();
    }
  }

  List<BoardGameDetails> get expansionsInSelectedCollection =>
      boardGamesInSelectedCollection.where((boardGame) => boardGame.isExpansion ?? false).toList();

  int get totalExpansionsInCollections => expansionsInSelectedCollection.length;

  bool get hasAnyExpansionsInSelectedCollection => expansionsInSelectedCollection.isNotEmpty;

  List<BoardGameDetails> get mainGamesInCollections => boardGamesInSelectedCollection
      .where((boardGame) => !(boardGame.isExpansion ?? false))
      .toList();

  int get totalMainGamesInCollections => mainGamesInCollections.length;

  bool get anyBoardGamesInSelectedCollection => boardGamesInSelectedCollection.isNotEmpty;

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
      _filteredBoardGames = List.of(_boardGamesStore.allboardGames);
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

    _filteredBoardGames = List.of(_boardGamesStore.allboardGames
        .where((boardGameDetails) =>
            boardGameDetails.name.toLowerCase().contains(searchPhraseLowerCase))
        .toList());

    notifyListeners();
  }

  void applyFilters() {
    final selectedSortBy = _boardGamesFiltersStore.sortBy.firstWhereOrNull(
      (sb) => sb.selected,
    );

    _filteredBoardGames = _boardGamesStore.allboardGames
        .where((boardGame) =>
            (_boardGamesFiltersStore.filterByRating == null ||
                boardGame.rating! >= _boardGamesFiltersStore.filterByRating!) &&
            (_boardGamesFiltersStore.numberOfPlayers == null ||
                (boardGame.maxPlayers != null &&
                    boardGame.minPlayers != null &&
                    (boardGame.maxPlayers! >= _boardGamesFiltersStore.numberOfPlayers! &&
                        boardGame.minPlayers! <= _boardGamesFiltersStore.numberOfPlayers!))))
        .toList();

    if (selectedSortBy != null) {
      filteredBoardGames?.sort((a, b) {
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
    }

    notifyListeners();
  }
}
