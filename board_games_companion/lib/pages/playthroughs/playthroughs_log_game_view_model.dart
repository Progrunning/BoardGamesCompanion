import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../common/analytics.dart';
import '../../mixins/board_game_aware_mixin.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/playthrough_player.dart';
import '../../services/analytics_service.dart';
import '../../stores/playthrough_statistics_store.dart';
import '../../stores/playthroughs_store.dart';
import '../players/players_view_model.dart';
import 'playthroughs_log_game_page.dart';

@injectable
class PlaythroughsLogGameViewModel with ChangeNotifier, BoardGameAware {
  PlaythroughsLogGameViewModel(
    this._playersStore,
    this.playthroughsStore,
    this._analyticsService,
    this.playthroughStatisticsStore,
  );

  final PlayersViewModel _playersStore;
  final PlaythroughsStore playthroughsStore;
  final AnalyticsService _analyticsService;
  final PlaythroughStatisticsStore playthroughStatisticsStore;

  List<PlaythroughPlayer>? _playthroughPlayers;
  List<PlaythroughPlayer>? get playthroughPlayers => _playthroughPlayers;

  List<PlaythroughPlayer> get selectedPlaythroughPlayers =>
      playthroughPlayers!.where((player) => player.isChecked).toList();

  final Map<String, PlayerScore> _playerScores = {};
  Map<String, PlayerScore> get playerScores => _playerScores;

  Future<List<PlaythroughPlayer>> loadPlaythroughPlayers() async {
    final players = await _playersStore.loadPlayers();

    _playthroughPlayers = players
        .map(
          (p) => PlaythroughPlayer(p),
        )
        .toList();

    return _playthroughPlayers ?? <PlaythroughPlayer>[];
  }

  DateTime playthroughDate = DateTime.now();

  PlaythroughStartTime playthroughStartTime = PlaythroughStartTime.now;

  Duration playthroughDuration = const Duration();

  int _logGameStep = 0;
  int get logGameStep => _logGameStep;

  set logGameStep(int value) {
    if (_logGameStep != value) {
      _logGameStep = value;
      notifyListeners();
    }
  }

  bool get anyPlayerSelected => playthroughPlayers!.any((player) => player.isChecked);

  @override
  void setBoardGame(BoardGameDetails boardGame) {
    super.setBoardGame(boardGame);
    playthroughsStore.setBoardGame(boardGame);
    playthroughStatisticsStore.setBoardGame(boardGame);
  }

  Future<Playthrough?> createPlaythrough(String boardGameId) async {
    final Playthrough? newPlaythrough = await playthroughsStore.createPlaythrough(
      boardGameId,
      selectedPlaythroughPlayers,
      playerScores,
      playthroughStartTime == PlaythroughStartTime.now ? DateTime.now() : playthroughDate,
      playthroughStartTime == PlaythroughStartTime.inThePast ? playthroughDuration : null,
    );

    await _analyticsService.logEvent(
      name: Analytics.LogPlaythrough,
      parameters: <String, String>{
        Analytics.BoardGameIdParameter: boardGameId,
        Analytics.LogPlaythroughNumberOfPlayers: selectedPlaythroughPlayers.length.toString(),
        Analytics.LogPlaythroughStarTime: playthroughStartTime.toString(),
        Analytics.LogPlaythroughDuration: playthroughDuration.toString(),
      },
    );

    logGameStep = 0;
    playthroughDate = DateTime.now();
    playthroughStartTime = PlaythroughStartTime.now;
    playthroughDuration = const Duration();
    playerScores.clear();

    await loadPlaythroughPlayers();

    return newPlaythrough;
  }

  void selectPlayer(PlaythroughPlayer playthroughPlayer, String boardGameId) {
    final playerScore = Score(
      id: const Uuid().v4(),
      playerId: playthroughPlayer.player.id,
      boardGameId: boardGameId,
    );

    playthroughPlayer.isChecked = true;
    playerScores[playthroughPlayer.player.id] = PlayerScore(playthroughPlayer.player, playerScore);
  }

  void deselectPlayer(PlaythroughPlayer playthroughPlayer) {
    playthroughPlayer.isChecked = false;
    if (playerScores.containsKey(playthroughPlayer.player.id)) {
      playerScores.remove(playthroughPlayer.player.id);
    }
  }
}
