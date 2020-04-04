import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class PlaythroughsStore with ChangeNotifier {
  final PlaythroughService _playthroughService;

  BoardGameDetails _selectedBoardGame;
  List<Playthrough> _playthroughs;

  PlaythroughsStore(this._playthroughService);

  BoardGameDetails get selectedBoardGame => _selectedBoardGame;

  List<Playthrough> get playthroughs => _playthroughs;

  Future<List<Playthrough>> loadPlaythroughs(
      BoardGameDetails boardGameDetails) async {
    if (boardGameDetails?.id?.isEmpty ?? true) {
      return Iterable<Playthrough>.empty();
    }

    _selectedBoardGame = boardGameDetails;

    try {
      _playthroughs = await _playthroughService
          .retrievePlaythroughs([_selectedBoardGame.id]);
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return _playthroughs ?? Iterable<Playthrough>.empty();
  }

  Future<Playthrough> createPlaythrough(
      String boardGameId, List<PlaythroughPlayer> playthoughPlayers) async {
    final newPlaythrough = await _playthroughService.createPlaythrough(
        boardGameId, playthoughPlayers);

    _playthroughs.add(newPlaythrough);
    notifyListeners();

    return newPlaythrough;
  }

  Future<bool> updatePlaythrough(Playthrough playthrough) async {
    if (playthrough?.id?.isEmpty ?? true) {
      return false;
    }

    try {
      final updateSuceeded =
          await _playthroughService.updatePlaythrough(playthrough);
      if (updateSuceeded) {
        notifyListeners();
        return true;
      }
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> deletePlaythrough(String playthroughId) async {
    try {
      final deleteSucceeded =
          await _playthroughService.deletePlaythrough(playthroughId);
      if (deleteSucceeded) {
        _playthroughs.removeWhere((p) => p.id == playthroughId);
        notifyListeners();
      }

      return deleteSucceeded;
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  @override
  void dispose() {
    _playthroughService.closeBox(HiveBoxes.Playthroughs);
    super.dispose();
  }
}
