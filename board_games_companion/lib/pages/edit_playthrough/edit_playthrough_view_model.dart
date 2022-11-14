// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/playthrough_note.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthrough_details.dart';
import 'package:board_games_companion/stores/game_playthroughs_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/enums/playthrough_status.dart';

part 'edit_playthrough_view_model.g.dart';

@injectable
class EditPlaythoughViewModel = _EditPlaythoughViewModel with _$EditPlaythoughViewModel;

abstract class _EditPlaythoughViewModel with Store {
  _EditPlaythoughViewModel(this._playthroughsStore);

  late final String _playthroughId;
  final GamePlaythroughsStore _playthroughsStore;

  ValueNotifier<bool> isSpeedDialContextMenuOpen = ValueNotifier(false);

  @observable
  PlaythroughDetails? _playthroughDetailsWorkingCopy;

  PlaythroughDetails get playthroughDetailsWorkingCopy => _playthroughDetailsWorkingCopy!;

  @computed
  PlaythroughDetails get playthroughDetails =>
      _playthroughsStore.playthroughsDetails.firstWhere((pd) => pd.id == _playthroughId);

  @computed
  Playthrough get playthrough => playthroughDetailsWorkingCopy.playthrough;

  @computed
  ObservableList<PlayerScore> get playerScores =>
      playthroughDetailsWorkingCopy.playerScores.asObservable();

  @computed
  DateTime get playthroughStartTime => playthroughDetailsWorkingCopy.startDate;

  @computed
  bool get playthoughEnded => playthroughDetailsWorkingCopy.playthoughEnded;

  @computed
  Duration get playthoughDuration => (playthroughDetailsWorkingCopy.endDate ?? DateTime.now())
      .difference(playthroughDetailsWorkingCopy.startDate);

  @computed
  bool get hasNotes => playthroughDetailsWorkingCopy.notes?.isNotEmpty ?? false;

  @computed
  ObservableList<PlaythroughNote>? get notes {
    final playthroughNotes =
        List<PlaythroughNote>.from(playthroughDetailsWorkingCopy.notes ?? <PlaythroughNote>[]);

    return ObservableList.of(
        playthroughNotes..sort((noteA, noteB) => noteA.createdAt.compareTo(noteB.createdAt)));
  }

  bool get isDirty => playthroughDetailsWorkingCopy != playthroughDetails;

  @action
  void setPlaythroughId(String playthroughId) {
    _playthroughId = playthroughId;
    _playthroughDetailsWorkingCopy = playthroughDetails.copyWith();
  }

  @action
  Future<void> stopPlaythrough() async {
    final updatedPlaythrough = playthrough.copyWith(
      status: PlaythroughStatus.Finished,
      endDate: DateTime.now().toUtc(),
    );
    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy?.copyWith(playthrough: updatedPlaythrough);
    await _playthroughsStore.updatePlaythrough(_playthroughDetailsWorkingCopy);
  }

  @action
  Future<void> saveChanges() async {
    if (isDirty) {
      await _playthroughsStore.updatePlaythrough(playthroughDetailsWorkingCopy);
    }
  }

  @action
  void updateStartDate(DateTime newStartDate) {
    final updatedPlaythrough = playthrough.copyWith(
      startDate: newStartDate,
      status: PlaythroughStatus.Finished,
      endDate: newStartDate.add(playthoughDuration),
    );
    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy?.copyWith(playthrough: updatedPlaythrough);
  }

  @action
  void updateDuration(int hoursPlayed, int minutesPlyed) {
    final updatedPlaythrough = playthrough.copyWith(
        endDate:
            playthroughDetails.startDate.add(Duration(hours: hoursPlayed, minutes: minutesPlyed)));

    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy?.copyWith(playthrough: updatedPlaythrough);
  }

  @action
  void updatePlayerScore(PlayerScore playerScore, int newScore) {
    if (playerScore.score.valueInt == newScore) {
      return;
    }

    final updatedPlayerScore =
        playerScore.copyWith(score: playerScore.score.copyWith(value: newScore.toString()));
    final playerScoreIndex = playerScores.indexOf(playerScore);
    playerScores[playerScoreIndex] = updatedPlayerScore;

    _playthroughDetailsWorkingCopy =
        playthroughDetailsWorkingCopy.copyWith(playerScores: playerScores);
  }

  /// After adding/editing a note to the [PlaythroughDetails] refresh the working copy with the latest data
  @action
  void refreshNotes() {
    _playthroughDetailsWorkingCopy = _playthroughDetailsWorkingCopy!.copyWith(
        playthrough:
            _playthroughDetailsWorkingCopy!.playthrough.copyWith(notes: playthroughDetails.notes));
  }

  @action
  Future<void> deletePlaythrough() async {
    await _playthroughsStore.deletePlaythrough(playthroughDetails.id);
  }

  @action
  void deletePlaythroughNote(PlaythroughNote note) {
    final updatedPlaythroughNotes =
        List<PlaythroughNote>.from(_playthroughDetailsWorkingCopy!.notes!)..remove(note);
    _playthroughDetailsWorkingCopy = _playthroughDetailsWorkingCopy!.copyWith(
        playthrough:
            _playthroughDetailsWorkingCopy!.playthrough.copyWith(notes: updatedPlaythroughNotes));
  }
}
