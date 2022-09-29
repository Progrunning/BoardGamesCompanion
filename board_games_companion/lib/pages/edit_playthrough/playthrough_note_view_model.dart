// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'playthrough_note_view_model.g.dart';

@injectable
class PlaythroughNoteViewModel = _PlaythroughNoteViewModel with _$PlaythroughNoteViewModel;

abstract class _PlaythroughNoteViewModel with Store {
  _PlaythroughNoteViewModel(this._playthroughService);

  final PlaythroughService _playthroughService;

  Playthrough? _playthrough;

  // TODO Make the note to be an entity (separate class)
  @observable
  String? note;

  @action
  void setNote(String value) => note = value;

  @action
  void setPlaythrough(Playthrough value) => _playthrough = value;

  @action
  Future<void> addNote(String value) async {
    // TODO Implement
    // final newPlaythrough = _playthrough?.copyWith()
    // _playthroughService.updatePlaythrough(playthrough);
  }
}
