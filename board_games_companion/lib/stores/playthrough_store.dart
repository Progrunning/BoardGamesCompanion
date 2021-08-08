import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../common/enums/enums.dart';
import '../common/enums/playthrough_status.dart';
import '../models/hive/player.dart';
import '../models/hive/playthrough.dart';
import '../models/hive/score.dart';
import '../models/player_score.dart';
import '../services/player_service.dart';
import '../services/score_service.dart';
import 'playthroughs_store.dart';

class PlaythroughStore with ChangeNotifier {
  PlaythroughStore(
    this._playerService,
    this._scoreService,
    this._playthroughStore,
  );

  static const String unknownHighscoreValue = '-';

  final PlayerService _playerService;
  final ScoreService _scoreService;
  final PlaythroughsStore _playthroughStore;

  LoadDataState _loadDataState;

  LoadDataState get loadDataState => _loadDataState;

  Playthrough _playthrough;
  Playthrough get playthrough => _playthrough;

  int _daysSinceStart;
  int get daysSinceStart => _daysSinceStart;

  List<Score> _scores;
  List<Score> get scores => _scores;

  List<Player> _players;
  List<Player> get players => _players;

  List<PlayerScore> _playerScores;
  List<PlayerScore> get playerScores => _playerScores;

  Future<void> loadPlaythrough(Playthrough playthrough) async {
    _loadDataState = LoadDataState.Loading;

    if (playthrough?.id?.isEmpty ?? true) {
      _loadDataState = LoadDataState.Error;
      return;
    }

    final nowUtc = DateTime.now().toUtc();
    _playthrough = playthrough;
    _daysSinceStart = nowUtc.difference(_playthrough.startDate).inDays;

    try {
      _scores = await _scoreService.retrieveScores([_playthrough.id]);
      _players = await _playerService.retrievePlayers(_playthrough.playerIds);

      _playerScores = _players.map((p) {
        final score = _scores.firstWhere(
          (s) => s.playerId == p.id,
          orElse: () => null,
        );

        return PlayerScore(
          p,
          score,
          _scoreService,
        );
      }).toList();

      _loadDataState = LoadDataState.Loaded;
    } catch (e, stack) {
      _loadDataState = LoadDataState.Error;
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    notifyListeners();
  }

  Future<bool> stopPlaythrough() async {
    final oldStatus = playthrough.status;

    playthrough.status = PlaythroughStatus.Finished;
    playthrough.endDate = DateTime.now().toUtc();

    final updateSucceeded = await _playthroughStore.updatePlaythrough(playthrough);
    if (!updateSucceeded) {
      playthrough.status = oldStatus;
      playthrough.endDate = null;
      return false;
    }

    notifyListeners();

    return true;
  }
}
