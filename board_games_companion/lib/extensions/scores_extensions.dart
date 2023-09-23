import 'dart:math';

import '../common/constants.dart';
import '../common/enums/game_family.dart';
import '../models/hive/no_score_game_result.dart';
import '../models/hive/score.dart';

extension ScoreExtesions on Score {
  String toMapKey() {
    return '$playthroughId$playerId';
  }
}

extension ScoresExtesions on Iterable<Score>? {
  List<Score> onlyScoresWithValue() {
    return this
            ?.where((s) => (s.value?.isNotEmpty ?? false) && num.tryParse(s.value!) != null)
            .toList() ??
        <Score>[];
  }

  List<Score> onlyCooperativeGames() {
    return this?.where((s) => s.noScoreGameResult?.cooperativeGameResult != null).toList() ??
        <Score>[];
  }

  List<Score>? sortByScore(GameFamily gameFamily) {
    return this?.toList()
      ?..sort((Score score, Score otherScore) {
        return compareScores(score, otherScore, gameFamily);
      });
  }

  num? toBestScore(GameFamily gameFamily) {
    final scores = this
            ?.where((Score score) => score.value != null && num.tryParse(score.value!) != null)
            .map((Score score) => num.parse(score.value!)) ??
        [];
    switch (gameFamily) {
      case GameFamily.HighestScore:
        return scores.reduce(max);
      case GameFamily.LowestScore:
        return scores.reduce(min);
      case GameFamily.Cooperative:
        break;
    }

    return null;
  }

  double toAverageScore() {
    final scores = this
            ?.where((Score score) => score.value != null && num.tryParse(score.value!) != null)
            .map((Score score) => num.parse(score.value!)) ??
        [];

    return scores.reduce((a, b) => a + b) / scores.length;
  }

  int get totalCooperativeWins =>
      this
          ?.where((score) =>
              score.noScoreGameResult?.cooperativeGameResult == CooperativeGameResult.win)
          .length ??
      0;

  int get totalCooperativeLosses =>
      this
          ?.where((score) =>
              score.noScoreGameResult?.cooperativeGameResult == CooperativeGameResult.loss)
          .length ??
      0;
}

int compareScores(Score score, Score otherScore, GameFamily gameFamily) {
  switch (gameFamily) {
    case GameFamily.LowestScore:
      // MK Swap scores around
      final buffer = otherScore;
      otherScore = score;
      score = buffer;
      break;
    case GameFamily.HighestScore:
      // MK No swapping needed
      break;
    case GameFamily.Cooperative:
      break;
  }

  if (score.value == null && otherScore.value == null) {
    return Constants.leaveAsIs;
  }

  if (score.value == null) {
    return Constants.moveBelow;
  }

  if (otherScore.value == null) {
    return Constants.moveAbove;
  }

  final num? aNumber = num.tryParse(score.value!);
  final num? bNumber = num.tryParse(otherScore.value!);
  if (aNumber == null && bNumber == null) {
    return Constants.leaveAsIs;
  }

  if (aNumber == null) {
    return Constants.moveBelow;
  }

  if (bNumber == null) {
    return Constants.moveAbove;
  }

  return bNumber.compareTo(aNumber);
}
