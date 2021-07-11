import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../common/analytics.dart';
import '../models/hive/board_game_details.dart';
import '../services/board_games_geek_service.dart';
import 'board_games_store.dart';

class BoardGameDetailsStore with ChangeNotifier {
  final BoardGamesGeekService _boardGameGeekService;
  final BoardGamesStore _boardGamesStore;
  final _analyticsService;

  BoardGameDetails _boardGameDetails;

  BoardGameDetails get boardGameDetails => _boardGameDetails;

  BoardGameDetailsStore(
    this._boardGameGeekService,
    this._boardGamesStore,
    this._analyticsService,
  );

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

  Future<void> captureLinkAnalytics(String linkName) async {
    await _analyticsService.logEvent(
      name: Analytics.BoardGameDetailsLinks,
      parameters: {
        Analytics.BoardGameDetailsLinksName: linkName,
      },
    );
  }
}
