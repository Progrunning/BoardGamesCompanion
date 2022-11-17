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
}
