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

  /// Creating a separate "copy" of player scores to ensure we can easily update (i.e. [ObservableList])
  /// the player list without having to re-render the entire list in the UI whenever there's an update to it.
  /// It's especially important when reordering the list.
  @observable
  ObservableList<PlayerScore> playerScores = <PlayerScore>[].asObservable();

  @computed
  PlaythroughDetails? get playthroughDetails => _gamePlaythroughsDetailsStore.playthroughsDetails
      .firstWhereOrNull((pd) => pd.id == _playthroughId);

  @computed
  Playthrough get playthrough => _playthroughDetailsWorkingCopy!.playthrough;

  @computed
  ObservableList<Player> get players => _playthroughDetailsWorkingCopy!.playerScores
      .where((playerScore) => playerScore.player != null)
      .map((playerScore) => playerScore.player!)
      .toList()
      .asObservable();

  @computed
  DateTime get playthroughStartTime => _playthroughDetailsWorkingCopy!.startDate;

  @computed
  bool get playthoughEnded => _playthroughDetailsWorkingCopy!.playthoughEnded;

  @computed
  Duration get playthoughDuration => (_playthroughDetailsWorkingCopy!.endDate ?? DateTime.now())
      .difference(_playthroughDetailsWorkingCopy!.startDate);

  @computed
  bool get hasNotes => _playthroughDetailsWorkingCopy!.notes?.isNotEmpty ?? false;

  @computed
  ObservableList<PlaythroughNote>? get notes {
    final playthroughNotes =
        List<PlaythroughNote>.from(_playthroughDetailsWorkingCopy!.notes ?? <PlaythroughNote>[]);

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

  bool get isDirty => _playthroughDetailsWorkingCopy != playthroughDetails;

  @action
  void setPlaythroughId(String playthroughId) {
    _playthroughId = playthroughId;

    _playthroughDetailsWorkingCopy =
        playthroughDetails?.copyWith(playerScores: playthroughDetails!.playerScores);
    playerScores.addAll(_playthroughDetailsWorkingCopy!.playerScores);
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
      await _gamePlaythroughsDetailsStore.updatePlaythrough(_playthroughDetailsWorkingCopy);
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
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: playerScores);
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
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: orderedPlayerScore);
  }

  // TODO
  // - Need to order scores by score before editing
  // - Allow only moving scores that are tied
  // - Toggle score moving mode for better control
  // - Create TiebreakerResult or perhaps use place property?
  @action
  void reorderPlayerScores(int currentIndex, int movingToIndex) {
    var elementIndexesAffectedByReorder = <int>[];
    // final distanceBetweenElements = (currentIndex - movingToIndex).abs();
    // final isMovingNeighbouringElements = distanceBetweenElements <= 1;
    final movedElementUp = movingToIndex < currentIndex;
    if (movedElementUp) {
      // For example
      // 3 -> 0
      // ------
      // 0 -> 1
      // 1 -> 2
      // 2 -> 3
      final numberOfAffectedElements = currentIndex - movingToIndex;
      elementIndexesAffectedByReorder = List.generate(
        numberOfAffectedElements,
        (int index) => movingToIndex + index,
        growable: false,
      );
    } else {
      // For example
      // 0 -> 3
      // ------
      // 3 -> 2
      // 2 -> 1
      // 1 -> 0
      final numberOfAffectedElements = movingToIndex - currentIndex;
      elementIndexesAffectedByReorder = List.generate(
        numberOfAffectedElements,
        (int index) => movingToIndex - index,
        growable: false,
      );
    }

    // Making working copy of player scores to capture the list sort before reordering
    final playerScoresWorkingCopy = playerScores.toList();

    Fimber.d('Reording dragged element from $currentIndex to $movingToIndex');
    playerScores[movingToIndex] = playerScoresWorkingCopy[currentIndex];

    for (final elementIndexAffectedByReorder in elementIndexesAffectedByReorder) {
      final reorderedIndex =
          movedElementUp ? elementIndexAffectedByReorder + 1 : elementIndexAffectedByReorder - 1;
      Fimber.d('Reording affected element from $elementIndexAffectedByReorder to $reorderedIndex');
      playerScores[reorderedIndex] = playerScoresWorkingCopy[elementIndexAffectedByReorder];
    }

    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: playerScores);
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
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: updatedPlayerScores);
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
