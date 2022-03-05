import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../common/enums/enums.dart';
import '../common/enums/games_tab.dart';
import '../common/enums/order_by.dart';
import '../common/enums/sort_by_option.dart';
import '../common/hive_boxes.dart';
import '../extensions/date_time_extensions.dart';
import '../extensions/double_extensions.dart';
import '../extensions/int_extensions.dart';
import '../extensions/string_extensions.dart';
import '../models/collection_sync_result.dart';
import '../models/hive/board_game_category.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/board_game_expansion.dart';
import '../services/board_games_service.dart';
import '../services/player_service.dart';
import '../services/playthroughs_service.dart';
import '../services/score_service.dart';
import 'board_games_filters_store.dart';

class BoardGamesStore with ChangeNotifier {
  BoardGamesStore(
    this._boardGamesService,
    this._playthroughService,
    this._scoreService,
    this._playerService,
    this._boardGamesFiltersStore,
  );

  final BoardGamesService _boardGamesService;
  final PlaythroughService _playthroughService;
  final ScoreService _scoreService;
  final PlayerService _playerService;
  final BoardGamesFiltersStore _boardGamesFiltersStore;

  String? _searchPhrase;
  List<BoardGameDetails> _allBoardGames = [];
  List<BoardGameDetails> _filteredBoardGames = [];
  LoadDataState _loadDataState = LoadDataState.none;
  GamesTab _selectedTab = GamesTab.Owned;

  LoadDataState get loadDataState => _loadDataState;
  List<BoardGameDetails>? get filteredBoardGames => _filteredBoardGames;
  List<BoardGameDetails> get filteredBoardGamesOwned =>
      _filteredBoardGames.where((boardGame) => boardGame.isOwned!).toList();
  List<BoardGameDetails> get filteredBoardGamesOnWishlist =>
      _filteredBoardGames.where((boardGame) => boardGame.isOnWishlist!).toList();
  List<BoardGameDetails> get filteredBoardGamesFriends =>
      _filteredBoardGames.where((boardGame) => boardGame.isFriends!).toList();

  // MK All board games in collection
  List<BoardGameDetails> get allboardGames => _allBoardGames;
  bool get anyBoardGamesInCollections => _allBoardGames
      .any((boardGame) => boardGame.isOwned! || boardGame.isOnWishlist! || boardGame.isFriends!);
  String? get searchPhrase => _searchPhrase;

  List<BoardGameCategory> get filteredBoardGamesCategories {
    final allBoardGameCategories = filteredBoardGames!
        .map((boardGame) => boardGame.categories)
        .expand((categories) => categories!)
        .toList();
    final uniqueBoardGameCategories = allBoardGameCategories.map((category) => category.id).toSet();
    allBoardGameCategories.retainWhere((category) => uniqueBoardGameCategories.remove(category.id));
    return allBoardGameCategories;
  }

  Future<void> loadBoardGames() async {
    _loadDataState = LoadDataState.loading;
    notifyListeners();

    try {
      _allBoardGames = await _boardGamesService.retrieveBoardGames();
      _filteredBoardGames = List.of(_allBoardGames);
      await _boardGamesFiltersStore.loadFilterPreferences();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      _loadDataState = LoadDataState.error;
    }

    _loadDataState = LoadDataState.loaded;
    notifyListeners();
  }

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    try {
      await _boardGamesService.addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }

    final existingBoardGameDetails = retrieveBoardGame(boardGameDetails.id);
    if (existingBoardGameDetails == null) {
      _allBoardGames.add(boardGameDetails);
      _filteredBoardGames.add(boardGameDetails);
    } else {
      existingBoardGameDetails.imageUrl = boardGameDetails.imageUrl;
      existingBoardGameDetails.name = boardGameDetails.name;
      existingBoardGameDetails.rank = boardGameDetails.rank;
      existingBoardGameDetails.rating = boardGameDetails.rating;
      existingBoardGameDetails.votes = boardGameDetails.votes;
      existingBoardGameDetails.yearPublished = boardGameDetails.yearPublished;
      existingBoardGameDetails.categories = boardGameDetails.categories;
      existingBoardGameDetails.description = boardGameDetails.description;
      existingBoardGameDetails.minPlayers = boardGameDetails.minPlayers;
      existingBoardGameDetails.maxPlayers = boardGameDetails.maxPlayers;
      existingBoardGameDetails.minPlaytime = boardGameDetails.minPlaytime;
      existingBoardGameDetails.maxPlaytime = boardGameDetails.maxPlaytime;
      existingBoardGameDetails.minAge = boardGameDetails.minAge;
      existingBoardGameDetails.avgWeight = boardGameDetails.avgWeight;
      existingBoardGameDetails.publishers = boardGameDetails.publishers;
      existingBoardGameDetails.artists = boardGameDetails.artists;
      existingBoardGameDetails.desingers = boardGameDetails.desingers;
      existingBoardGameDetails.commentsNumber = boardGameDetails.commentsNumber;
      existingBoardGameDetails.ranks = boardGameDetails.ranks;
      existingBoardGameDetails.lastModified = boardGameDetails.lastModified;
      existingBoardGameDetails.isExpansion = boardGameDetails.isExpansion;
      existingBoardGameDetails.isFriends = boardGameDetails.isFriends;
      existingBoardGameDetails.isOnWishlist = boardGameDetails.isOnWishlist;
      existingBoardGameDetails.isOwned = boardGameDetails.isOwned;
      _updateBoardGameExpansions(existingBoardGameDetails, boardGameDetails);
    }

