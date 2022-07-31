// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:mobx/mobx.dart';

import '../../common/enums/playthrough_status.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../playthroughs/playthrough_view_model.dart';

part 'edit_playthrough_view_model.g.dart';

class EditPlaythoughViewModel = _EditPlaythoughViewModel with _$EditPlaythoughViewModel;

abstract class _EditPlaythoughViewModel with Store {
  _EditPlaythoughViewModel(this._playthroughViewModel, this._playthroughsStore);

  final PlaythroughViewModel _playthroughViewModel;
  final PlaythroughsStore _playthroughsStore;

  @computed
  Playthrough get playthrough => _playthroughViewModel.playthrough;

  // MK Doing a copy of player scores to prevent data from being updated without saving
  List<PlayerScore>? _playerScores;
  List<PlayerScore> get playerScores {
    if (_playerScores == null) {
      _playerScores = <PlayerScore>[];
      for (final PlayerScore playerScore in _playthroughViewModel.playerScores!) {
        final score = Score(
          id: playerScore.score.id,
          playerId: playerScore.score.playerId,
          boardGameId: playerScore.score.boardGameId,
        );

        score.value = playerScore.score.value;
        score.playthroughId = playerScore.score.playthroughId;

        _playerScores!.add(PlayerScore(playerScore.player, score));
      }
    }

    return _playerScores!;
  }

  @computed
  bool get playthoughEnded => playthrough.status == PlaythroughStatus.Finished;

  @computed
  Duration get playthoughDuration =>
      (playthrough.endDate ?? DateTime.now()).difference(playthrough.startDate);

  bool isDirty() {
    bool playerScoresUpdated = false;
    final Map<String, Score?> playerScoresMap = {
      for (final PlayerScore playerScore in _playthroughViewModel.playerScores!)
        playerScore.player!.id: playerScore.score
    };

    for (final PlayerScore playerScore in playerScores) {
      if (playerScoresMap[playerScore.player!.id]!.value != playerScore.score.value) {
        playerScoresUpdated = true;
        break;
      }
    }

    return playerScoresUpdated ||
        _playthroughViewModel.playthrough.startDate != playthrough.startDate ||
        _playthroughViewModel.playthrough.endDate != playthrough.endDate;
  }

  @action
  Future<void> stopPlaythrough() async {
    await _playthroughViewModel.stopPlaythrough();

    // ! Ensure editing disabled before it stops
    // Force refresh when next time getting the playthough
    // _playthrough = null;
  }

  @action
  Future<void> saveChanges() async {
    await _playthroughViewModel.updatePlaythrough(playthrough, playerScores);
  }

  @action
  void updateDuration(int hoursPlayed, int minutesPlyed) {
    playthrough.endDate =
        playthrough.startDate.add(Duration(hours: hoursPlayed, minutes: minutesPlyed));
  }

  @action
  Future<void> deletePlaythrough() async {
    await _playthroughsStore.deletePlaythrough(playthrough.id);
  }
}
