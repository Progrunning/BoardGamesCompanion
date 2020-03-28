import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/services/hide_base_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class PlaythroughService extends BaseHiveService<Playthrough> {
  Future<List<Playthrough>> retrievePlaythroughs(String boardGameId) async {
    if (boardGameId?.isEmpty ?? true) {
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
            playthrough.boardGameId == boardGameId)
        ?.toList();
  }

  Future<Playthrough> createPlaythrough(
      String boardGameId, List<PlaythroughPlayer> playthoughPlayers) async {
    if ((boardGameId?.isEmpty ?? true) ||
        (playthoughPlayers?.isEmpty ?? true)) {
      return null;
    }

    final playthoughPlayerIds = playthoughPlayers
        .map(
          (p) => p.player?.id,
        )
        .toList();

    if (playthoughPlayerIds.isEmpty ||
        !await ensureBoxOpen(HiveBoxes.Playthroughs)) {
      return null;
    }

    final newPlaythrough = Playthrough();
    newPlaythrough.id = uuid.v4();
    newPlaythrough.boardGameId = boardGameId;
    newPlaythrough.playerIds = playthoughPlayerIds;

    try {
      await storageBox.put(newPlaythrough.id, newPlaythrough);
      return newPlaythrough;
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return null;
  }
}
