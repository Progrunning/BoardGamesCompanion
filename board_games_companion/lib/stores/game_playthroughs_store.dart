// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/stores/scores_store.dart';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../common/enums/game_winning_condition.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/player.dart';
import '../models/hive/playthrough.dart';
import '../models/hive/score.dart';
import '../models/playthrough_details.dart';
import '../models/playthrough_player.dart';
import '../services/player_service.dart';

part 'game_playthroughs_store.g.dart';

@singleton
class GamePlaythroughsStore = _GamePlaythroughsStore with _$GamePlaythroughsStore;

abstract class _GamePlaythroughsStore with Store {
  _GamePlaythroughsStore(this._playthroughsStore, this._scoresStore, this._playerService);

  final PlaythroughsStore _playthroughsStore;
  final ScoresStore _scoresStore;
  final PlayerService _playerService;

  @observable
  BoardGameDetails? _boardGame;

  @observable
  ObservableList<PlaythroughDetails> playthroughsDetails = ObservableList.of([]);

  @computed
  List<Playthrough> get playthroughs => _playthroughsStore.playthroughs
      .where((playthrough) => playthrough.boardGameId == boardGameId)
      .toList();

  @computed
  List<Playthrough> get finishedPlaythroughs => _playthroughsStore.finishedPlaythroughs
      .where((playthrough) => playthrough.boardGameId == boardGameId)
      .toList()
    ..sort((playthrough, otherPlaythrough) =>
        otherPlaythrough.startDate.compareTo(playthrough.startDate));

  @computed
  String get boardGameName => _boardGame!.name;

  @computed
  String get boardGameId => _boardGame!.id;

  @computed
  String? get boardGameImageUrl => _boardGame!.imageUrl;

  @computed
  GameWinningCondition get gameWinningCondition =>
      _boardGame!.settings?.winningCondition ?? GameWinningCondition.HighestScore;

  @action
  Future<void> loadPlaythroughs() async {
    try {
      final loadedPlaythroughDetails = <PlaythroughDetails>[];
      await _playthroughsStore.loadPlaythroughs();
      for (final playthrough in playthroughs) {
        final playthroughDetails = await createPlaythroughDetails(playthrough);
        loadedPlaythroughDetails.add(playthroughDetails);
      }

      playthroughsDetails = loadedPlaythroughDetails.asObservable();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
  void setBoardGame(BoardGameDetails boardGame) => _boardGame = boardGame;

  Future<PlaythroughDetails?> createPlaythrough(
    String boardGameId,
    List<PlaythroughPlayer> playthoughPlayers,
    Map<String, PlayerScore> playerScores,
    DateTime startDate,
    Duration? duration, {
    int? bggPlayId,
  }) async {
    final newPlaythrough = await _playthroughsStore.createPlaythrough(
      boardGameId,
      playthoughPlayers,
      playerScores,
      startDate,
      duration,
      bggPlayId: bggPlayId,
    );

    if (newPlaythrough == null) {
      return null;
    }

    final newPlaythroughDetails = await createPlaythroughDetails(newPlaythrough);
    playthroughsDetails.add(newPlaythroughDetails);
    return newPlaythroughDetails;
  }

  Future<void> updatePlaythrough(PlaythroughDetails? playthroughDetails) async {
    if (playthroughDetails?.id.isEmpty ?? true) {
      return;
    }

    try {
      final updateSuceeded =
          await _playthroughsStore.updatePlaythrough(playthroughDetails!.playthrough);
      if (updateSuceeded) {
        for (final PlayerScore playerScore in playthroughDetails.playerScores) {
          await _scoresStore.addOrUpdateScore(playerScore.score);
        }

        await loadPlaythroughs();
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<bool> deletePlaythrough(String playthroughId) async {
    try {
      final deleteSucceeded = await _playthroughsStore.deletePlaythrough(playthroughId);
      if (deleteSucceeded) {
        playthroughsDetails.removeWhere((p) => p.playthrough.id == playthroughId);
      }

      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<PlaythroughDetails> createPlaythroughDetails(Playthrough playthrough) async {
    final scores =
        _scoresStore.scores.where((score) => score.playthroughId == playthrough.id).toList()
          ..sortByScore(gameWinningCondition)
          ..toList();
    final players = await _playerService.retrievePlayers(
      playerIds: playthrough.playerIds,
      includeDeleted: true,
    );

    final playerScores = scores.mapIndexed((int index, Score score) {
      final player = players.firstWhereOrNull((Player p) => score.playerId == p.id);
      return PlayerScore(player: player, score: score, place: index + 1);
    }).toList();

    return PlaythroughDetails(playthrough: playthrough, playerScores: playerScores);
  }
}
