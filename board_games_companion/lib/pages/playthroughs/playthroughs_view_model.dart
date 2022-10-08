// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:board_games_companion/models/import_result.dart';
import 'package:board_games_companion/models/playthrough_details.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../common/analytics.dart';
import '../../models/bgg/bgg_plays_import_raport.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/player.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/playthrough_player.dart';
import '../../services/analytics_service.dart';
import '../../services/board_games_service.dart';
import '../../stores/players_store.dart';

part 'playthroughs_view_model.g.dart';

@injectable
class PlaythroughsViewModel = _PlaythroughsViewModel with _$PlaythroughsViewModel;

abstract class _PlaythroughsViewModel with Store {
  _PlaythroughsViewModel(
    this._playthroughsStore,
    this._playersStore,
    this._analyticsService,
    this._boardGamesService,
    this._userStore,
  );

  final PlayersStore _playersStore;
  final PlaythroughsStore _playthroughsStore;
  final AnalyticsService _analyticsService;
  final BoardGamesService _boardGamesService;
  final UserStore _userStore;

  List<PlaythroughPlayer>? _playthroughPlayers;
  List<PlaythroughPlayer>? get playthroughPlayers => _playthroughPlayers;

  BggPlaysImportRaport? bggPlaysImportRaport;

  @computed
  BoardGameDetails get boardGame => _playthroughsStore.boardGame;

  @computed
  bool get hasUser => _userStore.hasUser;

  @computed
  String? get userName => _userStore.userName;

  @action
  void setBoardGame(BoardGameDetails boardGame) {
    _playthroughsStore.setBoardGame(boardGame);
  }

  Future<void> importPlays(String username, String boardGameId) async {
    await _analyticsService.logEvent(
      name: Analytics.importBggPlays,
      parameters: <String, String>{Analytics.boardGameIdParameter: boardGameId},
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
      final bggPlayExists = _playthroughsStore.playthroughsDetails
          .any((PlaythroughDetails playthrough) => playthrough.bggPlayId == bggPlay.id);
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
          playerScores[player.id] = PlayerScore(player: player, score: playerScore);
        }
      }

      final newPlaythrough = await _playthroughsStore.createPlaythrough(
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
