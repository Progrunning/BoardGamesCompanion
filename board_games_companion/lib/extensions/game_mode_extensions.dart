import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/common/enums/game_family.dart';

extension GameClassificationExtensions on GameClassification {
  GameFamily toDefaultGameFamily() {
    switch (this) {
      case GameClassification.Score:
        return GameFamily.HighestScore;
      case GameClassification.NoScore:
        return GameFamily.Cooperative;
    }
  }
}
