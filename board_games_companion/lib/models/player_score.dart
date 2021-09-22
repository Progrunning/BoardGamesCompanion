import 'package:flutter/foundation.dart';

import '../common/enums/enums.dart';
import 'hive/player.dart';
import 'hive/score.dart';

class PlayerScore with ChangeNotifier {
  PlayerScore(this._player, this._score);

  final Player _player;

  Player get player => _player;

  final Score _score;
  Score get score => _score;

  int _place;
  int get place => _place;

  MedalEnum _medal;
  MedalEnum get medal => _medal;

  Future<bool> updatePlayerScore(String score) async {
    if (score?.isEmpty ?? true) {
      return false;
    }

    _score.value = score;

    notifyListeners();

    return true;
  }

  Future<void> updatePlayerPlace(int place) async {
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
