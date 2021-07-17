import 'package:board_games_companion/common/enums/collection_flag.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../common/analytics.dart';
import '../models/hive/board_game_details.dart';
import '../services/analytics_service.dart';
import '../services/board_games_geek_service.dart';
import 'board_games_store.dart';

class BoardGameDetailsStore with ChangeNotifier {
  BoardGameDetailsStore(
    this._boardGameGeekService,
    this._boardGamesStore,
    this._analyticsService,
  );

  final BoardGamesGeekService _boardGameGeekService;
  final BoardGamesStore _boardGamesStore;
  final AnalyticsService _analyticsService;

  BoardGameDetails _boardGameDetails;

  BoardGameDetails get boardGameDetails => _boardGameDetails;

  Future<BoardGameDetails> loadBoardGameDetails(String boardGameId) async {
    try {
      // TODO MK Think about retrieving the data from Hive and updating with the HTTP call
      //         Alternatively set cache expiration (~a week?) and then retrieve data to update
      final boardGameDetails = await _boardGameGeekService.retrieveDetails(boardGameId);
      if (boardGameDetails == null) {
        return _boardGameDetails;
      }
      for (final boardGameExpansion in boardGameDetails.expansions) {
        final boardGameExpansionDetails = _boardGamesStore.allboardGames.firstWhere(
          (boardGame) => boardGame.id == boardGameExpansion.id,
          orElse: () => null,
        );

        if (boardGameExpansionDetails != null) {
          boardGameExpansion.isInCollection = true;
        }
      }

      final existingBoardGameDetails = _boardGamesStore.retrieveBoardGame(boardGameId);
      if (existingBoardGameDetails != null) {
        boardGameDetails.isPlayed = existingBoardGameDetails.isPlayed;
        boardGameDetails.isOnWishlist = existingBoardGameDetails.isOnWishlist;
        boardGameDetails.isInCollection = existingBoardGameDetails.isInCollection;
      }

      await _boardGamesStore.updateDetails(boardGameDetails);

      _boardGameDetails = boardGameDetails;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    notifyListeners();

    return _boardGameDetails;
  }

  Future<void> captureLinkAnalytics(String linkName) async {
    await _analyticsService.logEvent(
      name: Analytics.BoardGameDetailsLinks,
      parameters: <String, String>{
        Analytics.BoardGameDetailsLinksName: linkName,
      },
    );
  }

  Future<void> toggleCollectionFlag(CollectionFlag collectionFlag) async {
    switch (collectionFlag) {
      case CollectionFlag.Colleciton:
        _boardGameDetails.isInCollection = !_boardGameDetails.isInCollection;
        if (_boardGameDetails.isInCollection) {
          _boardGameDetails.isOnWishlist = false;
          _boardGameDetails.isPlayed = false;
        }
        break;
      case CollectionFlag.Played:
        _boardGameDetails.isPlayed = !_boardGameDetails.isPlayed;
        break;
      case CollectionFlag.Wishlist:
        _boardGameDetails.isOnWishlist = !_boardGameDetails.isOnWishlist;
        break;
    }

    await _boardGamesStore.updateDetails(_boardGameDetails);
  }
}
