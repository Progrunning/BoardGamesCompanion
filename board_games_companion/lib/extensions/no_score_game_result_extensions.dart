import '../common/app_text.dart';
import '../models/hive/no_score_game_result.dart';

extension NoScoreGameResultExtensions on NoScoreGameResult? {
  String toPlayerAvatarDisplayText() {
    if (this == null) {
      return '-';
    }

    switch (this!.cooperativeGameResult) {
      case CooperativeGameResult.win:
        return AppText.editPlaythroughNoScoreResultWinText;
      case CooperativeGameResult.loss:
        return AppText.editPlaythroughNoScoreResultLossText;
      default:
        return '-';
    }
  }
}
