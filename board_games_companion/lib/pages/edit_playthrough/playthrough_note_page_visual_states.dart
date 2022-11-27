import 'package:board_games_companion/models/hive/playthrough_note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playthrough_note_page_visual_states.freezed.dart';

@freezed
class PlaythroughNotePageVisualState with _$PlaythroughNotePageVisualState {
  const factory PlaythroughNotePageVisualState.add() = _add;
  const factory PlaythroughNotePageVisualState.edit(PlaythroughNote note) = _edit;
}
