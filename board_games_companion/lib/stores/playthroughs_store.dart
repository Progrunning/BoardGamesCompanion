// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/playthrough_status.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:board_games_companion/stores/scores_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/player_score.dart';
import '../models/playthroughs/playthrough_player.dart';

part 'playthroughs_store.g.dart';

@singleton
class PlaythroughsStore = _PlaythroughsStore with _$PlaythroughsStore;

abstract class _PlaythroughsStore with Store {
  _PlaythroughsStore(this._playthroughService, this._scoresStore);

  final PlaythroughService _playthroughService;
  final ScoresStore _scoresStore;

  @observable
  ObservableList<Playthrough> playthroughs = ObservableList.of([]);

  @computed
  List<Playthrough> get finishedPlaythroughs =>
      playthroughs.where((p) => p.status == PlaythroughStatus.Finished).toList();

  @computed
  List<Playthrough> get ongoingPlaythroughs =>
      playthroughs.where((p) => p.status == PlaythroughStatus.Started).toList();

  Future<void> loadPlaythroughs() async {
    try {
      playthroughs = (await _playthroughService.retrievePlaythroughs()).asObservable();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

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

    await _scoresStore.refreshScores(newPlaythrough.id);

    playthroughs.add(newPlaythrough);

    return newPlaythrough;
  }

  Future<bool> updatePlaythrough(Playthrough playthroughToUpdate) async {
    final updateSuceeded = await _playthroughService.updatePlaythrough(playthroughToUpdate);
    if (updateSuceeded) {
      final playthroughIndex =
          playthroughs.indexWhere((playthrough) => playthrough.id == playthroughToUpdate.id);
      playthroughs[playthroughIndex] = playthroughToUpdate;
    }

    return updateSuceeded;
  }

  Future<bool> deletePlaythrough(String playthroughId) async {
    final deleteSuceeded = await _playthroughService.deletePlaythrough(playthroughId);
    if (deleteSuceeded) {
      final playthroughIndex =
          playthroughs.indexWhere((playthrough) => playthrough.id == playthroughId);
      playthroughs.removeAt(playthroughIndex);
    }

    return deleteSuceeded;
  }
}
