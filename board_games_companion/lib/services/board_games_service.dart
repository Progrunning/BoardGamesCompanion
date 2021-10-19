import 'package:injectable/injectable.dart';

import '../common/hive_boxes.dart';
import '../models/collection_sync_result.dart';
import '../models/hive/board_game_details.dart';
import 'board_games_geek_service.dart';
import 'hive_base_service.dart';
import 'preferences_service.dart';

@singleton
class BoardGamesService extends BaseHiveService<BoardGameDetails> {
  BoardGamesService(this._boardGameGeekService, this._preferenceService);

  final BoardGamesGeekService _boardGameGeekService;
  final PreferencesService _preferenceService;

  Future<List<BoardGameDetails>> retrieveBoardGames() async {
    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return <BoardGameDetails>[];
    }

    final List<BoardGameDetails> boardGames = storageBox.values.toList();
    if (!_preferenceService.getMigratedToMultipleCollections()) {
      await _migrateToMultipleCollections(boardGames);
    }

    return boardGames;
  }

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails.id.isEmpty) {
      return;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return;
    }

    await storageBox.put(boardGameDetails.id, boardGameDetails);
  }

  Future<bool> isInCollection(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails.id.isEmpty) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return false;
    }

    return storageBox.containsKey(boardGameDetails.id);
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    if (boardGameDetailsId.isEmpty) {
      return;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return;
    }

    await storageBox.delete(boardGameDetailsId);
  }

  Future<void> removeBoardGames(List<String> boardGameDetailsIds) async {
    if (boardGameDetailsIds.isEmpty) {
      return;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return;
    }

    await storageBox.deleteAll(boardGameDetailsIds);
  }

  Future<void> removeAllBoardGames() async {
    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return;
    }

    await storageBox.clear();
  }

  Future<CollectionSyncResult> syncCollection(String username) async {
    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return CollectionSyncResult();
    }

    final collectionSyncResult = await _boardGameGeekService.syncCollection(username);
    if (!collectionSyncResult.isSuccess || (collectionSyncResult.data?.isEmpty ?? true)) {
      return collectionSyncResult;
    }

    final syncedCollectionMap = <String, BoardGameDetails>{
      for (BoardGameDetails boardGameDetails in collectionSyncResult.data!)
        boardGameDetails.id: boardGameDetails
    };

    final existingCollectionMap = <String, BoardGameDetails>{
      for (BoardGameDetails boardGameDetails in storageBox.values)
        boardGameDetails.id: boardGameDetails
    };

    final List<BoardGameDetails> boardGamesToRemove = storageBox.values
        .where((boardGameDetails) =>
            boardGameDetails.isBggSynced! && !syncedCollectionMap.containsKey(boardGameDetails.id))
        .toList();

    // Remove
    for (final boardGameToRemove in boardGamesToRemove) {
      await storageBox.delete(boardGameToRemove.id);
    }

    // Add & Update
    for (final syncedBoardGame in collectionSyncResult.data!) {
      // Take local collection settings over the BGG
      if (existingCollectionMap.containsKey(syncedBoardGame.id)) {
        final existingBoardGame = existingCollectionMap[syncedBoardGame.id]!;
        syncedBoardGame.isOnWishlist = existingBoardGame.isOnWishlist;
        syncedBoardGame.isOwned = existingBoardGame.isOwned;
        syncedBoardGame.isFriends = existingBoardGame.isFriends;
      }
      await storageBox.put(syncedBoardGame.id, syncedBoardGame);
    }

    return collectionSyncResult;
  }

  Future<void> _migrateToMultipleCollections(List<BoardGameDetails> boardGames) async {
    for (final boardGame in boardGames.where(
        (boardGame) => !boardGame.isOwned! && !boardGame.isOnWishlist! && !boardGame.isFriends!)) {
      boardGame.isOwned = true;
      await addOrUpdateBoardGame(boardGame);
    }

    await _preferenceService.setMigratedToMultipleCollections(migratedToMultipleCollections: true);
  }
}
