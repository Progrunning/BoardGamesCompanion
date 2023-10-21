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
  List<Score> onlyScoresWithValue() => this?.where((s) => s.hasScore).toList() ?? <Score>[];

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
    final scores = this?.onlyScoresWithValue().map((score) => num.parse(score.value!)) ?? [];
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

  if (score.scoreGameResult != null && otherScore.scoreGameResult != null) {
    return _compareScores(score, otherScore);
  }

  return _compareScoresUsingDeprecatedValue(score, otherScore);
}

int _compareScores(Score score, Score otherScore) {
  if (score.scoreGameResult!.place != null && otherScore.scoreGameResult!.place != null) {
    return score.scoreGameResult!.place!.compareTo(otherScore.scoreGameResult!.place!);
  }

  if (!score.scoreGameResult!.hasScore && !otherScore.scoreGameResult!.hasScore) {
    return Constants.leaveAsIs;
  }

  if (!score.scoreGameResult!.hasScore) {
    return Constants.moveBelow;
  }

  if (!otherScore.scoreGameResult!.hasScore) {
    return Constants.moveAbove;
  }

  return otherScore.scoreGameResult!.points!.compareTo(score.scoreGameResult!.points!);
}

/// Fallback comparison for old playthrough results captured
/// in the value property
int _compareScoresUsingDeprecatedValue(Score score, Score otherScore) {
  if (!score.hasScore && !otherScore.hasScore) {
    return Constants.leaveAsIs;
  }

  if (!score.hasScore) {
    return Constants.moveBelow;
  }

  if (!otherScore.hasScore) {
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
