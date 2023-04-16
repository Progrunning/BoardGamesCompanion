import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/game_family.dart';
import '../../pages/playthroughs/average_score_precision.dart';

part 'board_game_mode_classification.freezed.dart';

@freezed
class BoardGameClassificationSettings with _$BoardGameClassificationSettings {
  const factory BoardGameClassificationSettings.score({
    required GameFamily gameFamily,
    required AverageScorePrecision averageScorePrecision,
  }) = _score;
  const factory BoardGameClassificationSettings.noScore({
    required GameFamily gameFamily,
  }) = _noScore;
}
