import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/hive/playthrough_note.dart';

part 'playthrough_note_page_visual_states.freezed.dart';

@freezed
class PlaythroughNotePageVisualState with _$PlaythroughNotePageVisualState {
  const factory PlaythroughNotePageVisualState.add() = Add;
  const factory PlaythroughNotePageVisualState.edit(PlaythroughNote note) = Edit;
}
