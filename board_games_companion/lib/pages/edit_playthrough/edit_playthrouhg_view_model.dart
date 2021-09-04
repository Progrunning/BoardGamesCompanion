
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../stores/playthrough_store.dart';

class EditPlaythoughViewModel {
  EditPlaythoughViewModel(this._playthroughStore);

  final PlaythroughStore _playthroughStore;

  Playthrough _playthrough;
  Playthrough get playthrough {
    if (_playthrough == null) {
      _playthrough = Playthrough();
      _playthrough.id = _playthroughStore.playthrough.id;
      _playthrough.boardGameId = _playthroughStore.playthrough.boardGameId;
      _playthrough.playerIds = _playthroughStore.playthrough.playerIds;
      _playthrough.scoreIds = _playthroughStore.playthrough.scoreIds;
      _playthrough.startDate = _playthroughStore.playthrough.startDate;
      _playthrough.endDate = _playthroughStore.playthrough.endDate;
      _playthrough.status = _playthroughStore.playthrough.status;
      _playthrough.isDeleted = _playthroughStore.playthrough.isDeleted;
    }

    return _playthrough;
  }

  List<PlayerScore> _playerScores;
  List<PlayerScore> get playerScores {
    if (_playerScores == null) {
      _playerScores = <PlayerScore>[];
      for (final PlayerScore playerScore in _playthroughStore.playerScores) {
        final score = Score();
        score.id = playerScore.score.id;
        score.boardGameId = playerScore.score.boardGameId;
        score.playerId = playerScore.score.playerId;
        score.playthroughId = playerScore.score.playthroughId;
        score.isDeleted = playerScore.score.isDeleted;
        score.value = playerScore.score.value;

        _playerScores.add(PlayerScore(playerScore.player, score));
      }
    }

    return _playerScores;
  }

  bool isDirty() {
    bool playerScoresUpdated = false;
    final Map<String, Score> playerScoresMap = {
      for (final PlayerScore playerScore in _playthroughStore.playerScores)
        playerScore.player.id: playerScore.score
    };

    for (final PlayerScore playerScore in playerScores) {
      if (playerScoresMap[playerScore.player.id].value != playerScore.score.value) {
        playerScoresUpdated = true;
        break;
      }
    }

    return playerScoresUpdated ||
        _playthroughStore.playthrough.startDate != playthrough.startDate ||
        _playthroughStore.playthrough.endDate != playthrough.endDate;
  }

  Future<void> saveChanges() async {
    await _playthroughStore.updatePlaythrough(playthrough, playerScores);
  }
}
