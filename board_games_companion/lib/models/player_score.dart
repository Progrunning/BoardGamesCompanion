import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class PlayerScore with ChangeNotifier {
  final Player _player;
  final ScoreService _scoreService;

  Player get player => _player;

  final Score _score;
  Score get score => _score;

  int _place;
  int get place => _place;

  MedalEnum _medal;
  MedalEnum get medal => _medal;

  PlayerScore(
    this._player,
    this._score,
    this._scoreService,
  );

  Future<bool> updatePlayerScore(String score) async {
    if ((score?.isEmpty ?? true)) {
      return false;
    }

    _score.value = score;
  

    try {
      await _scoreService.addOrUpdateScore(_score);
      notifyListeners();
      return true;
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  void updatePlayerPlace(int place) async {
    _place = place;

    switch (_place) {
      case 1:
        _medal = MedalEnum.Gold;
        break;
      case 2:
        _medal = MedalEnum.Silver;
        break;
      case 3:
        _medal = MedalEnum.Bronze;
        break;
      default:
        _medal = null;
        break;
    }
  }
}
