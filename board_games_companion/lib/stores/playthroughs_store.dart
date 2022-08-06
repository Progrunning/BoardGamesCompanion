// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/player_score.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/hive/board_game_details.dart';
import '../models/hive/playthrough.dart';
import '../models/playthrough_player.dart';
import '../services/playthroughs_service.dart';

part 'playthroughs_store.g.dart';

@singleton
class PlaythroughsStore = _PlaythroughsStore with _$PlaythroughsStore;

abstract class _PlaythroughsStore with Store {
  _PlaythroughsStore(this._playthroughService);

  final PlaythroughService _playthroughService;

  late BoardGameDetails boardGame;

  @observable
  ObservableList<Playthrough> playthroughs = ObservableList.of([]);

  @action
  Future<void> loadPlaythroughs() async {
    if (boardGame == null) {
      return;
    }

    try {
      playthroughs =
          ObservableList.of(await _playthroughService.retrievePlaythroughs([boardGame.id]));
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
  void setBoardGame(BoardGameDetails boardGame) => this.boardGame = boardGame;

  Future<Playthrough?> createPlaythrough(
    String boardGameId,
    List<PlaythroughPlayer> playthoughPlayers,
    Map<String, PlayerScore> playerScores,
    DateTime startDate,
    Duration? duration, {
    int? bggPlayId,
  }) async {
    final newPlaythrough = await _playthroughService.createPlaythrough(
      boardGameId,
      playthoughPlayers,
      playerScores,
      startDate,
      duration,
      bggPlayId: bggPlayId,
    );

    if (newPlaythrough == null) {
      FirebaseCrashlytics.instance.log(
        'Faild to new playthrough for a board game $boardGameId with ${playthoughPlayers.length} players',
      );

      return null;
    }

    playthroughs.add(newPlaythrough);

    return newPlaythrough;
  }

  Future<bool> updatePlaythrough(Playthrough? playthrough) async {
    if (playthrough?.id.isEmpty ?? true) {
      return false;
    }

    try {
      final updateSuceeded = await _playthroughService.updatePlaythrough(playthrough!);
      if (updateSuceeded) {
        loadPlaythroughs();
        return true;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> deletePlaythrough(String playthroughId) async {
    try {
      final deleteSucceeded = await _playthroughService.deletePlaythrough(playthroughId);
      if (deleteSucceeded) {
        playthroughs.removeWhere((p) => p.id == playthroughId);
      }

      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}
