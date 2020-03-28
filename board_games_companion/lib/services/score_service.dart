import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/services/hide_base_service.dart';

class ScoreService extends BaseHiveService<Score> {
  Future<List<Score>> retrieveScores(String playthroughId) async {
    if ((playthroughId?.isEmpty ?? true) ||
        !await ensureBoxOpen(HiveBoxes.Scores)) {
      return List<Score>();
    }

    return storageBox
        ?.toMap()
        ?.values
        ?.where((score) =>
            !(score.isDeleted ?? false) && score.playthroughId == playthroughId)
        ?.toList();
  }
}
