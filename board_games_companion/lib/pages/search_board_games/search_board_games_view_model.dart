// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/analytics.dart';
import '../../models/board_game.dart';
import '../../services/analytics_service.dart';
import '../../services/board_games_geek_service.dart';

part 'search_board_games_view_model.g.dart';

@singleton
class SearchBoardGamesViewModel = _SearchBoardGamesViewModel with _$SearchBoardGamesViewModel;

abstract class _SearchBoardGamesViewModel with Store {
  _SearchBoardGamesViewModel(
    this._boardGamesStore,
    this._boardGameGeekService,
    this._analyticsService,
  );

  final BoardGamesStore _boardGamesStore;
  final BoardGamesGeekService _boardGameGeekService;
  final AnalyticsService _analyticsService;

  int _refreshRetryCount = 0;

  @observable
  ObservableList<BoardGame>? hotBoardGames;

  @observable
  ObservableFuture<void>? futureLoadHotBoardGames;

  @computed
  bool get hasAnyHotBoardGames => hotBoardGames?.isNotEmpty ?? false;

  void loadHotBoardGames() =>
      futureLoadHotBoardGames = ObservableFuture<void>(_loadHotBoardGames());

  Future<void> _loadHotBoardGames() async {
    try {
      hotBoardGames =
          ObservableList.of(await _boardGameGeekService.getHot(retryCount: _refreshRetryCount));
      _refreshRetryCount = 0;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  BoardGameDetails? getHotBoardGameDetails(String boardGameId) =>
      _boardGamesStore.allBoardGamesMap[boardGameId];

  void trackViewHotBoardGame(BoardGame boardGame) {
    _analyticsService.logEvent(
      name: Analytics.viewHotBoardGame,
      parameters: <String, String?>{
        Analytics.boardGameIdParameter: boardGame.id,
        Analytics.boardGameNameParameter: boardGame.name,
      },
    );
  }

  void refresh() => _refreshRetryCount++;
}
