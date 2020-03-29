import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/services/hide_base_service.dart';

class ScoreService extends BaseHiveService<Score> {
  Future<List<Score>> retrieveScores(Iterable<String> playthroughIds) async {
    if ((playthroughIds?.isEmpty ?? true) ||
        !await ensureBoxOpen(HiveBoxes.Scores)) {
      return List<Score>();
    }

    return storageBox
        ?.toMap()
        ?.values
        ?.where((score) =>
            !(score.isDeleted ?? false) &&
            playthroughIds.contains(score.playthroughId))
        ?.toList();
  }
}
