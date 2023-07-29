import 'package:basics/basics.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

import '../models/hive/score.dart';
import 'hive_base_service.dart';

@singleton
class ScoreService extends BaseHiveService<Score, ScoreService> {
  Future<bool> addOrUpdateScore(Score score) async {
    Fimber.d('Saving a score $score');
    if ((score.playthroughId?.isEmpty ?? true) ||
        (score.playerId.isEmpty) ||
        (score.boardGameId.isEmpty)) {
      Fimber.e('Score is missing required properties to be saved.');
      return false;
    }

    if (!await ensureBoxOpen()) {
      return false;
    }

    await storageBox.put(score.id, score);

    return true;
  }

  Future<List<Score>> retrieveScores() async {
    if (!await ensureBoxOpen()) {
      return <Score>[];
    }

    return storageBox.toMap().values.toList();
  }

  Future<List<Score>> retrieveScoresForPlaythrough(String playthroughId) async {
    if (playthroughId.isNullOrBlank || !await ensureBoxOpen()) {
      return <Score>[];
    }

    return storageBox
        .toMap()
        .values
        .where((score) => playthroughId == score.playthroughId)
        .toList();
  }

  Future<void> deleteScore(String id) async {
    if (!await ensureBoxOpen()) {
      return;
    }

    await storageBox.delete(id);
  }
}
