import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../common/analytics.dart';
import '../common/enums/collection_type.dart';
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

  BoardGameDetails? _boardGameDetails;

  BoardGameDetails? get boardGameDetails => _boardGameDetails;

  Future<BoardGameDetails?> loadBoardGameDetails(String boardGameId) async {
    try {
      // TODO MK Think about retrieving the data from Hive and updating with the HTTP call
      //         Alternatively set cache expiration (~a week?) and then retrieve data to update
      final boardGameDetails = await _boardGameGeekService.getDetails(boardGameId);
      if (boardGameDetails == null) {
        return _boardGameDetails!;
      }
      for (final boardGameExpansion in boardGameDetails.expansions) {
        final boardGameExpansionDetails = _boardGamesStore.allboardGames.firstWhereOrNull(
          (boardGame) => boardGame.id == boardGameExpansion.id,
        );

        if (boardGameExpansionDetails != null &&
            boardGameExpansionDetails.isExpansion! &&
            boardGameExpansionDetails.isOwned) {
          boardGameExpansion.isInCollection = true;
        }
      }

      final existingBoardGameDetails = _boardGamesStore.retrieveBoardGame(boardGameId);
      if (existingBoardGameDetails != null) {
        boardGameDetails.isFriends = existingBoardGameDetails.isFriends;
        boardGameDetails.isOnWishlist = existingBoardGameDetails.isOnWishlist;
        boardGameDetails.isOwned = existingBoardGameDetails.isOwned;
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

  Future<void> toggleCollection(CollectionType collectionType) async {
    switch (collectionType) {
      case CollectionType.Owned:
        _boardGameDetails!.isOwned = !_boardGameDetails!.isOwned;
        if (_boardGameDetails!.isOwned) {
          _boardGameDetails!.isOnWishlist = false;
          _boardGameDetails!.isFriends = false;
        }
        break;
      case CollectionType.Friends:
        if (_boardGameDetails!.isOwned) {
          _boardGameDetails!.isOwned = false;
        }
        _boardGameDetails!.isFriends = !_boardGameDetails!.isFriends;
        break;
      case CollectionType.Wishlist:
        if (_boardGameDetails!.isOwned) {
          _boardGameDetails!.isOwned = false;
        }
        _boardGameDetails!.isOnWishlist = !_boardGameDetails!.isOnWishlist;
        break;
    }

    await _boardGamesStore.updateDetails(_boardGameDetails!);
  }
}
