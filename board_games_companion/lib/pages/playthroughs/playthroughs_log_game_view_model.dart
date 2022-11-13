// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../common/analytics.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/player.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/playthrough_details.dart';
import '../../models/playthrough_player.dart';
import '../../services/analytics_service.dart';
import 'playthroughs_log_game_page.dart';

part 'playthroughs_log_game_view_model.g.dart';

@injectable
class PlaythroughsLogGameViewModel = _PlaythroughsLogGameViewModel
    with _$PlaythroughsLogGameViewModel;

abstract class _PlaythroughsLogGameViewModel with Store {
  _PlaythroughsLogGameViewModel(
    this._playersStore,
    this._playthroughsStore,
    this._analyticsService,
  );

  final PlayersStore _playersStore;
  final PlaythroughsStore _playthroughsStore;
  final AnalyticsService _analyticsService;

  @observable
  ObservableMap<String, PlayerScore> playerScores = ObservableMap.of({});

  @observable
  DateTime playthroughDate = DateTime.now();

  @observable
  Duration playthroughDuration = const Duration();

  @observable
  PlaythroughStartTime playthroughStartTime = PlaythroughStartTime.now;

  @observable
  int logGameStep = 0;

  @observable
  ObservableFuture<void>? futureLoadPlaythroughPlayers;

  @observable
  ObservableList<PlaythroughPlayer> playthroughPlayers = ObservableList.of([]);

  @computed
  BoardGameDetails get boardGame => _playthroughsStore.boardGame;

  @computed
  bool get anyPlayerSelected => playthroughPlayers.any((player) => player.isChecked);

  @computed
  List<PlaythroughPlayer> get _selectedPlaythroughPlayers =>
      playthroughPlayers.where((player) => player.isChecked).toList();

  @action
  void setLogGameStep(int value) => logGameStep = value;

  @action
  void selectPlayer(PlaythroughPlayer playthroughPlayer) {
    final indexOfPlaythroughPlayer =
        playthroughPlayers.indexWhere((pp) => pp.player.id == playthroughPlayer.player.id);
    playthroughPlayers[indexOfPlaythroughPlayer] = playthroughPlayer.copyWith(isChecked: true);
    playthroughPlayers = ObservableList.of(playthroughPlayers);
    playerScores[playthroughPlayer.player.id] = PlayerScore(
      player: playthroughPlayer.player,
      score: Score(
        id: const Uuid().v4(),
        playerId: playthroughPlayer.player.id,
        boardGameId: _playthroughsStore.boardGame.id,
      ),
    );
  }

  @action
  void deselectPlayer(PlaythroughPlayer playthroughPlayer) {
    final indexOfPlaythroughPlayer =
        playthroughPlayers.indexWhere((pp) => pp.player.id == playthroughPlayer.player.id);
    playthroughPlayers[indexOfPlaythroughPlayer] = playthroughPlayer.copyWith(isChecked: false);
    if (playerScores.containsKey(playthroughPlayer.player.id)) {
      playerScores.remove(playthroughPlayer.player.id);
    }
  }

  @action
  void loadPlaythroughPlayers() =>
      futureLoadPlaythroughPlayers = ObservableFuture<void>(_loadPlaythroughPlayers());

  @action
  Future<PlaythroughDetails?> createPlaythrough(String boardGameId) async {
    final PlaythroughDetails? newPlaythrough = await _playthroughsStore.createPlaythrough(
      boardGameId,
      _selectedPlaythroughPlayers,
      playerScores,
      playthroughStartTime == PlaythroughStartTime.now ? DateTime.now() : playthroughDate,
      playthroughStartTime == PlaythroughStartTime.inThePast ? playthroughDuration : null,
    );

    await _analyticsService.logEvent(
      name: Analytics.logPlaythrough,
      parameters: <String, String>{
        Analytics.boardGameIdParameter: boardGameId,
        Analytics.logPlaythroughNumberOfPlayers: _selectedPlaythroughPlayers.length.toString(),
        Analytics.logPlaythroughStarTime: playthroughStartTime.toString(),
        Analytics.logPlaythroughDuration: playthroughDuration.toString(),
      },
    );

    logGameStep = 0;
    playthroughDate = DateTime.now();
    playthroughStartTime = PlaythroughStartTime.now;
    playthroughDuration = const Duration();
    playerScores.clear();

    loadPlaythroughPlayers();

    return newPlaythrough;
  }

  @action
  void updatePlayerScore(PlayerScore playerScore, int newScore) {
    if (playerScore.score.valueInt == newScore || playerScore.player == null) {
      return;
    }

    final updatedPlayerScore =
        playerScore.copyWith(score: playerScore.score.copyWith(value: newScore.toString()));
    playerScores[playerScore.player!.id] = updatedPlayerScore;
  }

  Future<void> _loadPlaythroughPlayers() async {
    await _playersStore.loadPlayers();
    playthroughPlayers = ObservableList.of(
      _playersStore.players.map((Player player) => PlaythroughPlayer(player: player)).toList(),
    );
  }
}
