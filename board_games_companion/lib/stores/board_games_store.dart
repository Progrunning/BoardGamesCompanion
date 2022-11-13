// ignore_for_file: library_private_types_in_public_api

import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/collection_import_result.dart';
import '../models/hive/board_game_details.dart';
import '../models/import_result.dart';
import '../services/board_games_service.dart';
import '../services/playthroughs_service.dart';
import 'app_store.dart';

part 'board_games_store.g.dart';

@singleton
class BoardGamesStore = _BoardGamesStore with _$BoardGamesStore;

abstract class _BoardGamesStore with Store {
  _BoardGamesStore(
    this._boardGamesService,
    this._playthroughService,
    this._appStore,
  ) {
    // MK When restoring a backup, reload board games
    reaction((_) => _appStore.backupRestored, (bool? backupRestored) async {
      if (backupRestored ?? false) {
        await loadBoardGames();
      }
    });
  }

  final BoardGamesService _boardGamesService;
  final PlaythroughService _playthroughService;
  final AppStore _appStore;

  @observable
  ObservableList<BoardGameDetails> allBoardGames = ObservableList.of([]);

  @computed
  List<BoardGameDetails> get expansions =>
      allBoardGames.where((boardGame) => !boardGame.isMainGame).toList();

  @computed
  List<BoardGameDetails> get ownedExpansions =>
      expansions.where((boardGame) => boardGame.isOwned ?? false).toList();

  @computed
  ObservableMap<String, BoardGameDetails> get allBoardGamesMap =>
      ObservableMap.of({for (var boardGame in allBoardGames) boardGame.id: boardGame});

  @computed
  List<BoardGameDetails> get allBoardGamesInCollections =>
      allBoardGames.where((BoardGameDetails boardGame) => boardGame.isInAnyCollection).toList();

  @computed
  ObservableMap<String, BoardGameDetails> get allBoardGamesInCollectionsMap =>
      ObservableMap.of({for (var boardGame in allBoardGamesInCollections) boardGame.id: boardGame});

  @action
  Future<void> loadBoardGames() async =>
      allBoardGames = ObservableList.of(await _boardGamesService.retrieveBoardGames());

  @action
  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    try {
      await _boardGamesService.addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return;
    }

    final existingBoardGameDetailsIndex =
        allBoardGames.indexWhere((bgd) => bgd.id == boardGameDetails.id);

    if (existingBoardGameDetailsIndex == -1) {
      allBoardGames.add(boardGameDetails);
    } else {
      allBoardGames[existingBoardGameDetailsIndex] = boardGameDetails;
    }
  }

  @action
  Future<void> refreshBoardGameDetails(String boardGameId) async {
    try {
      var boardGameDetails = await _boardGamesService.getBoardGame(boardGameId);
      if (boardGameDetails == null) {
        return;
      }

      if (boardGameDetails.isMainGame) {
        for (final boardGameExpansion in boardGameDetails.expansions) {
          final existingBoardGameExpansionDetails = _retrieveBoardGame(boardGameExpansion.id);
          if (existingBoardGameExpansionDetails != null) {
            await addOrUpdateBoardGame(
              existingBoardGameExpansionDetails.copyWith(isExpansion: true),
            );
          }
        }
      }

      final existingBoardGameDetails = _retrieveBoardGame(boardGameDetails.id);
      if (existingBoardGameDetails != null) {
        boardGameDetails = boardGameDetails.copyWith(
          isFriends: existingBoardGameDetails.isFriends,
          isOnWishlist: existingBoardGameDetails.isOnWishlist,
          isOwned: existingBoardGameDetails.isOwned,
        );
      }

      await addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
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

  BoardGameDetails? _retrieveBoardGame(String boardGameId) {
    return allBoardGames.firstWhereOrNull(
      (BoardGameDetails boardGameDetails) => boardGameDetails.id == boardGameId,
    );
  }
}
