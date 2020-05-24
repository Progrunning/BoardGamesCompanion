import 'package:board_games_companion/common/enums/enums.dart';
import 'package:board_games_companion/common/enums/order_by.dart';
import 'package:board_games_companion/common/enums/sort_by_option.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/collection_sync_result.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';

import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:board_games_companion/extensions/date_time_extensions.dart';
import 'package:board_games_companion/extensions/int_extensions.dart';
import 'package:board_games_companion/extensions/double_extensions.dart';
import 'package:board_games_companion/extensions/string_extensions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class BoardGamesStore with ChangeNotifier {
  final BoardGamesService _boardGamesService;
  final PlaythroughService _playthroughService;
  final ScoreService _scoreService;
  final PlayerService _playerService;
  final BoardGamesFiltersStore _boardGamesFiltersStore;

  String _searchPhrase;
  List<BoardGameDetails> _allBoardGames;
  List<BoardGameDetails> _boardGames;
  LoadDataState _loadDataState = LoadDataState.None;

  BoardGamesStore(
    this._boardGamesService,
    this._playthroughService,
    this._scoreService,
    this._playerService,
    this._boardGamesFiltersStore,
  );

  LoadDataState get loadDataState => _loadDataState;
  List<BoardGameDetails> get boardGames => _boardGames;
  bool get hasBoardGames => _allBoardGames?.isNotEmpty ?? false;
  String get searchPhrase => _searchPhrase;

  Future<void> loadBoardGames() async {
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

    try {
      _allBoardGames = await _boardGamesService.retrieveBoardGames();
      _boardGames = List.of(_allBoardGames);
      await _boardGamesFiltersStore.loadFilterPreferences();
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      _loadDataState = LoadDataState.Error;
    }

    _loadDataState = LoadDataState.Loaded;
    notifyListeners();
  }

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    try {
      await _boardGamesService.addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      return;
    }

    final existingBoardGameDetails = _allBoardGames.firstWhere(
        (boardGame) => boardGame.id == boardGameDetails.id,
        orElse: () => null);

    if (existingBoardGameDetails == null) {
      _allBoardGames.add(boardGameDetails);
      _boardGames.add(boardGameDetails);
    } else {
      existingBoardGameDetails.imageUrl = boardGameDetails.imageUrl;
      existingBoardGameDetails.name = boardGameDetails.name;
      existingBoardGameDetails.rank = boardGameDetails.rank;
      existingBoardGameDetails.rating = boardGameDetails.rating;
      existingBoardGameDetails.votes = boardGameDetails.votes;
      existingBoardGameDetails.yearPublished = boardGameDetails.yearPublished;
      existingBoardGameDetails.categories = boardGameDetails.categories;
      existingBoardGameDetails.description = boardGameDetails.description;
    }

    notifyListeners();
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    try {
      await _boardGamesService.removeBoardGame(boardGameDetailsId);
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      return;
    }

    _allBoardGames
        .removeWhere((boardGame) => boardGame.id == boardGameDetailsId);
    _boardGames.removeWhere((boardGame) => boardGame.id == boardGameDetailsId);

    notifyListeners();
  }

  Future<void> removeAllBoardGames() async {
    try {
      await _boardGamesService.removeAllBoardGames();
      await _playthroughService.deleteAllPlaythrough();
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      return;
    }

    _boardGames.clear();
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
        _boardGames = List.of(_allBoardGames);
      }
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
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
      _boardGames = List.of(_allBoardGames);
      notifyListeners();
    }

    final searchPhraseLowerCase = searchPhrase.toLowerCase();

    _boardGames = List.of(_allBoardGames
        .where((boardGameDetails) => boardGameDetails.name
            ?.toLowerCase()
            ?.contains(searchPhraseLowerCase))
        .toList());

    notifyListeners();
  }

  void applyFilters() {
    if (boardGames?.isEmpty ?? true) {
      return;
    }

    final selectedSortBy = _boardGamesFiltersStore.sortBy.firstWhere(
      (sb) => sb.selected,
      orElse: () => null,
    );

    _boardGames = _allBoardGames
        .where((boardGame) =>
            _boardGamesFiltersStore.filterByRating == null ||
            boardGame.rating >= _boardGamesFiltersStore.filterByRating)
        .toList();

    if (selectedSortBy != null) {
      boardGames.sort((a, b) {
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
}
