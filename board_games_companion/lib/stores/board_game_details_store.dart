import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'board_games_store.dart';

class BoardGameDetailsStore with ChangeNotifier {
  final BoardGamesGeekService _boardGameGeekService;
  final BoardGamesStore _boardGamesStore;

  BoardGameDetails _boardGameDetails;
  BoardGameDetails get boardGameDetails => _boardGameDetails;

  BoardGameDetailsStore(this._boardGameGeekService, this._boardGamesStore);

  Future<BoardGameDetails> loadBoardGameDetails(String boardGameId) async {
    try {
      final boardGameDetails =
          await _boardGameGeekService.retrieveDetails(boardGameId);
      if (boardGameDetails != null) {
        for (var boardGameExpansion in boardGameDetails.expansions) {
          final boardGameExpansionDetails =
              _boardGamesStore.allboardGames.firstWhere(
            (boardGame) => boardGame.id == boardGameExpansion.id,
            orElse: () => null,
          );

          if (boardGameExpansionDetails != null) {
            boardGameExpansion.isInCollection = true;
          }
        }

        _boardGamesStore.updateDetails(boardGameDetails);

        _boardGameDetails = boardGameDetails;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    notifyListeners();

    return _boardGameDetails;
  }
}
