import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playthrough_scores_visual_state.freezed.dart';

/// Ensure that the [_finishedScoring] state is unique (i.e. equality check on the object would return false)
/// when updating the properties of the state. Otherwise, the UI won't update because the state will be considered
/// "the same".
@freezed
class PlaythroughScoresVisualState with _$PlaythroughScoresVisualState {
  const factory PlaythroughScoresVisualState.init() = _init;
  const factory PlaythroughScoresVisualState.scoring({
    required List<PlayerScore> playerScores,
  }) = _scoring;
  const factory PlaythroughScoresVisualState.finishedScoring({
    required List<PlayerScore> playerScores,
    required Map<String, ScoreTiebreakerType> scoreTiebreakersSet,
    required bool hasTies,
  }) = _finishedScoring;
}
