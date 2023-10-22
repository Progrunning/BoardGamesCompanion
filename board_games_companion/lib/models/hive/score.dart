import 'package:basics/basics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';
import 'no_score_game_result.dart';
import 'score_game_results.dart';

export '../../extensions/scores_extensions.dart';

part 'score.freezed.dart';
part 'score.g.dart';

// TODO Consider renaming this class to Result and The PlayerScore to PlayerResult as this would better
//      align with keeping a score and no score information.
//
// IMPORTANT: Make sure that the existing entries in Hive won't break because of the naming changes
@freezed
class Score with _$Score {
  @HiveType(typeId: HiveBoxes.scoreTypeId, adapterName: 'ScoreAdapter')
  const factory Score({
    @HiveField(0) required String id,
    @HiveField(2) required String playerId,
    @HiveField(3) required String boardGameId,
    @Deprecated('Use ScoreGameResult instead') @HiveField(4) String? value,
    @HiveField(1) String? playthroughId,
    @HiveField(5, defaultValue: null) NoScoreGameResult? noScoreGameResult,
    @HiveField(6, defaultValue: null) ScoreGameResult? scoreGameResult,
  }) = _Score;

  const Score._();

  double? get score {
    if (scoreGameResult?.points != null) {
      return scoreGameResult!.points;
    }

    // Check deprecated way of storing score
    if (value.isNotNullOrBlank) {
      return num.tryParse(value!)?.toDouble();
    }

    return null;
  }

  String? get scoreFormatted => score?.toStringAsFixed(0);

  bool get hasScore =>
      (value.isNotNullOrBlank && num.tryParse(value!) != null) ||
      scoreGameResult?.points != null ||
      noScoreGameResult?.cooperativeGameResult != null;

  bool get isTied => scoreGameResult?.tiebreakerType != null;

  bool get isWinner => scoreGameResult?.place == 1;
}
