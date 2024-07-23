import 'package:basics/basics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_text.dart';
import '../../common/enums/game_family.dart';
import '../../models/hive/board_game_details.dart';
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

  List<PlayerScore> get winners {
    if (!playthrough.hasAnyScores) {
      return [];
    }

    var bestPlayerScores = playthrough.playerScores.where((ps) => ps.score.isWinner).toList();
    // The below condition is to ensure old score records are still showing winners
    if (bestPlayerScores.isEmpty) {
      bestPlayerScores = [
        playthrough.playerScores
            .toList()
            .sortByScore(boardGameDetails.settings?.gameFamily ?? GameFamily.HighestScore)
            .first
      ];
    }

    return bestPlayerScores;
  }

  String get id => '${boardGameDetails.id}${playthrough.id}';

  GameFamily get gameFamily => boardGameDetails.settings?.gameFamily ?? GameFamily.HighestScore;

  String get gameResultTextFormatted {
    switch (gameFamily) {
      case GameFamily.HighestScore:
      case GameFamily.LowestScore:
        if (winners.isEmpty) {
          return AppText.playPageHistoryTabScoreGameResultNoWinnersYet;
        }

        return sprintf(
          AppText.playPageHistoryTabScoreGameResultFormat,
          [
            winners
                .where((playerScore) => playerScore.player?.name.isNotNullOrBlank ?? false)
                .map((playerScore) => playerScore.player!.name)
                .join(', '),
            winners.first.score.score?.toStringAsFixed(0) ?? '-',
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
