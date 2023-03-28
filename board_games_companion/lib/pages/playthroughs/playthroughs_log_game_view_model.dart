// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/models/hive/no_score_game_result.dart';
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/analytics.dart';
import '../../models/hive/player.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_details.dart';
import '../../services/analytics_service.dart';
import 'playthrough_timeline.dart';
import 'playthroughs_log_game_players.dart';

part 'playthroughs_log_game_view_model.g.dart';

@injectable
class PlaythroughsLogGameViewModel = _PlaythroughsLogGameViewModel
    with _$PlaythroughsLogGameViewModel;

abstract class _PlaythroughsLogGameViewModel with Store {
  _PlaythroughsLogGameViewModel(
    this._playersStore,
    this._gamePlaythroughsStore,
    this._analyticsService,
  );

  final PlayersStore _playersStore;
  final GamePlaythroughsDetailsStore _gamePlaythroughsStore;
  final AnalyticsService _analyticsService;

  @observable
  ObservableMap<String, PlayerScore> playerScores = ObservableMap.of({});

  @observable
  DateTime playthroughDate = DateTime.now();

  @observable
  Duration playthroughDuration = const Duration();

  @observable
  ObservableFuture<void>? futureLoadPlayers;

  @observable
  CooperativeGameResult? cooperativeGameResult;

  @observable
  PlaythroughTimeline playthroughTimeline = const PlaythroughTimeline.now();

  @computed
  ObservableList<Player> get players => _playersStore.players;

  @observable
  PlaythroughsLogGamePlayers playersState = const PlaythroughsLogGamePlayers.loading();

  @computed
  String get boardGameId => _gamePlaythroughsStore.boardGameId;

  @computed
  GameClassification get gameClassification => _gamePlaythroughsStore.gameClassification;

  @action
  void loadPlayers() => futureLoadPlayers = ObservableFuture<void>(_loadPlayers());

  @action
  Future<PlaythroughDetails?> createPlaythrough() async {
    return playersState.maybeWhen(
      playersSelected: (selectedPlayers) async {
        final PlaythroughDetails? newPlaythrough = await _gamePlaythroughsStore.createPlaythrough(
          boardGameId,
          selectedPlayers,
          playerScores,
          playthroughTimeline.when(now: () => DateTime.now(), inThePast: () => playthroughDate),
          playthroughTimeline.when(now: () => null, inThePast: () => playthroughDuration),
        );

        await _analyticsService.logEvent(
          name: Analytics.logPlaythrough,
          parameters: <String, String>{
            Analytics.boardGameIdParameter: boardGameId,
            Analytics.logPlaythroughNumberOfPlayers: selectedPlayers.length.toString(),
            Analytics.logPlaythroughStarTime: playthroughTimeline.when(
              now: () => Analytics.playthroughTimelineInThePast,
              inThePast: () => Analytics.playthroughTimelineInThePast,
            ),
            Analytics.logPlaythroughDuration: playthroughDuration.toString(),
          },
        );

        // MK Reset the log screen
        playthroughDate = DateTime.now();
        playthroughDuration = const Duration();

        if (_playersStore.players.isEmpty) {
          playersState = const PlaythroughsLogGamePlayers.noPlayers();
        } else {
          playersState = const PlaythroughsLogGamePlayers.noPlayersSelected();
        }

        return newPlaythrough;
      },
      orElse: () => null,
    );
  }

  @action
  void setSelectedPlayers(List<Player> selectedPlayers) =>
      playersState = PlaythroughsLogGamePlayers.playersSelected(players: selectedPlayers);

  @action
  void updatePlayerScore(PlayerScore playerScore, int newScore) {
    if (playerScore.score.valueInt == newScore || playerScore.player == null) {
      return;
    }

    final updatedPlayerScore =
        playerScore.copyWith(score: playerScore.score.copyWith(value: newScore.toString()));
    playerScores[playerScore.player!.id] = updatedPlayerScore;
  }

  @action
  void updateCooperativeGameResult(CooperativeGameResult cooperativeGameResult) {
    this.cooperativeGameResult = cooperativeGameResult;

    final updatedPlayerScores = <String, PlayerScore>{};
    for (final playerScore in playerScores.values) {
      if (playerScore.player == null) {
        continue;
      }

      updatedPlayerScores[playerScore.player!.id] = playerScore.copyWith(
        score: playerScore.score.copyWith(
          noScoreGameResult: NoScoreGameResult(
            cooperativeGameResult: cooperativeGameResult,
          ),
        ),
      );
    }

    playerScores = updatedPlayerScores.asObservable();
  }

  @action
  void setPlaythroughTimeline(PlaythroughTimeline playthroughTimeline) =>
      this.playthroughTimeline = playthroughTimeline;

  Future<void> _loadPlayers() async {
    playersState = const PlaythroughsLogGamePlayers.loading();

    await _playersStore.loadPlayers();

    if (_playersStore.players.isEmpty) {
      playersState = const PlaythroughsLogGamePlayers.noPlayers();
      return;
    }

    playersState = const PlaythroughsLogGamePlayers.noPlayersSelected();
  }
}
