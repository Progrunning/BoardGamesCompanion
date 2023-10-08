import 'package:freezed_annotation/freezed_annotation.dart';

part 'playthrough_scores_visual_state.freezed.dart';

@freezed
class PlaythroughScoresVisualState with _$PlaythroughScoresVisualState {
  const factory PlaythroughScoresVisualState.init() = _init;
  const factory PlaythroughScoresVisualState.scoring() = _scoring;
  const factory PlaythroughScoresVisualState.finishedScoring({
    required Set<String> tiedPlayerScoresSet,
    required bool hasTies,
  }) = _finishedScoring;
}
