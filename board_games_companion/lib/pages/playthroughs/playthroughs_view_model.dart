// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import '../../common/analytics.dart';
import '../../common/enums/game_family.dart';
import '../../extensions/bool_extensions.dart';
import '../../models/bgg/bgg_plays_import_raport.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/hive/player.dart';
import '../../models/hive/score.dart';
import '../../models/import_result.dart';
import '../../models/player_score.dart';
import '../../services/analytics_service.dart';
import '../../services/board_games_service.dart';
import '../../stores/game_playthroughs_details_store.dart';
import '../../stores/players_store.dart';
import '../../stores/user_store.dart';

part 'playthroughs_view_model.g.dart';

@injectable
class PlaythroughsViewModel = _PlaythroughsViewModel with _$PlaythroughsViewModel;

abstract class _PlaythroughsViewModel with Store {
  _PlaythroughsViewModel(
    this._gamePlaythroughsDetailsStore,
    this._playersStore,
    this._analyticsService,
    this._boardGamesService,
    this._userStore,
  );

  static const baseMelodiceUrl = 'https://melodice.org';
  static const melodicePlaylistUrl = '$baseMelodiceUrl/playlist';

  static const Map<int, Tuple2<String, String>> _screenViewByTabIndex = {
    0: Tuple2<String, String>('Statistics', 'PlaythroughStatistcsPage'),
    1: Tuple2<String, String>('History', 'PlaythroughsHistoryPage'),
    2: Tuple2<String, String>('Log Games', 'PlaythroughsLogGamePage'),
    3: Tuple2<String, String>('Settings', 'PlaythroughsGameSettingsPage'),
  };

  final PlayersStore _playersStore;
  final AnalyticsService _analyticsService;
  final BoardGamesService _boardGamesService;
  final UserStore _userStore;
  final GamePlaythroughsDetailsStore _gamePlaythroughsDetailsStore;

  late final BoardGameDetails _boardGameDetails;
  late String _boardGameImageHeroId;

  BggPlaysImportRaport? bggPlaysImportRaport;

  String get boardGameImageHeroId => _boardGameImageHeroId;

  @computed
  String get boardGameId => _boardGameDetails.id;

  @computed
  String get boardGameName => _boardGameDetails.name;

  @computed
  bool get isCreatedByUser => _boardGameDetails.isCreatedByUser;

  @computed
  bool get hasUser => _userStore.hasUser;

  @computed
  String? get userName => _userStore.userName;

  @computed
  bool get canImportGames => hasUser && !isCreatedByUser;

  @computed
  String get gamePlaylistUrl => '$melodicePlaylistUrl/$boardGameId';

  @computed
  GameFamily get gameFamily => _gamePlaythroughsDetailsStore.gameGameFamily;

  @action
  void setBoardGame(BoardGameDetails boardGame) {
    _boardGameDetails = boardGame;
    _gamePlaythroughsDetailsStore.setBoardGameId(boardGame.id);
  }

  void setBoardGameImageHeroId(String boardGameImageHeroId) =>
      _boardGameImageHeroId = boardGameImageHeroId;

  Future<void> importPlays(String username, String boardGameId) async {
    await _analyticsService.logEvent(
      name: Analytics.importBggPlays,
      parameters: <String, String>{Analytics.boardGameIdParameter: boardGameId},
    );

    final bggPlaysImportResult =
        await _boardGamesService.importPlays(username, boardGameId, gameFamily);
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
      final bggPlayExists = _gamePlaythroughsDetailsStore.playthroughs
          .any((playthrough) => playthrough.bggPlayId == bggPlay.id);
      if (bggPlayExists) {
        continue;
      }

      final List<Player> players = [];
      final Map<String, PlayerScore> playerScores = {};
      for (final bggPlayer in bggPlay.players) {
        String playerId;
        if (bggPlayer.playerBggUserId == null) {
          playerId = _playersStore.activePlayers
                  .firstWhereOrNull((p) => p.name == bggPlayer.playerName)
                  ?.id ??
              const Uuid().v4();
        } else {
          playerId = bggPlayer.playerBggUserId.toString();
        }

        final bool isExistingPlayer =
            _playersStore.activePlayers.firstWhereOrNull((p) => p.id == playerId) != null;
        final Player player = Player(
          id: playerId,
          name: bggPlayer.playerName,
          bggName: bggPlayer.playerBggName,
        );

        if (await _playersStore.createOrUpdatePlayer(player)) {
          if (!isExistingPlayer &&
              ((player.name?.isBlank ?? false) || (player.bggName?.isBlank ?? false))) {
            bggPlaysImportRaport!.createdPlayers.add(player.name ?? player.bggName ?? '');
          }

          players.add(player);

          var playerScore = Score(
            id: const Uuid().v4(),
            playerId: player.id,
            boardGameId: boardGameId,
            value: bggPlayer.playerScore.toString(),
          );
          if (gameFamily == GameFamily.Cooperative) {
            playerScore = playerScore.copyWith(
              noScoreGameResult: NoScoreGameResult(
                cooperativeGameResult: bggPlayer.playerWin?.toCooperativeResult(),
              ),
            );
          }
          playerScores[player.id] = PlayerScore(player: player, score: playerScore);
        }
      }

      final newPlaythrough = await _gamePlaythroughsDetailsStore.createPlaythrough(
        bggPlay.boardGameId,
        players,
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

  Future<void> trackOpenGamesPlaylist() async {
    await _analyticsService.logEvent(
      name: Analytics.openGamesPlaylist,
      parameters: <String, String>{
        Analytics.boardGameIdParameter: boardGameId,
        Analytics.boardGameNameParameter: boardGameName,
      },
    );
  }

  Future<void> trackTabChange(int tabIndex) async {
    await _analyticsService.logScreenView(
      screenName: _screenViewByTabIndex[tabIndex]!.item1,
      screenClass: _screenViewByTabIndex[tabIndex]!.item2,
    );
  }
}
