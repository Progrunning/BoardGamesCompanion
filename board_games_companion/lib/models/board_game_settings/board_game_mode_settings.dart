import 'package:board_games_companion/common/enums/game_win_condition.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../pages/playthroughs/average_score_precision.dart';

part 'board_game_mode_settings.freezed.dart';

@freezed
class BoardGameModeSettings with _$BoardGameModeSettings {
  const factory BoardGameModeSettings.score({
    required GameWinCondition gameWinCondition,
    required AverageScorePrecision averageScorePrecision,
  }) = _score;
  const factory BoardGameModeSettings.noScore({
    required GameWinCondition gameWinCondition,
  }) = _noScore;
}
