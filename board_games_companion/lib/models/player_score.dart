import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:flutter/foundation.dart';

class PlayerScore with ChangeNotifier {
  final Player _player;
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
  );

  void updatePlayerScore(String score, int place) {
    if ((score?.isEmpty ?? true) || place == null) {
      return;
    }

    _score.value = score;
    _place = place;

    switch (_place) {
      case 1:
        _medal = MedalEnum.Gold;
        break;
      case 2:
        _medal = MedalEnum.Silver;
        break;
      case 3:
        _medal = MedalEnum.Silver;
        break;
      default:
        _medal = null;
        break;
    }

    notifyListeners();
  }
}
