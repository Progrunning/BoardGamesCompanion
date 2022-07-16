import 'dart:math';

import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/enums/game_winning_condition.dart';

import '../models/hive/score.dart';

extension ScoresExtesions on List<Score>? {
  List<Score> onlyScoresWithValue() {
    return this
            ?.where((s) => (s.value?.isNotEmpty ?? false) && num.tryParse(s.value!) != null)
            .toList() ??
        <Score>[];
  }

  List<Score>? sortByScore(GameWinningCondition winningCondition) {
    return this
      ?..sort((Score score, Score otherScore) {
        switch (winningCondition) {
          case GameWinningCondition.LowestScore:
            // MK Swap scores around
            final buffer = otherScore;
            otherScore = score;
            score = buffer;
            break;
          case GameWinningCondition.HighestScore:
            // MK No swapping needed
            break;
        }

        if (score.value == null && otherScore.value == null) {
          return Constants.LeaveAsIs;
        }

        if (score.value == null) {
          return Constants.MoveBelow;
        }

        if (otherScore.value == null) {
          return Constants.MoveAbove;
        }

        final num? aNumber = num.tryParse(score.value!);
        final num? bNumber = num.tryParse(otherScore.value!);
        if (aNumber == null && bNumber == null) {
          return Constants.LeaveAsIs;
        }

        if (aNumber == null) {
          return Constants.MoveBelow;
        }

        if (bNumber == null) {
          return Constants.MoveAbove;
        }

        return bNumber.compareTo(aNumber);
      });
  }

  num? toBestScore(GameWinningCondition gameWinningCondition) {
    final scores = this
            ?.where((Score score) => score.value != null && num.tryParse(score.value!) != null)
            .map((Score score) => num.parse(score.value!)) ??
        [];
    switch (gameWinningCondition) {
      case GameWinningCondition.HighestScore:
        return scores.reduce(max);
      case GameWinningCondition.LowestScore:
        return scores.reduce(min);
    }
  }

  double? toAverageScore() {
    final scores = this
            ?.where((Score score) => score.value != null && num.tryParse(score.value!) != null)
            .map((Score score) => num.parse(score.value!)) ??
        [];

    return scores.reduce((a, b) => a + b) / scores.length;
  }
}
