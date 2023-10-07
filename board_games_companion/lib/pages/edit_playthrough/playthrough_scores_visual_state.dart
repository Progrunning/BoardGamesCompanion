import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/player_score.dart';

part 'playthrough_scores_visual_state.freezed.dart';

@freezed
class PlaythroughScoresVisualState with _$PlaythroughScoresVisualState {
  const factory PlaythroughScoresVisualState.init() = _init;
  const factory PlaythroughScoresVisualState.scoring() = _scoring;
  const factory PlaythroughScoresVisualState.finishedScoring({
    required Map<String, PlayerScore> tiedPlayerScoresMap,
    required bool hasTies,
  }) = _finishedScoring;
}
