// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../models/hive/playthrough_note.dart';
import 'playthrough_note_page_visual_states.dart';

part 'playthrough_note_view_model.g.dart';

@injectable
class PlaythroughNoteViewModel = _PlaythroughNoteViewModel with _$PlaythroughNoteViewModel;

abstract class _PlaythroughNoteViewModel with Store {
  late bool isNewNote;

  @observable
  PlaythroughNote? note;

  @computed
  bool get isNoteEmpty => note?.text.isNullOrBlank ?? false;

  @computed
  PlaythroughNotePageVisualState get visualState => isNewNote
      ? const PlaythroughNotePageVisualState.add()
      : PlaythroughNotePageVisualState.edit(note!);

  @action
  void setNote(PlaythroughNote? playthroughNote) {
    isNewNote = playthroughNote == null;
    playthroughNote ??= PlaythroughNote(
      id: const Uuid().v4(),
      text: '',
      createdAt: DateTime.now().toUtc(),
    );

    note = playthroughNote;
  }

  @action
  void updateNote(String text) {
    note = note!.copyWith(text: text);
  }
}
