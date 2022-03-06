import 'package:board_games_companion/mixins/board_game_aware_mixin.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../common/analytics.dart';
import '../common/hive_boxes.dart';
import '../models/hive/playthrough.dart';
import '../models/playthrough_player.dart';
import '../services/analytics_service.dart';
import '../services/playthroughs_service.dart';

@singleton
class PlaythroughsStore with ChangeNotifier, BoardGameAware {
  PlaythroughsStore(this._playthroughService, this._analyticsService);

  final PlaythroughService _playthroughService;
  final AnalyticsService _analyticsService;

  List<Playthrough> _playthroughs = <Playthrough>[];

  List<Playthrough>? get playthroughs => _playthroughs;

  Future<List<Playthrough>> loadPlaythroughs() async {
    if (boardGame == null) {
      return <Playthrough>[];
    }

    try {
      _playthroughs = await _playthroughService.retrievePlaythroughs([boardGame!.id]);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return _playthroughs;
  }

  Future<Playthrough> createPlaythrough(
    String boardGameId,
    List<PlaythroughPlayer> playthoughPlayers,
    Map<String, PlayerScore> playerScores,
    DateTime startDate,
    Duration? duration,
  ) async {
    final newPlaythrough = await _playthroughService.createPlaythrough(
      boardGameId,
      playthoughPlayers,
      playerScores,
      startDate,
      duration,
    );

    _playthroughs.add(newPlaythrough!);
    notifyListeners();

    await _analyticsService.logEvent(
      name: Analytics.CreatePlaythrough,
      parameters: <String, dynamic>{
        Analytics.BoardGameIdParameter: boardGameId,
        Analytics.NumberOfPlayersParameter: playthoughPlayers.length,
      },
    );

    return newPlaythrough;
  }

  Future<bool> updatePlaythrough(Playthrough? playthrough) async {
    if (playthrough?.id.isEmpty ?? true) {
      return false;
    }

    try {
      final updateSuceeded = await _playthroughService.updatePlaythrough(playthrough!);
      if (updateSuceeded) {
        await loadPlaythroughs();
        notifyListeners();
        return true;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> deletePlaythrough(String playthroughId) async {
    try {
      final deleteSucceeded = await _playthroughService.deletePlaythrough(playthroughId);
      if (deleteSucceeded) {
        _playthroughs.removeWhere((p) => p.id == playthroughId);
        notifyListeners();
      }

      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  @override
  void dispose() {
    _playthroughService.closeBox(HiveBoxes.Playthroughs);
    super.dispose();
  }
}
