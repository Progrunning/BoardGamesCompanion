import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:flutter/cupertino.dart';

class BoardGameDetailsInCollectionStore extends ChangeNotifier {
  final BoardGamesStore _boardGamesStore;
  
  BoardGameDetails _boardGameDetails;

  BoardGameDetailsInCollectionStore(
    this._boardGamesStore,
    this._boardGameDetails,
  );

  bool get isInCollection {
    if ((_boardGamesStore?.boardGames?.isEmpty ?? true) ||
        _boardGameDetails == null) {
      return false;
    }

    final boardGameInCollection = _boardGamesStore.boardGames.firstWhere(
      (boardGameDetails) => boardGameDetails.id == _boardGameDetails.id,
      orElse: () => null,
    );
    return boardGameInCollection != null;
  }

  void updateIsInCollectionStatus([BoardGameDetails boardGameDetails]) {
    if (boardGameDetails != null) {
      _boardGameDetails = boardGameDetails;
    }
    notifyListeners();
  }
}