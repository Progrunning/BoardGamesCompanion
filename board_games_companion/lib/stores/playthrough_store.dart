import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

import '../common/enums/playthrough_status.dart';
import '../models/hive/player.dart';
import '../models/hive/playthrough.dart';
import '../models/hive/score.dart';
import '../models/player_score.dart';
import '../services/player_service.dart';
import '../services/score_service.dart';
import 'playthroughs_store.dart';

@injectable
class PlaythroughStore {
  PlaythroughStore(
    this._playerService,
    this._scoreService,
    this._playthroughsStore,
  );

  static const String unknownHighscoreValue = '-';

  final PlayerService _playerService;
  final ScoreService _scoreService;
  final PlaythroughsStore _playthroughsStore;

  late Playthrough _playthrough;
  Playthrough get playthrough => _playthrough;

  int? _daysSinceStart;
  int? get daysSinceStart => _daysSinceStart;

  Duration get duration {
    final nowUtc = DateTime.now().toUtc();
    final playthroughEndDate = playthrough.endDate ?? nowUtc;
    return playthroughEndDate.difference(playthrough.startDate);
  }

  List<Score>? _scores;
  List<Score>? get scores => _scores;

  List<Player>? _players;
  List<Player>? get players => _players;

  List<PlayerScore>? _playerScores;
  List<PlayerScore>? get playerScores => _playerScores;

  Future<void> loadPlaythrough(Playthrough playthrough) async {
    if (playthrough.id.isEmpty) {
      return;
    }

    final nowUtc = DateTime.now().toUtc();
    _playthrough = playthrough;
    _daysSinceStart = nowUtc.difference(_playthrough.startDate).inDays;

    try {
      _scores = await _scoreService.retrieveScores([_playthrough.id]);
      _players = await _playerService.retrievePlayers(
        playerIds: _playthrough.playerIds,
        includeDeleted: true,
      );

      _playerScores = _players!.map((p) {
        final score = _scores!.firstWhereOrNull((s) => s.playerId == p.id);
        return PlayerScore(p, score!);
      }).toList();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> updatePlaythrough(Playthrough playthrough, List<PlayerScore> playerScores) async {
    await _playthroughsStore.updatePlaythrough(playthrough);
    for (final PlayerScore playerScore in playerScores) {
      await _scoreService.addOrUpdateScore(playerScore.score);
    }

    await loadPlaythrough(playthrough);
  }

  Future<bool> stopPlaythrough() async {
    final oldStatus = playthrough.status;

    playthrough.status = PlaythroughStatus.Finished;
    playthrough.endDate = DateTime.now().toUtc();

    final updateSucceeded = await _playthroughsStore.updatePlaythrough(playthrough);
    if (!updateSucceeded) {
      playthrough.status = oldStatus;
      playthrough.endDate = null;
      return false;
    }

    return true;
  }
}
