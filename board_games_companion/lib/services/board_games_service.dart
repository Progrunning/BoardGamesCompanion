import 'package:injectable/injectable.dart';

import '../common/enums/game_family.dart';
import '../models/bgg/bgg_import_plays.dart';
import '../models/bgg/bgg_plays_import_result.dart';
import '../models/collection_import_result.dart';
import '../models/hive/board_game_details.dart';
import 'board_games_geek_service.dart';
import 'hive_base_service.dart';

@singleton
class BoardGamesService extends BaseHiveService<BoardGameDetails, BoardGamesService> {
  BoardGamesService(super.hive, this._boardGameGeekService);

  final BoardGamesGeekService _boardGameGeekService;

  static const int _maxNumberOfImportedPlaysPerPage = 100;

  Future<List<BoardGameDetails>> retrieveBoardGames() async {
    if (!await ensureBoxOpen()) {
      return <BoardGameDetails>[];
    }

    return storageBox.values.toList();
  }

  Future<BoardGameDetails?> getBoardGame(String boardGameId) =>
      _boardGameGeekService.getDetails(boardGameId);

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails.id.isEmpty) {
      return;
    }

    if (!await ensureBoxOpen()) {
      return;
    }

    await storageBox.put(boardGameDetails.id, boardGameDetails);
  }

  Future<bool> isInCollection(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails.id.isEmpty) {
      return false;
    }

    if (!await ensureBoxOpen()) {
      return false;
    }

    return storageBox.containsKey(boardGameDetails.id);
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    if (boardGameDetailsId.isEmpty) {
      return;
    }

    if (!await ensureBoxOpen()) {
      return;
    }

    await storageBox.delete(boardGameDetailsId);
  }

  Future<void> removeBoardGames(List<String> boardGameDetailsIds) async {
    if (boardGameDetailsIds.isEmpty) {
      return;
    }

    if (!await ensureBoxOpen()) {
      return;
    }

    await storageBox.deleteAll(boardGameDetailsIds);
  }

  Future<void> removeAllBoardGames() async {
    if (!await ensureBoxOpen()) {
      return;
    }

    await storageBox.clear();
  }

  Future<BggPlaysImportResult> importPlays(
    String username,
    String boardGameId,
    GameFamily gameFamily,
  ) async {
    final playsImportResult = BggPlaysImportResult()
      ..data = []
      ..errors = [];

    BggPlaysImportResult pagePlaysImportResult;
    var pageNumber = 1;

    do {
      pagePlaysImportResult = await _boardGameGeekService.importPlays(BggImportPlays(
        username,
        boardGameId,
        gameFamily,
        pageNumber: pageNumber,
      ));
      playsImportResult.data!.addAll(pagePlaysImportResult.data ?? []);
      playsImportResult.errors!.addAll(pagePlaysImportResult.errors ?? []);
      playsImportResult.playsToImportTotal += pagePlaysImportResult.playsToImportTotal;
      pageNumber++;
    } while (pagePlaysImportResult.playsToImportTotal >= _maxNumberOfImportedPlaysPerPage);

    return playsImportResult;
  }

  Future<CollectionImportResult> importCollections(String username) async {
    if (!await ensureBoxOpen()) {
      return CollectionImportResult();
    }

    final collectionImportResult = await _boardGameGeekService.importCollections(username);
    if (!collectionImportResult.isSuccess || (collectionImportResult.data?.isEmpty ?? true)) {
      return collectionImportResult;
    }

    final existingCollectionMap = <String, BoardGameDetails>{
      for (final BoardGameDetails boardGameDetails in storageBox.values)
        boardGameDetails.id: boardGameDetails
    };

    // Add & Update
    for (var importedBoardGame in collectionImportResult.data!) {
      // Ensure that we don't lose some of the game details if we have more than the import can provide
      // (e.g. expansions)
      //
      // IMPORTANT: Do not override isOwn or isWhislist properties because BGG import should be the source of truth
      if (existingCollectionMap.containsKey(importedBoardGame.id)) {
        final existingBoardGame = existingCollectionMap[importedBoardGame.id]!;
        importedBoardGame = importedBoardGame.copyWith(
          isFriends: existingBoardGame.isFriends,
          isExpansion: existingBoardGame.isExpansion,
          avgWeight: existingBoardGame.avgWeight,
          commentsNumber: existingBoardGame.commentsNumber,
          expansions: existingBoardGame.expansions,
          artists: existingBoardGame.artists,
          publishers: existingBoardGame.publishers,
          desingers: existingBoardGame.desingers,
          minAge: existingBoardGame.minAge,
          settings: existingBoardGame.settings,
          prices: existingBoardGame.prices,
        );
      }

      await storageBox.put(importedBoardGame.id, importedBoardGame);
    }

    return collectionImportResult;
  }
}
