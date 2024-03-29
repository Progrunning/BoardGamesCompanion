import 'package:fimber/fimber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

import '../common/enums/playthrough_status.dart';
import '../models/hive/playthrough.dart';
import '../models/hive/playthrough_note.dart';
import '../models/hive/score.dart';
import '../models/player_score.dart';
import 'hive_base_service.dart';
import 'score_service.dart';

@singleton
class PlaythroughService extends BaseHiveService<Playthrough, PlaythroughService> {
  PlaythroughService(super.hive, this.scoreService);

  final ScoreService scoreService;

  Future<List<Playthrough>> retrievePlaythroughs() async {
    if (!await ensureBoxOpen()) {
      return <Playthrough>[];
    }

    return storageBox
        .toMap()
        .values
        .where((playthrough) => !(playthrough.isDeleted ?? false))
        .toList();
  }

  Future<List<Playthrough>> retrieveGamePlaythroughs(
    List<String> boardGameIds, {
    bool includeDeleted = false,
  }) async {
    if (boardGameIds.isEmpty) {
      return <Playthrough>[];
    }

    if (!await ensureBoxOpen()) {
      return <Playthrough>[];
    }

    return storageBox
        .toMap()
        .values
        .where((playthrough) =>
            (includeDeleted || !(playthrough.isDeleted ?? false)) &&
            boardGameIds.contains(playthrough.boardGameId))
        .toList();
  }

  Future<Playthrough?> createPlaythrough(
    String boardGameId,
    List<String> playerIds,
    Map<String, PlayerScore> playerScores,
    DateTime startDate,
    Duration? duration, {
    int? bggPlayId,
    List<PlaythroughNote>? notes,
  }) async {
    Fimber.d('Creating a Playthrough...');
    if ((boardGameId.isEmpty) || (playerIds.isEmpty)) {
      return null;
    }

    if (!await ensureBoxOpen()) {
      return null;
    }

    var newPlaythrough = Playthrough(
      id: uuid.v4(),
      boardGameId: boardGameId,
      playerIds: playerIds,
      scoreIds: <String>[],
      startDate: startDate,
      bggPlayId: bggPlayId,
      notes: notes,
    );

    if (duration == null) {
      newPlaythrough = newPlaythrough.copyWith(status: PlaythroughStatus.Started);
    } else {
      newPlaythrough = newPlaythrough.copyWith(
        status: PlaythroughStatus.Finished,
        endDate: startDate.add(duration),
      );
    }

    try {
      Fimber.d('Saving $newPlaythrough...');

      for (final String playerId in playerIds) {
        Fimber.d('Creating or updated player score [$playerId]...');
        var playerScore = playerScores[playerId]?.score ??
            Score(
              id: uuid.v4(),
              playerId: playerId,
              boardGameId: boardGameId,
              playthroughId: newPlaythrough.id,
            );
        if (playerScore.playthroughId == null) {
          playerScore = playerScore.copyWith(playthroughId: newPlaythrough.id);
        }

        Fimber.d('Saving $playerScore...');
        if (!await scoreService.addOrUpdateScore(playerScore)) {
          Fimber.e('Failed to save $playerScore');
          FirebaseCrashlytics.instance.log(
            'Faild to create a player score for player $playerId for a board game $boardGameId',
          );
        } else {
          newPlaythrough = newPlaythrough.copyWith(
              scoreIds: newPlaythrough.scoreIds.toList()..add(playerScore.id));
        }
      }

      await storageBox.put(newPlaythrough.id, newPlaythrough);

      Fimber.d('Playthrough created');
      return newPlaythrough;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  Future<bool> updatePlaythrough(Playthrough playthrough) async {
    if ((playthrough.id.isEmpty) || !await ensureBoxOpen()) {
      return false;
    }

    try {
      await storageBox.put(playthrough.id, playthrough);
      return true;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> deletePlaythrough(String playthroughId) async {
    if ((playthroughId.isEmpty) || !await ensureBoxOpen()) {
      return false;
    }

    final playthroughToDelete = storageBox.get(playthroughId);
    if (playthroughToDelete == null || (playthroughToDelete.isDeleted ?? false)) {
      return false;
    }

    await storageBox.put(playthroughId, playthroughToDelete.copyWith(isDeleted: true));

    return true;
  }

  Future<bool> deletePlaythroughsForGames(List<String?> boardGameIds) async {
    if ((boardGameIds.isEmpty) || !await ensureBoxOpen()) {
      return false;
    }

    final List<Playthrough> playthroughsToDelete = storageBox.values
        .where((playthrough) => boardGameIds.contains(playthrough.boardGameId))
        .toList();
    if (playthroughsToDelete.isEmpty) {
      return false;
    }

    final Map<String, Playthrough> mappedPlaythroughs = {
      for (final playthroughToDelete in playthroughsToDelete)
        playthroughToDelete.id: playthroughToDelete.copyWith(isDeleted: true)
    };

    await storageBox.putAll(mappedPlaythroughs);

    return true;
  }

  Future<bool> deleteAllPlaythrough() async {
    if (!await ensureBoxOpen()) {
      return false;
    }

    final Iterable<Playthrough> playthroughs = storageBox.values;
    if (playthroughs.isEmpty) {
      return false;
    }

    await storageBox.putAll(<String, Playthrough>{
      for (final Playthrough playthrough in playthroughs)
        playthrough.id: playthrough.copyWith(isDeleted: true)
    });

    return true;
  }
}
