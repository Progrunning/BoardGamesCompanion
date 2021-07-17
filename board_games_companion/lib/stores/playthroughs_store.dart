import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import '../common/analytics.dart';
import '../common/hive_boxes.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/playthrough.dart';
import '../models/playthrough_player.dart';
import '../services/analytics_service.dart';
import '../services/playthroughs_service.dart';

class PlaythroughsStore with ChangeNotifier {
  final PlaythroughService _playthroughService;
  final AnalyticsService _analyticsService;

  BoardGameDetails _selectedBoardGame;
  List<Playthrough> _playthroughs;

  PlaythroughsStore(
    this._playthroughService,
    this._analyticsService,
  );

  BoardGameDetails get selectedBoardGame => _selectedBoardGame;

  List<Playthrough> get playthroughs => _playthroughs;

  Future<List<Playthrough>> loadPlaythroughs(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails?.id?.isEmpty ?? true) {
      return List<Playthrough>();
    }

    _selectedBoardGame = boardGameDetails;

    try {
      _playthroughs = await _playthroughService.retrievePlaythroughs([_selectedBoardGame.id]);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return _playthroughs ?? List<Playthrough>();
  }

  Future<Playthrough> createPlaythrough(
    String boardGameId,
    List<PlaythroughPlayer> playthoughPlayers,
  ) async {
    final newPlaythrough = await _playthroughService.createPlaythrough(
      boardGameId,
      playthoughPlayers,
    );

    _playthroughs.add(newPlaythrough);
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

  Future<bool> updatePlaythrough(Playthrough playthrough) async {
    if (playthrough?.id?.isEmpty ?? true) {
      return false;
    }

    try {
      final updateSuceeded = await _playthroughService.updatePlaythrough(playthrough);
      if (updateSuceeded) {
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
