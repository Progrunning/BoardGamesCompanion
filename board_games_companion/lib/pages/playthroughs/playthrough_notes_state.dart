import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/hive/playthrough_note.dart';

part 'playthrough_notes_state.freezed.dart';

@freezed
class PlaythroughNotesState with _$PlaythroughNotesState {
  const factory PlaythroughNotesState.empty() = _empty;
  const factory PlaythroughNotesState.notes({
    required List<PlaythroughNote> playthroughNotes,
  }) = _notes;
}
