import 'package:injectable/injectable.dart';

import '../common/hive_boxes.dart';
import '../models/hive/score.dart';
import 'hive_base_service.dart';

@singleton
class ScoreService extends BaseHiveService<Score> {
  Future<bool> addOrUpdateScore(Score score) async {
    if ((score.playthroughId?.isEmpty ?? true) ||
        (score.playerId.isEmpty) ||
        (score.boardGameId.isEmpty)) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.scores)) {
      return false;
    }

    await storageBox.put(score.id, score);

    return true;
  }

  Future<List<Score>> retrieveScores(Iterable<String> playthroughIds) async {
    if ((playthroughIds.isEmpty) || !await ensureBoxOpen(HiveBoxes.scores)) {
      return <Score>[];
    }

    return storageBox
        .toMap()
        .values
        .where((score) => playthroughIds.contains(score.playthroughId))
        .toList();
  }
}
