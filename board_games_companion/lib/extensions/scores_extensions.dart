import 'dart:math';

import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/enums/game_win_condition.dart';

import '../models/hive/score.dart';

extension ScoreExtesions on Score {
  String toMapKey() {
    return '$playthroughId$playerId';
  }
}

extension ScoresExtesions on List<Score>? {
  List<Score> onlyScoresWithValue() {
    return this
            ?.where((s) => (s.value?.isNotEmpty ?? false) && num.tryParse(s.value!) != null)
            .toList() ??
        <Score>[];
  }

  List<Score>? sortByScore(GameWinCondition winningCondition) {
    return this
      ?..sort((Score score, Score otherScore) {
        return compareScores(score, otherScore, winningCondition);
      });
  }

  num? toBestScore(GameWinCondition gameWinningCondition) {
    final scores = this
            ?.where((Score score) => score.value != null && num.tryParse(score.value!) != null)
            .map((Score score) => num.parse(score.value!)) ??
        [];
    switch (gameWinningCondition) {
      case GameWinCondition.HighestScore:
        return scores.reduce(max);
      case GameWinCondition.LowestScore:
        return scores.reduce(min);
      case GameWinCondition.Coop:
        break;
    }

    return null;
  }

  double? toAverageScore() {
    final scores = this
            ?.where((Score score) => score.value != null && num.tryParse(score.value!) != null)
            .map((Score score) => num.parse(score.value!)) ??
        [];

    if (scores.isEmpty) {
      return null;
    }

    return scores.reduce((a, b) => a + b) / scores.length;
  }
}

int compareScores(Score score, Score otherScore, GameWinCondition winningCondition) {
  switch (winningCondition) {
    case GameWinCondition.LowestScore:
      // MK Swap scores around
      final buffer = otherScore;
      otherScore = score;
      score = buffer;
      break;
    case GameWinCondition.HighestScore:
      // MK No swapping needed
      break;
    case GameWinCondition.Coop:
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
