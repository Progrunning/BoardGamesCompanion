import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';

import '../common/constants.dart';
import '../common/enums/game_family.dart';
import '../models/player_score.dart';

extension PlayerScoresExtesions on List<PlayerScore> {
  /// Orders [PlayerScore] based on place or score.
  ///
  /// The sorting logic checks if the [ScoreGameResult] is present and if it is then it compares [ScoreGameResult.place].
  /// If [ScoreGameResult.place] hasn't been yet defined for a score then it compares the [ScoreGameResult.points].
  ///
  /// For older records, that don't have [ScoreGameResult] the comparison is done based on the [Score.value]
  ///
  /// Use [ignorePlaces] parameter to disregard current placement in [ScoreGameResult.place] and force the reorder based on the scores.
  List<PlayerScore> sortByScore(
    GameFamily gameFamily, {
    bool ignorePlaces = false,
  }) {
    return this
      ..sort((PlayerScore playerScore, PlayerScore otherPlayerScore) {
        return compareScores(playerScore.score, otherPlayerScore.score, gameFamily, ignorePlaces);
      });
  }

  List<PlayerScore> sortByPlayerName() {
    return this
      ..sort((PlayerScore playerScore, PlayerScore otherPlayerScore) {
        if (playerScore.player == null) {
          if (otherPlayerScore.player != null) {
            return Constants.moveBelow;
          }

          return Constants.leaveAsIs;
        }

        if (otherPlayerScore.player == null) {
          return Constants.moveAbove;
        }

        return playerScore.player!.name?.compareTo(otherPlayerScore.player!.name ?? '') ??
            Constants.moveBelow;
      });
  }
}
