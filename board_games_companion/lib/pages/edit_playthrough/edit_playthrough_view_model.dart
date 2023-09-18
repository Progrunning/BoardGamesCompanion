// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/constants.dart';
import 'package:collection/collection.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/enums/game_classification.dart';
import '../../common/enums/game_family.dart';
import '../../common/enums/playthrough_status.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/hive/player.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/playthrough_note.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_details.dart';
import '../../stores/game_playthroughs_details_store.dart';

part 'edit_playthrough_view_model.g.dart';

@injectable
class EditPlaythoughViewModel = _EditPlaythoughViewModel with _$EditPlaythoughViewModel;

abstract class _EditPlaythoughViewModel with Store {
  _EditPlaythoughViewModel(this._gamePlaythroughsDetailsStore);

  final GamePlaythroughsDetailsStore _gamePlaythroughsDetailsStore;

  late final String _playthroughId;

  ValueNotifier<bool> isSpeedDialContextMenuOpen = ValueNotifier(false);

  @observable
  PlaythroughDetails? _playthroughDetailsWorkingCopy;

  PlaythroughDetails get playthroughDetailsWorkingCopy => _playthroughDetailsWorkingCopy!;

  @computed
  PlaythroughDetails? get playthroughDetails => _gamePlaythroughsDetailsStore.playthroughsDetails
      .firstWhereOrNull((pd) => pd.id == _playthroughId);

  @computed
  Playthrough get playthrough => playthroughDetailsWorkingCopy.playthrough;

  @computed
  ObservableList<PlayerScore> get playerScores =>
      playthroughDetailsWorkingCopy.playerScores.asObservable();

  @computed
  ObservableList<Player> get players => playthroughDetailsWorkingCopy.playerScores
      .where((playerScore) => playerScore.player != null)
      .map((playerScore) => playerScore.player!)
      .toList()
      .asObservable();

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

  @computed
  GameFamily get gameFamily => _gamePlaythroughsDetailsStore.gameGameFamily;

  @computed
  GameClassification get gameClassification => _gamePlaythroughsDetailsStore.gameClassification;

  @computed
  CooperativeGameResult? get cooperativeGameResult =>
      playerScores.first.score.noScoreGameResult?.cooperativeGameResult;

  bool get isDirty => playthroughDetailsWorkingCopy != playthroughDetails;

  @action
  void setPlaythroughId(String playthroughId) {
    _playthroughId = playthroughId;

    _playthroughDetailsWorkingCopy =
        playthroughDetails?.copyWith(playerScores: playthroughDetails!.playerScores);
  }

  @action
  void setBoardGameId(String boardGameId) {
    _gamePlaythroughsDetailsStore.setBoardGameId(boardGameId);
    _gamePlaythroughsDetailsStore.loadPlaythroughsDetails();
  }

  @action
  Future<void> stopPlaythrough() async {
    final updatedPlaythrough = playthrough.copyWith(
      status: PlaythroughStatus.Finished,
      endDate: DateTime.now().toUtc(),
    );
    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy?.copyWith(playthrough: updatedPlaythrough);
    await _gamePlaythroughsDetailsStore.updatePlaythrough(_playthroughDetailsWorkingCopy);
  }

  @action
  Future<void> saveChanges() async {
    if (isDirty) {
      await _gamePlaythroughsDetailsStore.updatePlaythrough(playthroughDetailsWorkingCopy);
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
            playthroughDetails?.startDate.add(Duration(hours: hoursPlayed, minutes: minutesPlyed)));

    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy?.copyWith(playthrough: updatedPlaythrough);
  }

  @action
  void updatePlayerScore(PlayerScore playerScore, int newScore) {
    if (playerScore.score.hasScore && playerScore.score.valueInt == newScore) {
      return;
    }

    final updatedPlayerScore =
        playerScore.copyWith(score: playerScore.score.copyWith(value: newScore.toString()));
    final playerScoreIndex = playerScores.indexOf(playerScore);
    playerScores[playerScoreIndex] = updatedPlayerScore;

    _playthroughDetailsWorkingCopy =
        playthroughDetailsWorkingCopy.copyWith(playerScores: playerScores);
  }

