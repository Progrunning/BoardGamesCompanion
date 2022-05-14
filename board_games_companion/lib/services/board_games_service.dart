import 'package:board_games_companion/models/bgg/bgg_plays_import_result.dart';
import 'package:injectable/injectable.dart';

import '../common/hive_boxes.dart';
import '../models/collection_import_result.dart';
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

  Future<BggPlaysImportResult> importPlays(String username, String boardGameId) async {
    return _boardGameGeekService.importPlays(username, boardGameId);
  }

  Future<CollectionImportResult> importCollections(String username) async {
    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return CollectionImportResult();
    }

    final collectionImportResult = await _boardGameGeekService.importCollections(username);
    if (!collectionImportResult.isSuccess || (collectionImportResult.data?.isEmpty ?? true)) {
      return collectionImportResult;
    }

    final importedCollectionMap = <String, BoardGameDetails>{
      for (final BoardGameDetails boardGameDetails in collectionImportResult.data!)
        boardGameDetails.id: boardGameDetails
    };

    final existingCollectionMap = <String, BoardGameDetails>{
      for (final BoardGameDetails boardGameDetails in storageBox.values)
        boardGameDetails.id: boardGameDetails
    };

    final List<BoardGameDetails> boardGamesToRemove = storageBox.values
        .where((boardGameDetails) =>
            boardGameDetails.isBggSynced! &&
            !importedCollectionMap.containsKey(boardGameDetails.id))
        .toList();

    // Remove
    for (final boardGameToRemove in boardGamesToRemove) {
      await storageBox.delete(boardGameToRemove.id);
    }

    // Add & Update
    for (final importedBoardGame in collectionImportResult.data!) {
      // Take local collection settings over the BGG
      if (existingCollectionMap.containsKey(importedBoardGame.id)) {
        final existingBoardGame = existingCollectionMap[importedBoardGame.id]!;
        importedBoardGame.isOnWishlist = existingBoardGame.isOnWishlist;
        importedBoardGame.isOwned = existingBoardGame.isOwned;
        importedBoardGame.isFriends = existingBoardGame.isFriends;
      }
      await storageBox.put(importedBoardGame.id, importedBoardGame);
    }

    return collectionImportResult;
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
