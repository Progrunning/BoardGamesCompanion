// ignore_for_file: library_private_types_in_public_api

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/hive/score.dart';
import '../services/score_service.dart';

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
    // ignore: prefer_foreach
    for (final score in playthroughScores) {
      _addOrUpdateScore(score);
    }
  }

  Future<bool> addOrUpdateScore(Score score) async {
    final operationSucceeded = await _scoreService.addOrUpdateScore(score);
    if (operationSucceeded) {
      _addOrUpdateScore(score);
    }

    return operationSucceeded;
  }

  void _addOrUpdateScore(Score updatedScore) {
    final scoreIndex = scores.indexWhere((score) => score.id == updatedScore.id);
    if (scoreIndex == -1) {
      scores.add(updatedScore);
    } else {
      scores[scoreIndex] = updatedScore;
    }
  }

  Future<void> deleteScore(String scoreId) async {
    await _scoreService.deleteScore(scoreId);
    final scoreIndex = scores.indexWhere((score) => score.id == scoreId);
    if (scoreIndex >= 0) {
      scores.removeAt(scoreIndex);
    }
  }
}
