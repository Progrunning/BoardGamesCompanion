import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';
import 'no_score_game_result.dart';

export '../../extensions/scores_extensions.dart';

part 'score.freezed.dart';
part 'score.g.dart';

enum CooperativeGameResult {
  win,
  loss,
}

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
    @HiveField(4) String? value,
    @HiveField(1) String? playthroughId,
    @HiveField(5, defaultValue: null) NoScoreGameResult? noScoreGameResult,
  }) = _Score;

  const Score._();

  int get valueInt => int.tryParse(value ?? '0') ?? 0;
}
