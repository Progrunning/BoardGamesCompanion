import 'package:board_games_companion/common/constants.dart';

import '../common/enums/game_winning_condition.dart';
import '../extensions/scores_extensions.dart';
import '../models/player_score.dart';

extension PlayerScoresExtesions on List<PlayerScore> {
  List<PlayerScore> sortByScore(GameWinningCondition winningCondition) {
    return this
      ..sort((PlayerScore playerScore, PlayerScore otherPlayerScore) {
        return compareScores(playerScore.score, otherPlayerScore.score, winningCondition);
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
