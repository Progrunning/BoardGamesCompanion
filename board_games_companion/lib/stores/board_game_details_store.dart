import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class BoardGameDetailsStore with ChangeNotifier {
  final BoardGamesGeekService _boardGameGeekService;

  LoadDataState _loadDataState;
  LoadDataState get loadDataState => _loadDataState;

  BoardGameDetails _boardGameDetails;
  BoardGameDetails get boardGameDetails => _boardGameDetails;

  BoardGameDetailsStore(this._boardGameGeekService);

  Future<void> loadBoardGameDetails(String boardGameId) async {
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

    try {
      final boardGameDetails =
          await _boardGameGeekService.retrieveDetails(boardGameId);
      if (boardGameDetails != null) {
        _boardGameDetails = boardGameDetails;
        _loadDataState = LoadDataState.Loaded;
      }
    } catch (e, stack) {
      _loadDataState = LoadDataState.Error;
      Crashlytics.instance.recordError(e, stack);
    }
    
    notifyListeners();
  }
}
