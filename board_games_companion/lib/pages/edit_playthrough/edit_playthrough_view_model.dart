// ignore_for_file: library_private_types_in_public_api

import 'package:collection/collection.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/enums/game_classification.dart';
import '../../common/enums/playthrough_status.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/hive/player.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/playthrough_note.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_details.dart';
import '../../stores/game_playthroughs_details_store.dart';
import 'edit_playthrough_page_visual_states.dart';
import 'playthrough_scores_visual_state.dart';

part 'edit_playthrough_view_model.g.dart';

@injectable
class EditPlaythoughViewModel = _EditPlaythoughViewModel with _$EditPlaythoughViewModel;

abstract class _EditPlaythoughViewModel with Store {
  _EditPlaythoughViewModel(this._gamePlaythroughsDetailsStore);

  final GamePlaythroughsDetailsStore _gamePlaythroughsDetailsStore;

  late final String _playthroughId;

  ValueNotifier<bool> isSpeedDialContextMenuOpen = ValueNotifier(false);

  @observable
  PlaythroughScoresVisualState playthroughScoresVisualState =
      const PlaythroughScoresVisualState.init();

  @observable
  EditPlaythroughPageVisualStates editPlaythroughPageVisualState =
      const EditPlaythroughPageVisualStates.init();

  @observable
  PlaythroughDetails? _playthroughDetailsWorkingCopy;

  /// Creating a separate "copy" of player scores to ensure we can easily update (i.e. [ObservableList])
  /// the player list without having to re-render the entire list in the UI whenever there's an update to it.
  /// It's especially important when reordering the list to avoid flickering effect.
  ///
  /// Whenever there's an update to the any UI visible properties (e.g. score or ordering) there is a need to
  /// update this collection manually.
  @observable
  ObservableList<PlayerScore> playerScores = <PlayerScore>[].asObservable();

  @computed
  Map<String, PlayerScore> get tiedPlayerScoresMap {
    final playerScoresGrouped = playerScores
        .toList()
        .where((ps) => ps.score.value != null)
        .groupListsBy((ps) => ps.score.value);
    if (playerScoresGrouped.isEmpty) {
      return {};
    }

    final tiedPlayerScoresCollections =
        playerScoresGrouped.values.where((ps) => ps.length > 1).toList();
    if (tiedPlayerScoresCollections.isEmpty) {
      return {};
    }

    final tiedPlayerScores = tiedPlayerScoresCollections.reduce((a, b) => a..addAll(b));
    return {for (final tiedPlayerScore in tiedPlayerScores) tiedPlayerScore.id!: tiedPlayerScore};
  }

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
  CooperativeGameResult? get cooperativeGameResult =>
      playerScores.first.score.noScoreGameResult?.cooperativeGameResult;

  bool get isDirty => _playthroughDetailsWorkingCopy != playthroughDetails;

  @action
  void setPlaythroughId(String playthroughId) {
    _playthroughId = playthroughId;

    _playthroughDetailsWorkingCopy =
        playthroughDetails?.copyWith(playerScores: playthroughDetails!.playerScores);
    playerScores.addAll(_playthroughDetailsWorkingCopy!.playerScores);
    _updateEditPlaythroughPageVisualState();
    _updatePlaythroughScoresVisualState();
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

    _updatePlaythroughScoresVisualState();
  }

  @action
  void orderPlayerScoresByScore() {
    final orderedPlayerScore = playerScores
      ..sortByScore(_gamePlaythroughsDetailsStore.gameGameFamily);

    for (var i = 0; i < orderedPlayerScore.length; i++) {
      orderedPlayerScore[i] = orderedPlayerScore[i].copyWith(place: i + 1);
    }

    playerScores = orderedPlayerScore.asObservable();
    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: orderedPlayerScore);
  }

  @action
  void reorderPlayerScores(int currentIndex, int movingToIndex) {
    var elementIndexesAffectedByReorder = <int>[];
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
    playerScores[movingToIndex] =
        playerScoresWorkingCopy[currentIndex].copyWith(place: movingToIndex + 1);

    for (final elementIndexAffectedByReorder in elementIndexesAffectedByReorder) {
      final reorderedIndex =
          movedElementUp ? elementIndexAffectedByReorder + 1 : elementIndexAffectedByReorder - 1;
      Fimber.d('Reording affected element from $elementIndexAffectedByReorder to $reorderedIndex');
      playerScores[reorderedIndex] = playerScoresWorkingCopy[elementIndexAffectedByReorder]
          .copyWith(place: reorderedIndex + 1);
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

  void _updateEditPlaythroughPageVisualState() {
    switch (_playthroughDetailsWorkingCopy!.playerScoreBasedGameClassification) {
      case GameClassification.Score:
        editPlaythroughPageVisualState = EditPlaythroughPageVisualStates.editScoreGame(
          gameFamily: _gamePlaythroughsDetailsStore.gameGameFamily,
        );
        break;
      case GameClassification.NoScore:
        editPlaythroughPageVisualState = EditPlaythroughPageVisualStates.editNoScoreGame(
          gameFamily: _gamePlaythroughsDetailsStore.gameGameFamily,
        );
        break;
    }
  }

  void _updatePlaythroughScoresVisualState() {
    if (_playthroughDetailsWorkingCopy!.finishedScoring) {
      orderPlayerScoresByScore();
      playthroughScoresVisualState = PlaythroughScoresVisualState.finishedScoring(
        tiedPlayerScoresMap: tiedPlayerScoresMap,
        hasTies: _playthroughDetailsWorkingCopy!.hasTies,
      );
    } else {
      playthroughScoresVisualState = const PlaythroughScoresVisualState.scoring();
    }
  }
}
