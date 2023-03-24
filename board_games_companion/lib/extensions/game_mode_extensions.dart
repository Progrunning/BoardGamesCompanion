import 'package:board_games_companion/common/enums/game_mode.dart';
import 'package:board_games_companion/common/enums/game_win_condition.dart';

extension GameModeExtensions on GameMode {
  GameWinCondition toDefaultWinCondition() {
    switch (this) {
      case GameMode.Score:
        return GameWinCondition.HighestScore;
      case GameMode.NoScore:
        return GameWinCondition.Coop;
    }
  }
}
