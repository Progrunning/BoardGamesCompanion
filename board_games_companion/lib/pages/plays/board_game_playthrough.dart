import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sprintf/sprintf.dart';

import '../../models/hive/no_score_game_result.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_details.dart';

part 'board_game_playthrough.freezed.dart';

@freezed
class BoardGamePlaythrough with _$BoardGamePlaythrough {
  const factory BoardGamePlaythrough({
    required PlaythroughDetails playthrough,
    required BoardGameDetails boardGameDetails,
  }) = _BoardGamePlaythrough;

  const BoardGamePlaythrough._();

  PlayerScore get winner {
    final sortedPlayerScores = playthrough.playerScores
        .toList()
        .sortByScore(boardGameDetails.settings?.gameFamily ?? GameFamily.HighestScore);
    return sortedPlayerScores.first;
  }

  String get id => '${boardGameDetails.id}${playthrough.id}';

  GameFamily get gameFamily => boardGameDetails.settings?.gameFamily ?? GameFamily.HighestScore;

  String get gameResultTextFormatted {
    switch (gameFamily) {
      case GameFamily.HighestScore:
      case GameFamily.LowestScore:
        final winner = this.winner;
        return sprintf(
          AppText.playPageHistoryTabScoreGameResultFormat,
          [
            winner.player?.name ?? '',
            winner.score.valueInt,
          ],
        );

      case GameFamily.Cooperative:
        switch (playthrough.playerScores.first.score.noScoreGameResult?.cooperativeGameResult) {
          case CooperativeGameResult.win:
            return AppText.playPageHistoryTabCooperativeGameResultWin;
          case CooperativeGameResult.loss:
            return AppText.playPageHistoryTabCooperativeGameResultLoss;
          default:
            break;
        }
    }

    return '';
  }
}
