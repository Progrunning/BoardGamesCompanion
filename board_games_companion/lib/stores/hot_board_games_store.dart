import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class HotBoardGamesStore with ChangeNotifier {
  BoardGamesGeekService _boardGameGeekService;

  List<BoardGame> _hotBoardGames;

  List<BoardGame> get hotBoardGames => _hotBoardGames;

  HotBoardGamesStore(this._boardGameGeekService);

  Future<List<BoardGame>> load() async {
    if (_hotBoardGames != null) {
      return _hotBoardGames;
    }

    try {
      _hotBoardGames = await _boardGameGeekService.retrieveHot();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return _hotBoardGames ?? List<BoardGame>();
  }

  Future refresh() async {
    notifyListeners();
  }
}
