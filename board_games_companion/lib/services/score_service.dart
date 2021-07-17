import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/services/hive_base_service.dart';

class ScoreService extends BaseHiveService<Score> {
  Future<bool> addOrUpdateScore(Score score) async {
    if ((score?.playthroughId?.isEmpty ?? true) ||
        (score.playerId?.isEmpty ?? true) ||
        (score.boardGameId?.isEmpty ?? true)) {
      return false;
    }

    if (score.id?.isEmpty ?? true) {
      score.id = uuid.v4();
    }

    if (!await ensureBoxOpen(HiveBoxes.Scores)) {
      return false;
    }

    await storageBox.put(score.id, score);

    return true;
  }

  Future<List<Score>> retrieveScores(Iterable<String> playthroughIds) async {
    if ((playthroughIds?.isEmpty ?? true) || !await ensureBoxOpen(HiveBoxes.Scores)) {
      return <Score>[];
    }

    return storageBox
        ?.toMap()
        ?.values
        ?.where((score) => playthroughIds.contains(score.playthroughId))
        ?.toList();
  }
}
