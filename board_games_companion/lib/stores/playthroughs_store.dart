// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/extensions/scores_extensions.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/services/score_service.dart';
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
import '../services/playthroughs_service.dart';

part 'playthroughs_store.g.dart';

@singleton
class PlaythroughsStore = _PlaythroughsStore with _$PlaythroughsStore;

abstract class _PlaythroughsStore with Store {
  _PlaythroughsStore(this._playthroughService, this._scoreService, this._playerService);

  final PlaythroughService _playthroughService;
  final ScoreService _scoreService;
  final PlayerService _playerService;

  late BoardGameDetails boardGame;

  @observable
  ObservableList<PlaythroughDetails> playthroughs = ObservableList.of([]);

  @action
  Future<void> loadPlaythroughs() async {
    if (boardGame == null) {
      return;
    }

    playthroughs.clear();

    try {
      final hivePlaythrough = await _playthroughService.retrievePlaythroughs([boardGame.id]);
      for (final hivePlaythrough in hivePlaythrough) {
        final playthrough = await createPlaythroughDetails(hivePlaythrough);
        playthroughs.add(playthrough);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
  void setBoardGame(BoardGameDetails boardGame) => this.boardGame = boardGame;

  Future<PlaythroughDetails?> createPlaythrough(
    String boardGameId,
    List<PlaythroughPlayer> playthoughPlayers,
    Map<String, PlayerScore> playerScores,
    DateTime startDate,
    Duration? duration, {
    int? bggPlayId,
  }) async {
    final newHivePlaythrough = await _playthroughService.createPlaythrough(
      boardGameId,
      playthoughPlayers,
      playerScores,
      startDate,
      duration,
      bggPlayId: bggPlayId,
    );

    if (newHivePlaythrough == null) {
      FirebaseCrashlytics.instance.log(
        'Faild to new playthrough for a board game $boardGameId with ${playthoughPlayers.length} players',
      );

      return null;
    }

    final playthrough = await createPlaythroughDetails(newHivePlaythrough);
    playthroughs.add(playthrough);
    return playthrough;
  }

  Future<void> updatePlaythrough(PlaythroughDetails? playthrough) async {
    if (playthrough?.id.isEmpty ?? true) {
      return;
    }

    try {
      final updateSuceeded = await _playthroughService.updatePlaythrough(playthrough!.playthrough);
      if (updateSuceeded) {
        for (final PlayerScore playerScore in playthrough.playerScores) {
          await _scoreService.addOrUpdateScore(playerScore.score);
        }

        loadPlaythroughs();
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<bool> deletePlaythrough(String playthroughId) async {
    try {
      final deleteSucceeded = await _playthroughService.deletePlaythrough(playthroughId);
      if (deleteSucceeded) {
        playthroughs.removeWhere((p) => p.playthrough.id == playthroughId);
      }

      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<PlaythroughDetails> createPlaythroughDetails(Playthrough hivePlaythrough) async {
    final scores = (await _scoreService.retrieveScores([hivePlaythrough.id]))
      ..sortByScore(boardGame.settings?.winningCondition ?? GameWinningCondition.HighestScore)
      ..toList();
    final players = await _playerService.retrievePlayers(
      playerIds: hivePlaythrough.playerIds,
      includeDeleted: true,
    );

    final playerScores = scores.mapIndexed((int index, Score score) {
      final player = players.firstWhereOrNull((Player p) => score.playerId == p.id);
      return PlayerScore.withPlace(player, score, index + 1);
    }).toList();

    return PlaythroughDetails(
      playthrough: hivePlaythrough,
      scores: scores,
      players: players,
      playerScores: playerScores,
    );
  }
}
