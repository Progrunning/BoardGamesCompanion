import 'package:board_games_companion/common/analytics.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/services/analytics_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../models/hive/playthrough.dart';
import '../../models/playthrough_player.dart';
import '../../stores/players_store.dart';
import '../../stores/playthroughs_store.dart';
import 'playthroughs_log_game_page.dart';

@injectable
class PlaythroughsLogGameViewModel with ChangeNotifier {
  PlaythroughsLogGameViewModel(this._playersStore, this._playthroughsStore, this._analyticsService);

  final PlayersStore _playersStore;
  final PlaythroughsStore _playthroughsStore;
  final AnalyticsService _analyticsService;

  List<PlaythroughPlayer>? _playthroughPlayers;
  List<PlaythroughPlayer>? get playthroughPlayers => _playthroughPlayers;

  List<PlaythroughPlayer> get selectedPlaythroughPlayers =>
      playthroughPlayers!.where((player) => player.isChecked).toList();

  final Map<String, PlayerScore> _playerScores = {};
  Map<String, PlayerScore> get playerScores => _playerScores;

  Future<List<PlaythroughPlayer>> loadPlaythroughPlayers() async {
    final players = await _playersStore.loadPlayers();

    _playthroughPlayers = players
        ?.map(
          (p) => PlaythroughPlayer(p),
        )
        ?.toList();

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

  Future<Playthrough> createPlaythrough(String boardGameId) async {
    final Playthrough newPlaythrough = await _playthroughsStore.createPlaythrough(
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
