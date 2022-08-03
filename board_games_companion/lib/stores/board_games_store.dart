// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/collection_import_result.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/board_game_expansion.dart';
import '../models/import_result.dart';
import '../services/board_games_service.dart';
import '../services/playthroughs_service.dart';

part 'board_games_store.g.dart';

@singleton
class BoardGamesStore = _BoardGamesStore with _$BoardGamesStore;

abstract class _BoardGamesStore with Store {
  _BoardGamesStore(
    this._boardGamesService,
    this._playthroughService,
  );

  final BoardGamesService _boardGamesService;
  final PlaythroughService _playthroughService;

  @observable
  ObservableList<BoardGameDetails> allBoardGames = ObservableList.of([]);

  @computed
  ObservableMap<String, BoardGameDetails> get allBoardGamesMap =>
      ObservableMap.of({for (var boardGame in allBoardGames) boardGame.id: boardGame});

  @computed
  List<BoardGameDetails> get allBoardGamesInCollections => allBoardGames
      .where((BoardGameDetails boardGame) =>
          boardGame.isOwned! || boardGame.isFriends! || boardGame.isOnWishlist!)
      .toList();

  @computed
  ObservableMap<String, BoardGameDetails> get allBoardGamesInCollectionsMap =>
      ObservableMap.of({for (var boardGame in allBoardGamesInCollections) boardGame.id: boardGame});

  @action
  bool isInAnyCollection(String? boardGameId) {
    if (boardGameId?.isBlank ?? true) {
      return false;
    }

    return allBoardGames.any((boardGameDetails) =>
        boardGameDetails.id == boardGameId &&
        (boardGameDetails.isFriends! ||
            boardGameDetails.isOnWishlist! ||
            boardGameDetails.isOwned!));
  }

  @action
  Future<void> loadBoardGames() async {
    allBoardGames = ObservableList.of(await _boardGamesService.retrieveBoardGames());
  }

  @action
  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    try {
      await _boardGamesService.addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }

    final existingBoardGameDetails = _retrieveBoardGame(boardGameDetails.id);
    if (existingBoardGameDetails == null) {
      allBoardGames.add(boardGameDetails);
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
  }

  @action
  Future<BoardGameDetails?> refreshBoardGameDetails(String boardGameId) async {
    try {
      final boardGameDetails = await _boardGamesService.getBoardGame(boardGameId);
      if (boardGameDetails == null) {
        return null;
      }

      if (!(boardGameDetails.isExpansion ?? true)) {
        for (final boardGameExpansion in boardGameDetails.expansions) {
          final boardGameExpansionDetails = allBoardGames.firstWhereOrNull(
            (boardGame) => boardGame.id == boardGameExpansion.id,
          );

          if (boardGameExpansionDetails != null) {
            boardGameExpansionDetails.isExpansion = true;
            if (boardGameExpansionDetails.isOwned!) {
              // TODO MK Think why does the isInCollection flag exists
              //         When determining if a board extension is in collection we should look at the collections and check if board game id of an expansion exists in it
              boardGameExpansion.isInCollection = true;
            }
          }
        }
      }

      final existingBoardGameDetails = _retrieveBoardGame(boardGameDetails.id);
      if (existingBoardGameDetails != null) {
        boardGameDetails.isFriends = existingBoardGameDetails.isFriends;
        boardGameDetails.isOnWishlist = existingBoardGameDetails.isOnWishlist;
        boardGameDetails.isOwned = existingBoardGameDetails.isOwned;
      }

      await addOrUpdateBoardGame(boardGameDetails);

      return boardGameDetails;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  @action
  Future<void> removeBoardGame(String boardGameDetailsId) async {
    try {
      await _boardGamesService.removeBoardGame(boardGameDetailsId);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }

    final boardGameToRemove = allBoardGames.firstWhereOrNull(
      (boardGame) => boardGame.id == boardGameDetailsId,
    );

    if (boardGameToRemove == null) {
      return;
    }

    allBoardGames.remove(boardGameToRemove);
  }

  @action
  Future<void> removeAllBggBoardGames() async {
    try {
      final bggSyncedBoardGames = allBoardGames
          .where((boardGame) => boardGame.isBggSynced!)
          .map((boardGame) => boardGame.id)
          .toList();
      await _boardGamesService.removeBoardGames(bggSyncedBoardGames);
      await _playthroughService.deletePlaythroughsForGames(bggSyncedBoardGames);

      allBoardGames.removeWhere((boardGame) => boardGame.isBggSynced!);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }
  }

  @action
  Future<CollectionImportResult> importCollections(String username) async {
    var importResult = CollectionImportResult();

    try {
      importResult = await _boardGamesService.importCollections(username);
      if (importResult.isSuccess) {
        allBoardGames = ObservableList.of(await _boardGamesService.retrieveBoardGames());
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      importResult = CollectionImportResult.failure([ImportError.exception(e, stack)]);
    }

    return importResult;
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

  BoardGameDetails? _retrieveBoardGame(String boardGameId) {
    return allBoardGames.firstWhereOrNull(
      (BoardGameDetails boardGameDetails) => boardGameDetails.id == boardGameId,
    );
  }
}
