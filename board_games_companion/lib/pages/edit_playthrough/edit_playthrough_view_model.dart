// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:board_games_companion/models/hive/score_game_results.dart';
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
  Map<String, ScoreTiebreakerType> get scoreTiebreakersSet {
    if (_playthroughDetailsWorkingCopy == null) {
      return {};
    }

    return {
      for (final tiedPlayerScore in _playthroughDetailsWorkingCopy!.tiedPlayerScores)
        tiedPlayerScore.id!: tiedPlayerScore.score.scoreGameResult!.tiebreakerType!
    };
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

    _playthroughDetailsWorkingCopy = playthroughDetails?.copyWith();
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
    if (!isDirty) {
      return;
    }

    await _gamePlaythroughsDetailsStore.updatePlaythrough(_playthroughDetailsWorkingCopy);
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
  void updatePlayerScore(PlayerScore playerScore, double newScore) {
    if (playerScore.score.hasScore && playerScore.score.score == newScore) {
      return;
    }

    final playerScoreIndex = playerScores.indexOf(playerScore);
    final updatedPlayerScore = playerScore.copyWith(
      score: playerScore.score.copyWith(
        scoreGameResult: playerScore.score.scoreGameResult!.copyWith(
          points: newScore.toDouble(),
        ),
      ),
    );
    playerScores[playerScoreIndex] = updatedPlayerScore;

    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: playerScores);

    if (_playthroughDetailsWorkingCopy?.finishedScoring ?? false) {
      _updatePlaceTiebreakers();
      _setPlayerPlacesBasedOnScore();
    }
    _updatePlaythroughScoresVisualState();
  }

  void _setPlayerPlacesBasedOnScore() {
    final orderedPlayerScores =
        playerScores.sortByScore(_gamePlaythroughsDetailsStore.gameGameFamily, ignorePlaces: true);

    for (var i = 0; i < orderedPlayerScores.length; i++) {
      orderedPlayerScores[i] = _updatePlayerScorePlace(orderedPlayerScores[i], i + 1);
    }

    playerScores = orderedPlayerScores.asObservable();
    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: orderedPlayerScores);
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

    Fimber.d(
      'Reording ${playerScoresWorkingCopy[currentIndex].player?.name} '
      'from place ${playerScoresWorkingCopy[currentIndex].score.scoreGameResult?.place} [index $currentIndex] '
      ', with ${playerScoresWorkingCopy[movingToIndex].player?.name} '
      ', to place ${playerScoresWorkingCopy[movingToIndex].score.scoreGameResult?.place} [index $movingToIndex] ',
    );

    playerScores[movingToIndex] =
        _updatePlayerScorePlace(playerScoresWorkingCopy[currentIndex], movingToIndex + 1);

    for (final elementIndexAffectedByReorder in elementIndexesAffectedByReorder) {
      final reorderedIndex =
          movedElementUp ? elementIndexAffectedByReorder + 1 : elementIndexAffectedByReorder - 1;
      Fimber.d('Reording affected element from $elementIndexAffectedByReorder to $reorderedIndex');
      playerScores[reorderedIndex] = _updatePlayerScorePlace(
          playerScoresWorkingCopy[elementIndexAffectedByReorder], reorderedIndex + 1);
    }

    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: playerScores);
    _updatePlaythroughScoresVisualState();
  }

  @action
  void toggleSharedPlaceTiebreaker(PlayerScore playerScore, bool sharePlace) {
    final tiedPlayerScores = playerScores
        .where((ps) => ps.score.score != null && ps.score.score == playerScore.score.score)
        .toList();
    final bestPlaceForTiedScores = tiedPlayerScores.map((ps) => ps.place!).reduce(min);

    Fimber.d(
      'Toggling ${sharePlace ? 'on' : 'off'} shared place tiebreaker for the $bestPlaceForTiedScores place',
    );

    for (final tiedPlayerScore in tiedPlayerScores) {
      final playerScoreIndex = playerScores.indexOf(tiedPlayerScore);
      // Update the tiebreaker type and set place accordingly to the tiebreaker
      playerScores[playerScoreIndex] = _updatePlayerScoreTiebreaker(
        tiedPlayerScore,
        sharePlace ? ScoreTiebreakerType.shared : ScoreTiebreakerType.place,
        sharePlace ? bestPlaceForTiedScores : playerScoreIndex + 1,
      );
    }

    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: playerScores);
    _updatePlaythroughScoresVisualState();
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
      playthroughScoresVisualState = PlaythroughScoresVisualState.finishedScoring(
        playerScores: playerScores,
        scoreTiebreakersSet: scoreTiebreakersSet,
        hasTies: _playthroughDetailsWorkingCopy!.hasTies,
      );
    } else {
      playthroughScoresVisualState = PlaythroughScoresVisualState.scoring(
        playerScores: playerScores,
      );
    }
  }

  /// Updates the [ScoreTiebreakerType] in the [ScoreGameResult] of the player's [Score]
  ///
  /// NOTE: Ensure this is called after player scores are assigned places
  void _updatePlaceTiebreakers() {
    final tiedPlayerScoresGroupedByScore = playerScores
        .toList()
        .where((ps) => ps.score.score != null)
        .groupListsBy((ps) => ps.score.score);
    if (tiedPlayerScoresGroupedByScore.isEmpty) {
      return;
    }

    final existingTiesToRemove = scoreTiebreakersSet;
    final tiedPlayerScoresCollections =
        tiedPlayerScoresGroupedByScore.values.where((ps) => ps.length > 1).toList();
    if (tiedPlayerScoresCollections.isNotEmpty) {
      final tiedPlayerScores = tiedPlayerScoresCollections.reduce((a, b) => a..addAll(b));
      for (final tiedPlayerScore in tiedPlayerScores) {
        existingTiesToRemove.remove(tiedPlayerScore.id);
        final playerScoreIndex = playerScores.indexOf(tiedPlayerScore);
        playerScores[playerScoreIndex] =
            _updatePlayerScoreTiebreaker(tiedPlayerScore, ScoreTiebreakerType.place);
      }
    }

    // Remove existing tiebrekers, if player scores are no longer tied
    if (existingTiesToRemove.isNotEmpty) {
      for (var i = 0; i < playerScores.length; i++) {
        if (existingTiesToRemove[playerScores[i].id] != null) {
          playerScores[i] = _updatePlayerScoreTiebreaker(playerScores[i], null);
        }
      }
    }

    _playthroughDetailsWorkingCopy =
        _playthroughDetailsWorkingCopy!.copyWith(playerScores: playerScores);
  }

  PlayerScore _updatePlayerScorePlace(PlayerScore playerScore, int place) {
    final scoreGameResult = playerScore.score.scoreGameResult ?? const ScoreGameResult();
    return playerScore.copyWith(
      score: playerScore.score.copyWith(
        scoreGameResult: scoreGameResult.copyWith(place: place),
      ),
    );
  }

  PlayerScore _updatePlayerScoreTiebreaker(
    PlayerScore playerScore,
    ScoreTiebreakerType? tiebreakerType, [
    int? place,
  ]) {
    final scoreGameResult = playerScore.score.scoreGameResult ?? const ScoreGameResult();
    return playerScore.copyWith(
      score: playerScore.score.copyWith(
        scoreGameResult: scoreGameResult.copyWith(
          tiebreakerType: tiebreakerType,
          place: place ?? scoreGameResult.place,
        ),
      ),
    );
  }
}
