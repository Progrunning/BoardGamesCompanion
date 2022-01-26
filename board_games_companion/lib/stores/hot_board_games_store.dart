import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import '../models/board_game.dart';
import '../services/board_games_geek_service.dart';

class HotBoardGamesStore with ChangeNotifier {
  HotBoardGamesStore(this._boardGameGeekService);

  final BoardGamesGeekService _boardGameGeekService;

  int _refreshRetryCount = 0;

  List<BoardGame>? _hotBoardGames;

  List<BoardGame>? get hotBoardGames => _hotBoardGames;

  Future<List<BoardGame>> load() async {
    if (_hotBoardGames != null) {
      return _hotBoardGames!;
    }

    try {
      _hotBoardGames = await _boardGameGeekService.getHot(retryCount: _refreshRetryCount);
      _refreshRetryCount = 0;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return _hotBoardGames ?? <BoardGame>[];
  }

  void refresh() {
    _refreshRetryCount++;
    notifyListeners();
  }
}
