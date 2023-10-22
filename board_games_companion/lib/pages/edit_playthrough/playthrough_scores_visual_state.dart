import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_view_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobx/mobx.dart';

part 'playthrough_scores_visual_state.freezed.dart';

/// In order to trigger UI refresh on the [_finishedScoring] state change a [_finishedScoring.uniqnessEnforcingDummyDate] was introduced.
/// Use [DateTime.now] when assigning the [_finishedScoring.uniqnessEnforcingDummyDate], to ensure uniquness of the state,
/// which will enjorce broadcast of a new event, informing listeners of [Observable] to re-draw the UI.
///
/// The above was introduces as a "hacky" solution to a problem with [_finishedScoring.playerScores] being reference types mapped from
/// [EditPlaythoughViewModel.playerScores] and being updated in the [_finishedScoring] immediatly, which made state mutation difficult.
///
/// NOTE: We don't create a new list of [PlayerScore]s to help with mutation of the state because it will cause
/// screen flicker when reordering player scores.
@freezed
class PlaythroughScoresVisualState with _$PlaythroughScoresVisualState {
  const factory PlaythroughScoresVisualState.init() = _init;
  const factory PlaythroughScoresVisualState.scoring({
    required List<PlayerScore> playerScores,
  }) = _scoring;
  const factory PlaythroughScoresVisualState.finishedScoring({
    required List<PlayerScore> playerScores,
    required Map<String, ScoreTiebreakerType> scoreTiebreakersSet,
    required DateTime uniqnessEnforcingDummyDate,
  }) = _finishedScoring;
}
