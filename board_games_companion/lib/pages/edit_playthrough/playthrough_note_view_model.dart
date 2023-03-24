// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../models/hive/playthrough_note.dart';
import '../../models/playthroughs/playthrough_details.dart';
import 'playthrough_note_page_visual_states.dart';

part 'playthrough_note_view_model.g.dart';

@injectable
class PlaythroughNoteViewModel = _PlaythroughNoteViewModel with _$PlaythroughNoteViewModel;

abstract class _PlaythroughNoteViewModel with Store {
  _PlaythroughNoteViewModel(this._gamePlaythroughsDetailsStore);

  final GamePlaythroughsDetailsStore _gamePlaythroughsDetailsStore;

  PlaythroughDetails get _playthroughDetails => _gamePlaythroughsDetailsStore.playthroughsDetails
      .firstWhere((playthroughDetails) => playthroughDetails.id == _playthrough!.id);

  String? _noteId;

  @observable
  PlaythroughNote? note;

  @observable
  Playthrough? _playthrough;

  @computed
  bool get isNewNote => _noteId == null;

  @computed
  bool get isNoteEmpty => note?.text.isNullOrBlank ?? false;

  @computed
  PlaythroughNotePageVisualState get visualState => isNewNote
      ? const PlaythroughNotePageVisualState.add()
      : PlaythroughNotePageVisualState.edit(note!);

  @action
  void setNoteId(String? value) {
    _noteId = value;
    if (_noteId == null) {
      note = PlaythroughNote(
        id: const Uuid().v4(),
        text: '',
        createdAt: DateTime.now().toUtc(),
      );

      return;
    }

    note = _playthrough!.notes!.firstWhere((note) => note.id == _noteId);
  }

  @action
  void setPlaythrough(Playthrough value) => _playthrough = value;

  @action
  void updateNote(String text) {
    note = note!.copyWith(text: text);
  }

  @action
  Future<void> saveNote(String text) async {
    updateNote(text);

    final playthroughNotes = List<PlaythroughNote>.from(_playthrough!.notes ?? <PlaythroughNote>[]);
    visualState.maybeWhen(
      add: () {
        playthroughNotes.add(note!);
      },
      orElse: () {
        final noteToUpdateIndex = playthroughNotes.indexWhere((n) => n.id == _noteId);
        playthroughNotes[noteToUpdateIndex] = note!.copyWith(modifiedAt: DateTime.now().toUtc());
      },
    );

    _playthrough = _playthrough!.copyWith(notes: playthroughNotes);
    final updatedPlaythroughDetails = _playthroughDetails.copyWith(playthrough: _playthrough!);
    await _gamePlaythroughsDetailsStore.updatePlaythrough(updatedPlaythroughDetails);
  }
}
