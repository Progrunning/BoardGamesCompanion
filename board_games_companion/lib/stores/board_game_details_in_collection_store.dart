import 'package:flutter/cupertino.dart';

import '../models/hive/board_game_details.dart';
import 'board_games_store.dart';

class BoardGameDetailsInCollectionStore extends ChangeNotifier {
  BoardGameDetailsInCollectionStore(
    this._boardGamesStore,
    this._boardGameDetails,
  );

  final BoardGamesStore _boardGamesStore;
  BoardGameDetails _boardGameDetails;

  bool get isInCollection {
    if ((_boardGamesStore?.filteredBoardGames?.isEmpty ?? true) || _boardGameDetails == null) {
      return false;
    }

    final boardGameInCollection = _boardGamesStore.filteredBoardGames.firstWhere(
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
