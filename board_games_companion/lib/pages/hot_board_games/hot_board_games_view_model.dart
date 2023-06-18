// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/analytics.dart';
import '../../models/hive/board_game_details.dart';
import '../../services/analytics_service.dart';
import '../../services/board_games_geek_service.dart';
import '../../stores/board_games_store.dart';

part 'hot_board_games_view_model.g.dart';

@singleton
class HotBoardGamesViewModel = _HotBoardGamesViewModel with _$HotBoardGamesViewModel;

abstract class _HotBoardGamesViewModel with Store {
  _HotBoardGamesViewModel(
    this._boardGamesStore,
    this._boardGameGeekService,
    this._analyticsService,
  );

  final BoardGamesStore _boardGamesStore;
  final BoardGamesGeekService _boardGameGeekService;
  final AnalyticsService _analyticsService;

  int _refreshRetryCount = 0;

  @observable
  ObservableList<BoardGameDetails>? hotBoardGames;

  @observable
  ObservableFuture<void>? futureLoadHotBoardGames;

  @observable
  ObservableFuture<void>? futureSearchBoardGames;

  @observable
  String? searchPhrase;

  @computed
  bool get hasAnyHotBoardGames => hotBoardGames?.isNotEmpty ?? false;

  @computed
  bool get isSearchPhraseEmpty => searchPhrase.isNullOrBlank;

  @action
  void loadHotBoardGames() =>
      futureLoadHotBoardGames = ObservableFuture<void>(_loadHotBoardGames());

  @action
  void setSearchPhrase(String? searchPhrase) => this.searchPhrase = searchPhrase;

  BoardGameDetails? getHotBoardGameDetails(String boardGameId) =>
      _boardGamesStore.allBoardGamesMap[boardGameId];

  void trackViewHotBoardGame(BoardGameDetails boardGame) {
    _analyticsService.logEvent(
      name: Analytics.viewHotBoardGame,
      parameters: <String, String?>{
        Analytics.boardGameIdParameter: boardGame.id,
        Analytics.boardGameNameParameter: boardGame.name,
      },
    );
  }

  void refresh() => _refreshRetryCount++;

  Future<void> _loadHotBoardGames() async {
    try {
      hotBoardGames =
          ObservableList.of(await _boardGameGeekService.getHot(retryCount: _refreshRetryCount));
      // MK Add hot board games to all of the games cached on the device if they are not there
      if (hotBoardGames != null) {
        for (final hotBoardGame in hotBoardGames!) {
          if (!_boardGamesStore.allBoardGamesMap.containsKey(hotBoardGame.id)) {
            await _boardGamesStore.addOrUpdateBoardGame(hotBoardGame);
          }
        }
      }

      _refreshRetryCount = 0;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
