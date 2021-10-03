import '../../common/enums/playthrough_status.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../stores/playthrough_store.dart';
import '../../stores/playthroughs_store.dart';

class EditPlaythoughViewModel {
  EditPlaythoughViewModel(this._playthroughStore, this._playthroughsStore);

  final PlaythroughStore _playthroughStore;
  final PlaythroughsStore _playthroughsStore;

  Playthrough? _playthrough;
  Playthrough get playthrough {
    if (_playthrough == null) {
      _playthrough = Playthrough(
        id: _playthroughStore.playthrough.id,
        boardGameId: _playthroughStore.playthrough.boardGameId,
        playerIds: _playthroughStore.playthrough.playerIds,
        scoreIds: _playthroughStore.playthrough.scoreIds,
        startDate: _playthroughStore.playthrough.startDate,
      );

      _playthrough!.endDate = _playthroughStore.playthrough.endDate;
      _playthrough!.status = _playthroughStore.playthrough.status;
      _playthrough!.isDeleted = _playthroughStore.playthrough.isDeleted;
    }

    return _playthrough!;
  }

  List<PlayerScore>? _playerScores;
  List<PlayerScore> get playerScores {
    if (_playerScores == null) {
      _playerScores = <PlayerScore>[];
      for (final PlayerScore playerScore in _playthroughStore.playerScores!) {
        final score = Score(
          id: playerScore.score!.id,
          playthroughId: playerScore.score!.playthroughId,
          playerId: playerScore.score!.playerId,
          boardGameId: playerScore.score!.boardGameId,
          value: playerScore.score!.value,
        );

        _playerScores!.add(PlayerScore(playerScore.player, score));
      }
    }

    return _playerScores!;
  }

  bool get playthoughEnded => playthrough.status == PlaythroughStatus.Finished;

  Duration get playthoughDuration =>
      (playthrough.endDate ?? DateTime.now()).difference(playthrough.startDate);

  bool isDirty() {
    bool playerScoresUpdated = false;
    final Map<String, Score?> playerScoresMap = {
      for (final PlayerScore playerScore in _playthroughStore.playerScores!)
        playerScore.player!.id: playerScore.score
    };

    for (final PlayerScore playerScore in playerScores) {
      if (playerScoresMap[playerScore.player!.id]!.value != playerScore.score!.value) {
        playerScoresUpdated = true;
        break;
      }
    }

    return playerScoresUpdated ||
        _playthroughStore.playthrough!.startDate != playthrough.startDate ||
        _playthroughStore.playthrough!.endDate != playthrough.endDate;
  }

  Future<void> stopPlaythrough() async {
    await _playthroughStore.stopPlaythrough();

    // Force refresh when next time getting the playthough
    _playthrough = null;
  }

  Future<void> saveChanges() async {
    await _playthroughStore.updatePlaythrough(playthrough, playerScores);
  }

  void updateDuration(int hoursPlayed, int minutesPlyed) {
    playthrough.endDate =
        playthrough.startDate.add(Duration(hours: hoursPlayed, minutes: minutesPlyed));
  }

  Future<void> deletePlaythrough() async {
    await _playthroughsStore.deletePlaythrough(playthrough.id);
  }
}