    notifyListeners();
  }

  void _updateBoardGameExpansions(
    BoardGameDetails existingBoardGameDetails,
    BoardGameDetails boardGameDetails,
  ) {
    existingBoardGameDetails.expansions = boardGameDetails.expansions;

// MK If updating an expansion, update IsInCollection flag for the parent board game
    if (boardGameDetails.isExpansion!) {
      final BoardGamesExpansion? parentBoardGameExpansion = allboardGames
          .expand((BoardGameDetails boardGameDetails) => boardGameDetails.expansions)
          .firstWhereOrNull(
            (BoardGamesExpansion boardGameExpansion) =>
                boardGameExpansion.id == boardGameDetails.id,
          );

      if (parentBoardGameExpansion != null) {
        parentBoardGameExpansion.isInCollection = boardGameDetails.isOwned;
      }
    }
  }

  Future<void> updateDetails(BoardGameDetails boardGameDetails) async {
    try {
      await addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }
  }

  BoardGameDetails? retrieveBoardGame(String boardGameId) {
    return allboardGames.firstWhereOrNull(
      (BoardGameDetails boardGameDetails) => boardGameDetails.id == boardGameId,
    );
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    try {
      await _boardGamesService.removeBoardGame(boardGameDetailsId);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }

    final boardGameToRemove = _allBoardGames.firstWhereOrNull(
      (boardGame) => boardGame.id == boardGameDetailsId,
    );

    if (boardGameToRemove == null) {
      return;
    }

    _allBoardGames.remove(boardGameToRemove);
    _filteredBoardGames.remove(boardGameToRemove);

    notifyListeners();
  }

  Future<void> removeAllBggBoardGames() async {
    try {
      final bggSyncedBoardGames = _allBoardGames
          .where((boardGame) => boardGame.isBggSynced!)
          .map((boardGame) => boardGame.id)
          .toList();
      await _boardGamesService.removeBoardGames(bggSyncedBoardGames);
      await _playthroughService.deletePlaythroughsForGames(bggSyncedBoardGames);

      _filteredBoardGames.removeWhere((boardGame) => boardGame.isBggSynced!);
      _allBoardGames.removeWhere((boardGame) => boardGame.isBggSynced!);

      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }
  }

  Future<CollectionSyncResult> syncCollection(String username) async {
    var syncResult = CollectionSyncResult();

    try {
      syncResult = await _boardGamesService.syncCollection(username);
      if (syncResult.isSuccess) {
        _allBoardGames = await _boardGamesService.retrieveBoardGames();
        _filteredBoardGames = List.of(_allBoardGames);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    _loadDataState = LoadDataState.loaded;
    applyFilters();

    return syncResult;
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

    _filteredBoardGames = List.of(_allBoardGames
        .where((boardGameDetails) =>
            boardGameDetails.name.toLowerCase().contains(searchPhraseLowerCase))
        .toList());

    notifyListeners();
  }

  void applyFilters() {
    final selectedSortBy = _boardGamesFiltersStore.sortBy.firstWhereOrNull(
      (sb) => sb.selected,
    );

    _filteredBoardGames = _allBoardGames
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

  @override
  void dispose() {
    _boardGamesService.closeBox(HiveBoxes.BoardGames);
    _playthroughService.closeBox(HiveBoxes.Playthroughs);
    _scoreService.closeBox(HiveBoxes.Scores);
    _playerService.closeBox(HiveBoxes.Players);

    super.dispose();
  }

  GamesTab get selectedTab => _selectedTab;
  set selectedTab(GamesTab value) {
    if (_selectedTab != value) {
      _selectedTab = value;
      notifyListeners();
    }
  }
}
