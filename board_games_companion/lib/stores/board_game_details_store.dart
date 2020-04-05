import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class BoardGameDetailsStore with ChangeNotifier {
  final BoardGamesGeekService _boardGameGeekService;

  BoardGameDetails _boardGameDetails;
  BoardGameDetails get boardGameDetails => _boardGameDetails;

  BoardGameDetailsStore(this._boardGameGeekService);

  Future<BoardGameDetails> loadBoardGameDetails(String boardGameId) async {
    try {
      final boardGameDetails =
          await _boardGameGeekService.retrieveDetails(boardGameId);
      if (boardGameDetails != null) {
        _boardGameDetails = boardGameDetails;
      }
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return _boardGameDetails;
  }
}
