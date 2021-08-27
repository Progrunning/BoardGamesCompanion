import 'package:injectable/injectable.dart';

import '../common/hive_boxes.dart';
import '../models/hive/score.dart';
import 'hive_base_service.dart';

@singleton
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
