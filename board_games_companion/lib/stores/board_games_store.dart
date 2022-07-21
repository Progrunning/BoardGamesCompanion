import 'package:basics/basics.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../common/hive_boxes.dart';
import '../models/collection_import_result.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/board_game_expansion.dart';
import '../models/import_result.dart';
import '../services/board_games_service.dart';
import '../services/player_service.dart';
import '../services/playthroughs_service.dart';
import '../services/score_service.dart';

class BoardGamesStore with ChangeNotifier {
  BoardGamesStore(
    this._boardGamesService,
    this._playthroughService,
    this._scoreService,
    this._playerService,
  );

  final BoardGamesService _boardGamesService;
  final PlaythroughService _playthroughService;
  final ScoreService _scoreService;
  final PlayerService _playerService;

  List<BoardGameDetails> _allBoardGames = [];
  List<BoardGameDetails> get allBoardGames => _allBoardGames;

  bool isInAnyCollection(String? boardGameId) {
    if (boardGameId?.isBlank ?? true) {
      return false;
    }

    return _allBoardGames.any((boardGameDetails) =>
        boardGameDetails.id == boardGameId &&
        (boardGameDetails.isFriends! ||
            boardGameDetails.isOnWishlist! ||
            boardGameDetails.isOwned!));
  }

  Future<void> loadBoardGames() async {
    _allBoardGames = await _boardGamesService.retrieveBoardGames();
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
      existingBoardGameDetails.settings = boardGameDetails.settings;
      _updateBoardGameExpansions(existingBoardGameDetails, boardGameDetails);
    }

    notifyListeners();
  }

  void _updateBoardGameExpansions(
    BoardGameDetails existingBoardGameDetails,
    BoardGameDetails boardGameDetails,
  ) {
    if (boardGameDetails.isExpansion ?? false) {
      // MK If updating an expansion, find the main game and update IsInCollection flag for this expansion
      final BoardGamesExpansion? parentBoardGameExpansion = allBoardGames
          .expand((BoardGameDetails boardGameDetails) => boardGameDetails.expansions)
          .firstWhereOrNull(
            (BoardGamesExpansion boardGameExpansion) =>
                boardGameExpansion.id == boardGameDetails.id,
          );

      if (parentBoardGameExpansion != null) {
        parentBoardGameExpansion.isInCollection = boardGameDetails.isOwned;
      }
    } else {
      // MK Update main board game expansions list
      existingBoardGameDetails.expansions = boardGameDetails.expansions;
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
    return allBoardGames.firstWhereOrNull(
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

      _allBoardGames.removeWhere((boardGame) => boardGame.isBggSynced!);

      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }
  }

  Future<CollectionImportResult> importCollections(String username) async {
    var importResult = CollectionImportResult();

    try {
      importResult = await _boardGamesService.importCollections(username);
      if (importResult.isSuccess) {
        _allBoardGames = await _boardGamesService.retrieveBoardGames();
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      importResult = CollectionImportResult.failure([ImportError.exception(e, stack)]);
    }

    notifyListeners();

    return importResult;
  }

  @override
  void dispose() {
    _boardGamesService.closeBox(HiveBoxes.boardGames);
    _playthroughService.closeBox(HiveBoxes.playthroughs);
    _scoreService.closeBox(HiveBoxes.scores);
    _playerService.closeBox(HiveBoxes.players);

    super.dispose();
  }
}
