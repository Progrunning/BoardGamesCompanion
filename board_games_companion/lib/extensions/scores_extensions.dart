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

    if (scores.isEmpty) {
      return null;
    }

    return scores.reduce((a, b) => a + b) / scores.length;
  }
}
