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

  String _searchPhrase;
  List<BoardGameDetails> _allBoardGames;
  List<BoardGameDetails> _filteredBoardGames;
  LoadDataState _loadDataState = LoadDataState.None;
  GamesTab _selectedTab = GamesTab.Colleciton;

  LoadDataState get loadDataState => _loadDataState;
  // MK Board games currently shown in the collection with applied filters
  // TODO consider ranaming
  List<BoardGameDetails> get filteredBoardGames => _filteredBoardGames;
  List<BoardGameDetails> get filteredBoardGamesInCollection =>
      _filteredBoardGames?.where((boardGame) => boardGame.isInCollection)?.toList() ?? [];
  List<BoardGameDetails> get filteredBoardGamesOnWishlist =>
      _filteredBoardGames?.where((boardGame) => boardGame.isOnWishlist)?.toList() ?? [];
  List<BoardGameDetails> get filteredBoardGamesPlayed =>
      _filteredBoardGames?.where((boardGame) => boardGame.isPlayed)?.toList() ?? [];
  // MK All board games in collection
  List<BoardGameDetails> get allboardGames => _allBoardGames;
  bool get hasBoardGames => _allBoardGames?.isNotEmpty ?? false;
  String get searchPhrase => _searchPhrase;

  List<BoardGameCategory> get filteredBoardGamesCategories {
    final allBoardGameCategories = filteredBoardGames
        .map((boardGame) => boardGame.categories)
        .expand((categories) => categories)
        .toList();
    final uniqueBoardGameCategories = allBoardGameCategories.map((category) => category.id).toSet();
    allBoardGameCategories.retainWhere((category) => uniqueBoardGameCategories.remove(category.id));
    return allBoardGameCategories;
  }

  Future<void> loadBoardGames() async {
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

    try {
      _allBoardGames = await _boardGamesService.retrieveBoardGames();
      _filteredBoardGames = List.of(_allBoardGames);
      await _boardGamesFiltersStore.loadFilterPreferences();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      _loadDataState = LoadDataState.Error;
    }

    _loadDataState = LoadDataState.Loaded;
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
      existingBoardGameDetails.isPlayed = boardGameDetails.isPlayed;
      existingBoardGameDetails.isOnWishlist = boardGameDetails.isOnWishlist;
      existingBoardGameDetails.isInCollection = boardGameDetails.isInCollection;
      _updateBoardGameExpansions(existingBoardGameDetails, boardGameDetails);
    }

    _updateExpansionCollectionStatus(boardGameDetails, true);

    notifyListeners();
  }

  void _updateBoardGameExpansions(
    BoardGameDetails existingBoardGameDetails,
    BoardGameDetails boardGameDetails,
  ) {
    if ((boardGameDetails?.expansions?.isEmpty ?? true) ||
        (existingBoardGameDetails?.expansions?.isEmpty ?? true)) {
      existingBoardGameDetails.expansions = boardGameDetails.expansions;
    }

    final expansionsInCollection = <String, BoardGamesExpansion>{
      for (BoardGamesExpansion expansion in existingBoardGameDetails.expansions
          .where((expansion) => expansion.isInCollection ?? false))
        expansion.id: expansion
    };

    for (final updatedExpansion in boardGameDetails.expansions) {
      updatedExpansion.isInCollection = expansionsInCollection.containsKey(updatedExpansion.id);
    }

    existingBoardGameDetails.expansions = boardGameDetails.expansions;
  }

  Future<void> updateDetails(BoardGameDetails boardGameDetails) async {
    try {
      await addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }
  }

  BoardGameDetails retrieveBoardGame(String boardGameId) {
    return allboardGames?.firstWhere(
      (BoardGameDetails boardGameDetails) => boardGameDetails.id == boardGameId,
      orElse: () => null,
    );
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    try {
      await _boardGamesService.removeBoardGame(boardGameDetailsId);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }

    final boardGameToRemove = _allBoardGames.firstWhere(
      (boardGame) => boardGame.id == boardGameDetailsId,
      orElse: () => null,
    );

    if (boardGameToRemove == null) {
      return;
    }

    _updateExpansionCollectionStatus(boardGameToRemove, false);

    _allBoardGames.remove(boardGameToRemove);
    _filteredBoardGames.remove(boardGameToRemove);

    notifyListeners();
  }

  Future<void> removeAllBoardGames() async {
    try {
      await _boardGamesService.removeAllBoardGames();
      await _playthroughService.deleteAllPlaythrough();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }

    _filteredBoardGames.clear();
    _allBoardGames.clear();

    notifyListeners();
  }

  Future<CollectionSyncResult> syncCollection(String username) async {
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

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

    _loadDataState = LoadDataState.Loaded;
    notifyListeners();

    return syncResult;
  }

  void updateSearchResults(String searchPhrase) {
    if (searchPhrase?.isEmpty == true && _searchPhrase?.isEmpty == true) {
      return;
    }

    _searchPhrase = searchPhrase;

    if (searchPhrase?.isEmpty ?? true) {
      applyFilters();
      return;
    }

    final searchPhraseLowerCase = searchPhrase.toLowerCase();

    _filteredBoardGames = List.of(_allBoardGames
        .where((boardGameDetails) =>
            boardGameDetails.name?.toLowerCase()?.contains(searchPhraseLowerCase))
        .toList());

    notifyListeners();
  }

  void applyFilters() {
    final selectedSortBy = _boardGamesFiltersStore.sortBy.firstWhere(
      (sb) => sb.selected,
      orElse: () => null,
    );

    _filteredBoardGames = _allBoardGames
        ?.where((boardGame) =>
            (_boardGamesFiltersStore.filterByRating == null ||
                boardGame.rating >= _boardGamesFiltersStore.filterByRating) &&
            (_boardGamesFiltersStore.numberOfPlayers == null ||
                (boardGame.maxPlayers != null &&
                    boardGame.minPlayers != null &&
                    (boardGame.maxPlayers >= _boardGamesFiltersStore.numberOfPlayers &&
                        boardGame.minPlayers <= _boardGamesFiltersStore.numberOfPlayers))))
        ?.toList();

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

  void _updateExpansionCollectionStatus(
    BoardGameDetails boardGameToRemove,
    bool inCollection,
  ) {
    if (!boardGameToRemove.isExpansion) {
      return;
    }

    final boardGameExpansion = _allBoardGames
        .map<List<BoardGamesExpansion>>((boardGame) => boardGame.expansions)
        .expand((expansions) => expansions)
        .toList()
        .firstWhere((expansion) => expansion.id == boardGameToRemove.id, orElse: () => null);

    if (boardGameExpansion != null) {
      boardGameExpansion.isInCollection = inCollection;
    }
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
