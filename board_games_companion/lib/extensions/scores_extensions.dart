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

  /// Returns winner(s)
  ///
  /// In case [Score]s are recorded using the "old" ways, grab the highest/lowest score
  /// and treat as a winner.
  List<Score> winners(GameFamily gameFamily) {
    var winners = this?.onlyScoresWithValue().where((s) => s.isWinner).toList();

    // Get the winner by ordering scores highest/lowest and taking the top one
    if (winners?.isEmpty ?? true) {
      final orderedScores = this?.onlyScoresWithValue().sortByScore(gameFamily);
      if (orderedScores?.isNotEmpty ?? false) {
        winners = [orderedScores!.first];
      }
    }

    return winners ?? [];
  }

  List<Score> onlyCooperativeGames() {
    return this?.where((s) => s.noScoreGameResult?.cooperativeGameResult != null).toList() ??
        <Score>[];
  }

  List<Score>? sortByScore(GameFamily gameFamily, {bool ignorePlaces = false}) {
    return this?.toList()
      ?..sort((Score score, Score otherScore) {
        return compareScores(score, otherScore, gameFamily, ignorePlaces: ignorePlaces);
      });
  }

  num? toBestScore(GameFamily gameFamily) {
    final scores = this?.onlyScoresWithValue().map((Score score) => score.score!) ?? [];
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
    final scores = this?.onlyScoresWithValue().map((Score score) => score.score!) ?? [];

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

int compareScores(
  Score score,
  Score otherScore,
  GameFamily gameFamily, {
  bool ignorePlaces = false,
}) {
  // Technically this shouldn't happen as we shouldn't be comparing scores from
  // different game families. However, there is a bug in the app or a behaviour in which
  // this does happen therefore this needs to be handled.
  if ((gameFamily == GameFamily.HighestScore || gameFamily == GameFamily.LowestScore) &&
      (score.noScoreGameResult != null || otherScore.noScoreGameResult != null)) {
    return Constants.leaveAsIs;
  }

  // Regardless of the game family all the scores without a score go to the bottom of the list
  if (score.hasScore && !otherScore.hasScore) {
    return Constants.moveAbove;
  }

  if (!score.hasScore && otherScore.hasScore) {
    return Constants.moveBelow;
  }

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
      // MK With cooperative games there's no need to sort scores as all are win or lose
      return Constants.leaveAsIs;
  }

  return _compareScores(score, otherScore, ignorePlaces);
}

int _compareScores(Score score, Score otherScore, [bool ignorePlaces = false]) {
  if (!ignorePlaces &&
      score.scoreGameResult?.place != null &&
      otherScore.scoreGameResult?.place != null) {
    return score.scoreGameResult!.place!.compareTo(otherScore.scoreGameResult!.place!);
  }

  if (!score.hasScore && !otherScore.hasScore) {
    return Constants.leaveAsIs;
  }

  if (!score.hasScore) {
    return Constants.moveBelow;
  }

  if (!otherScore.hasScore) {
    return Constants.moveAbove;
  }

  return otherScore.score!.compareTo(score.score!);
}