  @action
  void orderPlayerScoresByScore() {
    final orderedPlayerScore = playerScores
      ..sort((playerScoreA, playerScoreB) {
        if (playerScoreA.score.hasScore && !playerScoreB.score.hasScore) {
          return Constants.moveAbove;
        }

        if (!playerScoreA.score.hasScore && playerScoreB.score.hasScore) {
          return Constants.moveBelow;
        }

        if (!playerScoreA.score.hasScore && !playerScoreB.score.hasScore) {
          return Constants.leaveAsIs;
        }

        return playerScoreB.score.valueInt.compareTo(playerScoreA.score.valueInt);
      });

    _playthroughDetailsWorkingCopy =
        playthroughDetailsWorkingCopy.copyWith(playerScores: orderedPlayerScore);
  }

  // TODO
  // - Need to order scores by score before editing
  // - Allow only moving scores that are tied
  // - Toggle score moving mode for better control
  // - Create TiebreakerResult or perhaps use place property?
  @action
  void reorderPlayerScores(int oldIndex, int newIndex) {
    Fimber.d('OLD $oldIndex | NEW $newIndex');

    Fimber.d('BEFORE');
    for (final playerScore in playerScores) {
      Fimber.d('${playerScore.player!.name}');
    }

    final oldElement = playerScores[oldIndex];

    playerScores[oldIndex] = playerScores[newIndex];
    playerScores[newIndex] = oldElement;

    Fimber.d('-----');
    Fimber.d('AFTER');
    for (final playerScore in playerScores) {
      Fimber.d('${playerScore.player!.name}');
    }

    // _playthroughDetailsWorkingCopy =
    //     playthroughDetailsWorkingCopy.copyWith(playerScores: playerScores);
  }

  @action
  void updateCooperativeGameResult(CooperativeGameResult cooperativeGameResult) {
    final updatedPlayerScores = <PlayerScore>[];
    for (final playerScore in playerScores) {
      final noScoreGameResult = playerScore.score.noScoreGameResult ?? const NoScoreGameResult();
      final updatedPlayerScore = playerScore.copyWith(
        score: playerScore.score.copyWith(
          noScoreGameResult:
              noScoreGameResult.copyWith(cooperativeGameResult: cooperativeGameResult),
        ),
      );
      updatedPlayerScores.add(updatedPlayerScore);
    }

    _playthroughDetailsWorkingCopy =
        playthroughDetailsWorkingCopy.copyWith(playerScores: updatedPlayerScores);
  }

  @action
  Future<void> deletePlaythrough() async {
    if (playthroughDetails == null) {
      return;
    }

    await _gamePlaythroughsDetailsStore.deletePlaythrough(playthroughDetails!.id);
  }

  @action
  void addPlaythroughNote(PlaythroughNote note) {
    final existingNotes = _playthroughDetailsWorkingCopy!.notes ?? [];

    _updatePlaythroughDetailsNotes([...existingNotes, note]);
  }

  @action
  void editPlaythroughNote(PlaythroughNote note) {
    final noteToUpdateIndex =
        _playthroughDetailsWorkingCopy!.notes?.indexWhere((n) => n.id == note.id);
    if (noteToUpdateIndex == null) {
      return;
    }

    final updatedPlaythroughNotes = _playthroughDetailsWorkingCopy!.notes!.toList();
    updatedPlaythroughNotes[noteToUpdateIndex] = note;

    _updatePlaythroughDetailsNotes(updatedPlaythroughNotes);
  }

  @action
  void deletePlaythroughNote(PlaythroughNote note) {
    final updatedPlaythroughNotes =
        List<PlaythroughNote>.from(_playthroughDetailsWorkingCopy!.notes!)..remove(note);
    _updatePlaythroughDetailsNotes(updatedPlaythroughNotes);
  }

  void _updatePlaythroughDetailsNotes(List<PlaythroughNote> notes) {
    _playthroughDetailsWorkingCopy = _playthroughDetailsWorkingCopy!
        .copyWith(playthrough: _playthroughDetailsWorkingCopy!.playthrough.copyWith(notes: notes));
  }
}
