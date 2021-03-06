import 'package:basics/basics.dart';
import 'package:board_games_companion/models/import_result.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../common/analytics.dart';
import '../../mixins/board_game_aware_mixin.dart';
import '../../models/bgg/bgg_plays_import_raport.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/player.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/playthrough_player.dart';
import '../../services/analytics_service.dart';
import '../../services/board_games_service.dart';
import '../../stores/players_store.dart';
import '../../stores/playthrough_statistics_store.dart';
import '../../stores/playthroughs_store.dart';
import 'playthroughs_log_game_page.dart';

@injectable
class PlaythroughsViewModel with ChangeNotifier, BoardGameAware {
  PlaythroughsViewModel(
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
  BggPlaysImportRaport? bggPlaysImportRaport;

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
    await _analyticsService.logEvent(
      name: Analytics.ImportBggPlays,
      parameters: <String, String>{Analytics.BoardGameIdParameter: boardGameId},
    );

    final bggPlaysImportResult = await _boardGamesService.importPlays(username, boardGameId);
    bggPlaysImportRaport = BggPlaysImportRaport()
      ..playsToImportTotal = bggPlaysImportResult.playsToImportTotal
      ..playsFailedToImportTotal = bggPlaysImportResult.playsFailedToImportTotal
      ..errors = bggPlaysImportResult.errors ?? []
      ..createdPlayers = [];

    if (!bggPlaysImportResult.isSuccess && !bggPlaysImportResult.isPartialSuccess) {
      return;
    }

    if (bggPlaysImportResult.data?.isEmpty ?? true) {
      if (bggPlaysImportResult.playsToImportTotal == 0) {
        bggPlaysImportRaport!.errors.add(ImportError('No plays to import'));
      }

      return;
    }

    // TODO Consider using isolates to parse and iterate over the results
    for (final bggPlay in bggPlaysImportResult.data!) {
      final bggPlayExists = playthroughsStore.playthroughs
              ?.any((Playthrough playthrough) => playthrough.bggPlayId == bggPlay.id) ??
          false;
      if (bggPlayExists) {
        continue;
      }

      // TODO MK Players should be loaded by the time this method is called.
      //         This is to fix a bug in production that casues duplicate players to be created because players are not populated.
      await _playersStore.loadPlayers();

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

        final bool newPlayer =
            _playersStore.players.firstWhereOrNull((p) => p.id == playerId) != null;
        final Player player = Player(id: playerId)
          ..name = bggPlayer.playerName
          ..bggName = bggPlayer.playerBggName;

        if (await _playersStore.createOrUpdatePlayer(player)) {
          if (!newPlayer &&
              ((player.name?.isBlank ?? false) || (player.bggName?.isBlank ?? false))) {
            bggPlaysImportRaport!.createdPlayers.add(player.name ?? player.bggName ?? '');
          }

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
        bggPlaysImportRaport!.errors.add(ImportError('Failed to import a play [${bggPlay.id}]'));
      }
    }
  }
}
