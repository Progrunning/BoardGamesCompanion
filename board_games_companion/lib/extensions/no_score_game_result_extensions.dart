import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/models/hive/no_score_game_result.dart';

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
