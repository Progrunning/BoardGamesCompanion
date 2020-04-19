import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/collection_sync_result.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';

import 'hide_base_service.dart';

class BoardGamesService extends BaseHiveService<BoardGameDetails> {
  final BoardGamesGeekService _boardGameGeekService;

  BoardGamesService(this._boardGameGeekService);

  Future<List<BoardGameDetails>> retrieveBoardGames() async {
    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return List<BoardGameDetails>();
    }

    return storageBox?.toMap()?.values?.toList();
  }

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails?.id?.isEmpty ?? true) {
      return;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return;
    }

    await storageBox?.put(boardGameDetails.id, boardGameDetails);
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    if (boardGameDetailsId?.isEmpty ?? true) {
      return;
    }

    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return;
    }

    await storageBox?.delete(boardGameDetailsId);
  }

  Future<CollectionSyncResult> syncCollection(String username) async {
    if (!await ensureBoxOpen(HiveBoxes.BoardGames)) {
      return CollectionSyncResult();
    }

    final syncedBoardGames =
        await _boardGameGeekService.syncCollection(username);
    for (var syncedBoardGame in syncedBoardGames) {
      await storageBox?.put(syncedBoardGame.id, syncedBoardGame);
    }

    return CollectionSyncResult()
      ..isSuccess = true
      ..data = syncedBoardGames;
  }
}
