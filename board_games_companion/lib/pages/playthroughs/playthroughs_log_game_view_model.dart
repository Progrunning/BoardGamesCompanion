import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:collection/collection.dart' show IterableExtension;
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
import '../../services/board_games_service.dart';
import '../../stores/playthrough_statistics_store.dart';
import '../../stores/playthroughs_store.dart';
import 'playthroughs_log_game_page.dart';

@injectable
class PlaythroughsLogGameViewModel with ChangeNotifier, BoardGameAware {
  PlaythroughsLogGameViewModel(
    this.playthroughsStore,
    this.playthroughStatisticsStore,
    this._playersStore,
    this._analyticsService,
    this._boardGamesService,
  );

  final PlayersStore _playersStore;
  final PlaythroughsStore playthroughsStore;
  final AnalyticsService _analyticsService;
  final PlaythroughStatisticsStore playthroughStatisticsStore;
  final BoardGamesService _boardGamesService;

  List<PlaythroughPlayer>? _playthroughPlayers;
  List<PlaythroughPlayer>? get playthroughPlayers => _playthroughPlayers;

  List<PlaythroughPlayer> get selectedPlaythroughPlayers =>
      playthroughPlayers!.where((player) => player.isChecked).toList();

  final Map<String, PlayerScore> _playerScores = {};
  Map<String, PlayerScore> get playerScores => _playerScores;

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

  Future<List<PlaythroughPlayer>> loadPlaythroughPlayers() async {
    final players = await _playersStore.loadPlayers();

    _playthroughPlayers = players
        .map(
          (p) => PlaythroughPlayer(p),
        )
        .toList();

    return _playthroughPlayers ?? <PlaythroughPlayer>[];
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

  Future<void> importPlays(String username, String boardGameId) async {
    // TODO Import multiple pages
    final bggPlaysImportResult = await _boardGamesService.importPlays(username, boardGameId);
    if (!bggPlaysImportResult.isSuccess) {
      // TODO Handle import failure
      return;
    }

    if (bggPlaysImportResult.data?.isEmpty ?? true) {
      // TODO Handle import failure
      return;
    }

    // TODO Consider using isolates to parse and iterate over the results
    for (final bggPlay in bggPlaysImportResult.data!) {
      if (bggPlay.playDate == null ||
          (playthroughsStore.playthroughs
                  ?.any((Playthrough playthrough) => playthrough.bggPlayId == bggPlay.id) ??
              false)) {
        continue;
      }

      final List<PlaythroughPlayer> playthroughPlayers = [];
      final Map<String, PlayerScore> playerScores = {};
      for (final bggPlayer in bggPlay.players) {
        String playerId;
        if (bggPlayer.playerBggUserId == null) {
          playerId =
              _playersStore.players.firstWhereOrNull((p) => p.name == bggPlayer.playerName)?.id ??
                  const Uuid().v4();
        } else {
          playerId = bggPlayer.playerBggUserId.toString();
        }
        final Player player = Player(id: playerId)
          ..name = bggPlayer.playerName
          ..bggName = bggPlayer.playerBggName;

        if (await _playersStore.createOrUpdatePlayer(player)) {
          playthroughPlayers.add(PlaythroughPlayer(player));
          final Score playerScore = Score(
            id: const Uuid().v4(),
            playerId: player.id,
            boardGameId: boardGameId,
            value: bggPlayer.playerScore.toString(),
          );
          playerScores[player.id] = PlayerScore(player, playerScore);
        }
      }

      final newPlaythrough = await playthroughsStore.createPlaythrough(
        bggPlay.boardGameId,
        playthroughPlayers,
        playerScores,
        bggPlay.playDate!,
        Duration(minutes: bggPlay.playTimeInMinutes ?? 0),
        bggPlayId: bggPlay.id,
      );

      if (newPlaythrough == null) {
        // TODO Handle error
      }
    }
  }
}
