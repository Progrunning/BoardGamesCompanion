// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/services/score_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/hive/score.dart';

part 'scores_store.g.dart';

@singleton
class ScoresStore = _ScoresStore with _$ScoresStore;

abstract class _ScoresStore with Store {
  _ScoresStore(this._scoreService);

  final ScoreService _scoreService;

  @observable
  ObservableList<Score> scores = ObservableList.of([]);

  Future<void> loadScores() async {
    scores = (await _scoreService.retrieveScores()).asObservable();
  }

  Future<void> refreshScores(String playthroughId) async {
    final playthroughScores = await _scoreService.retrieveScoresForPlaythrough(playthroughId);
    for (final score in playthroughScores) {
      final scoreIndex = scores.indexWhere((s) => s.id == score.id);
      if (scoreIndex == -1) {
        scores.add(score);
      } else {
        scores[scoreIndex] = score;
      }
    }
  }

  Future<bool> addOrUpdateScore(Score score) async {
    final operationSucceeded = await _scoreService.addOrUpdateScore(score);
    if (operationSucceeded) {
      final scoreIndex = scores.indexWhere((element) => element.id == score.id);
      if (scoreIndex == -1) {
        scores.add(score);
      } else {
        scores[scoreIndex] = score;
      }
    }

    return operationSucceeded;
  }
}
