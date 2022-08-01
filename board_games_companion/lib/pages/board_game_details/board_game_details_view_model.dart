import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../common/analytics.dart';
import '../../common/enums/collection_type.dart';
import '../../models/hive/board_game_details.dart';
import '../../services/analytics_service.dart';
import '../../stores/board_games_store.dart';

class BoardGameDetailsViewModel with ChangeNotifier {
  BoardGameDetailsViewModel(
    this._boardGamesStore,
    this._analyticsService,
  );

  final BoardGamesStore _boardGamesStore;
  final AnalyticsService _analyticsService;

  BoardGameDetails? _boardGameDetails;
  BoardGameDetails? get boardGameDetails => _boardGameDetails;

  Future<BoardGameDetails?> loadBoardGameDetails(String boardGameId) async {
    try {
      final refreshedBoardGameDetails = await _boardGamesStore.refreshBoardGameDetails(boardGameId);
      _boardGameDetails = refreshedBoardGameDetails;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    notifyListeners();

    return _boardGameDetails;
  }

  Future<void> captureLinkAnalytics(String linkName) async {
    await _analyticsService.logEvent(
      name: Analytics.boardGameDetailsLinks,
      parameters: <String, String>{
        Analytics.boardGameDetailsLinksName: linkName,
      },
    );
  }

  Future<void> toggleCollection(CollectionType collectionType) async {
    switch (collectionType) {
      case CollectionType.owned:
        _boardGameDetails!.isOwned = !_boardGameDetails!.isOwned!;
        if (_boardGameDetails!.isOwned!) {
          _boardGameDetails!.isOnWishlist = false;
          _boardGameDetails!.isFriends = false;
        }
        break;
      case CollectionType.friends:
        if (_boardGameDetails!.isOwned!) {
          _boardGameDetails!.isOwned = false;
        }
        _boardGameDetails!.isFriends = !_boardGameDetails!.isFriends!;
        break;
      case CollectionType.wishlist:
        if (_boardGameDetails!.isOwned!) {
          _boardGameDetails!.isOwned = false;
        }
        _boardGameDetails!.isOnWishlist = !_boardGameDetails!.isOnWishlist!;
        break;
    }

    // ! MK If a game is an expansion and the main board game has been sync'd with BGG and lacks details then need to fetch details

    await _boardGamesStore.addOrUpdateBoardGame(_boardGameDetails!);
  }
}
