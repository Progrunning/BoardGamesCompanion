import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/services/hide_base_service.dart';

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
}
