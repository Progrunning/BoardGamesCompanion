import '../common/enums/game_classification.dart';
import '../common/enums/game_family.dart';

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
