import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/collection_sync_result.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';

import 'hive_base_service.dart';

class BoardGamesService extends BaseHiveService<BoardGameDetails> {
  BoardGamesService(this._boardGameGeekService);

  final BoardGamesGeekService _boardGameGeekService;

  Future<List<BoardGameDetails>> retrieveBoardGames() async {
    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return <BoardGameDetails>[];
    }

    return storageBox.values?.toList();
  }

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails?.id?.isEmpty ?? true) {
      return;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return;
    }

    await storageBox.put(boardGameDetails.id, boardGameDetails);
  }

  Future<bool> isInCollection(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails?.id?.isEmpty ?? true) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return false;
    }

    return storageBox.containsKey(boardGameDetails.id);
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    if (boardGameDetailsId?.isEmpty ?? true) {
      return;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return;
    }

    await storageBox.delete(boardGameDetailsId);
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
    if (collectionSyncResult.isSuccess) {
      if (collectionSyncResult.data?.isEmpty ?? true) {
        storageBox.clear();
      } else {
        final syncedCollectionMap = <String, BoardGameDetails>{
          for (BoardGameDetails boardGameDetails in collectionSyncResult.data)
            boardGameDetails.id: boardGameDetails
        };

        final boardGamesToRemove = storageBox.values
            ?.where((boardGameDetails) => !syncedCollectionMap.containsKey(boardGameDetails.id))
            ?.toList();

        // Remove
        for (final boardGameToRemove in boardGamesToRemove) {
          await storageBox?.delete(boardGameToRemove.id);
        }

        // Add & Update
        for (final syncedBoardGame in collectionSyncResult.data) {
          await storageBox?.put(syncedBoardGame.id, syncedBoardGame);
        }
      }
    }

    return collectionSyncResult;
  }
}
