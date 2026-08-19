// ignore_for_file: library_private_types_in_public_api

import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/hive/player.dart';
import '../../models/player_overall_statistics.dart';
import '../../services/player_statistics_service.dart';
import '../../stores/board_games_store.dart';
import '../../stores/players_store.dart';
import '../../stores/playthroughs_store.dart';
import '../../stores/scores_store.dart';
import 'player_statistics_visual_state.dart';

part 'player_statistics_view_model.g.dart';

@injectable
class PlayerStatisticsViewModel = _PlayerStatisticsViewModel with _$PlayerStatisticsViewModel;

abstract class _PlayerStatisticsViewModel with Store {
  _PlayerStatisticsViewModel(
    this._playerStatisticsService,
    this._playersStore,
    this._playthroughsStore,
    this._scoresStore,
    this._boardGamesStore,
  );

  static const int gamesCollapsedCount = 5;

  final PlayerStatisticsService _playerStatisticsService;
  final PlayersStore _playersStore;
  final PlaythroughsStore _playthroughsStore;
  final ScoresStore _scoresStore;
  final BoardGamesStore _boardGamesStore;

  @observable
  Player? player;

  @observable
  PlayerStatisticsVisualState visualState = const PlayerStatisticsVisualState.loading();

  @observable
  PlayerOverallStatistics? statistics;

  @observable
  bool isGamesListExpanded = false;

  @observable
  ObservableFuture<void>? futureLoadStatistics;

  @computed
  bool get isPlayerDeleted => player?.isDeleted ?? false;

  @computed
  List<GamePlaysCount> get displayedGames => statistics == null
      ? <GamePlaysCount>[]
      : (isGamesListExpanded
          ? statistics!.gamesByPlays
          : statistics!.gamesByPlays.take(gamesCollapsedCount).toList());

  @computed
  bool get canExpandGames => (statistics?.gamesByPlays.length ?? 0) > gamesCollapsedCount;

  @action
  void setPlayer(Player? player) {
    this.player = player;
  }

  @action
  void toggleGamesExpansion() => isGamesListExpanded = !isGamesListExpanded;

  @action
  void loadPlayerStatistics() =>
      futureLoadStatistics = ObservableFuture<void>(_loadPlayerStatistics());

  Future<void> _loadPlayerStatistics() async {
    try {
      visualState = const PlayerStatisticsVisualState.loading();

      await Future.wait([
        _playersStore.loadPlayers(),
        _playthroughsStore.loadPlaythroughs(),
        _scoresStore.loadScores(),
        _boardGamesStore.loadBoardGames(),
      ]);

      player = _playersStore.players.firstWhereOrNull((p) => p.id == player?.id) ?? player;

      final stats = _playerStatisticsService.retrievePlayerStatistics(player!.id);
      statistics = stats;
      visualState = stats.hasNoPlays
          ? const PlayerStatisticsVisualState.empty()
          : PlayerStatisticsVisualState.loaded(stats);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      // Fail closed to the empty state rather than leaving the page stuck on a spinner.
      visualState = const PlayerStatisticsVisualState.empty();
    }
  }
}
