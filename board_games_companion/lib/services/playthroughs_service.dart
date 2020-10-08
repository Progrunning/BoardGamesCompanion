import 'package:board_games_companion/common/enums/playthrough_status.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/services/hide_base_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class PlaythroughService extends BaseHiveService<Playthrough> {
  final ScoreService scoreService;

  PlaythroughService(this.scoreService);

  Future<List<Playthrough>> retrievePlaythroughs(
      Iterable<String> boardGameIds) async {
    if (boardGameIds?.isEmpty ?? true) {
      return List<Playthrough>();
    }

    if (!await ensureBoxOpen(HiveBoxes.Playthroughs)) {
      return List<Playthrough>();
    }

    return storageBox
        ?.toMap()
        ?.values
        ?.where((playthrough) =>
            !(playthrough.isDeleted ?? false) &&
            boardGameIds.contains(playthrough.boardGameId))
        ?.toList();
  }

  Future<Playthrough> createPlaythrough(
      String boardGameId, List<PlaythroughPlayer> playthoughPlayers) async {
    if ((boardGameId?.isEmpty ?? true) ||
        (playthoughPlayers?.isEmpty ?? true)) {
      return null;
    }

    final playthroughPlayerIds = playthoughPlayers
        .map(
          (p) => p.player?.id,
        )
        .toList();

    if (playthroughPlayerIds.isEmpty ||
        !await ensureBoxOpen(HiveBoxes.Playthroughs)) {
      return null;
    }

    final newPlaythrough = Playthrough();
    newPlaythrough.id = uuid.v4();
    newPlaythrough.boardGameId = boardGameId;
    newPlaythrough.playerIds = playthroughPlayerIds;
    newPlaythrough.startDate = DateTime.now().toUtc();
    newPlaythrough.status = PlaythroughStatus.Started;
    newPlaythrough.scoreIds = List<String>();

    try {
      await storageBox.put(newPlaythrough.id, newPlaythrough);

      for (var playthroughPlayerId in playthroughPlayerIds) {
        final playerScore = Score();
        playerScore.boardGameId = boardGameId;
        playerScore.playerId = playthroughPlayerId;
        playerScore.playthroughId = newPlaythrough.id;
        if (!await scoreService.addOrUpdateScore(playerScore)) {
          FirebaseCrashlytics.instance.log(
              'Faild to create a player score for player $playthroughPlayerId for a board game $boardGameId');
        } else {
          newPlaythrough.scoreIds.add(playerScore.id);
        }
      }

      return newPlaythrough;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  Future<bool> updatePlaythrough(Playthrough playthrough) async {
    if ((playthrough?.id?.isEmpty ?? true) ||
        !await ensureBoxOpen(HiveBoxes.Playthroughs)) {
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
    if ((playthroughId?.isEmpty ?? true) ||
        !await ensureBoxOpen(HiveBoxes.Playthroughs)) {
      return false;
    }

    var playthroughToDelete = storageBox.get(playthroughId);
    if (playthroughToDelete == null ||
        (playthroughToDelete.isDeleted ?? false)) {
      return false;
    }

    playthroughToDelete.isDeleted = true;

    await storageBox.put(playthroughId, playthroughToDelete);

    return true;
  }

  Future<bool> deleteAllPlaythrough() async {
    if (!await ensureBoxOpen(HiveBoxes.Playthroughs)) {
      return false;
    }

    var playthroughs = storageBox.values;
    if (playthroughs?.isEmpty ?? true) {
      return false;
    }

    for (var playthrough in playthroughs) {
      playthrough.isDeleted = true;
    }

    await storageBox.putAll(Map.fromIterable(
      playthroughs,
      key: (p) => p.id,
      value: (p) => p,
    ));

    return true;
  }
}
