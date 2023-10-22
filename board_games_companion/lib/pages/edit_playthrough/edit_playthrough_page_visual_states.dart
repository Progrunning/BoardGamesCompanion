import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_playthrough_page_visual_states.freezed.dart';

@freezed
class EditPlaythroughPageVisualStates with _$EditPlaythroughPageVisualStates {
  const factory EditPlaythroughPageVisualStates.init() = _init;
  const factory EditPlaythroughPageVisualStates.editScoreGame({
    required GameFamily gameFamily,
  }) = _editScoreGame;
  const factory EditPlaythroughPageVisualStates.editNoScoreGame({
    required GameFamily gameFamily,
  }) = _editNoScoreGame;
}
