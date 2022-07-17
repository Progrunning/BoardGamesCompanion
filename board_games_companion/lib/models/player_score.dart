import 'package:flutter/foundation.dart';

import 'hive/player.dart';
import 'hive/score.dart';

class PlayerScore with ChangeNotifier {
  PlayerScore(this._player, this._score);

  PlayerScore.withPlace(this._player, this._score, this._place);

  final Player? _player;

  Player? get player => _player;

  final Score _score;
  Score get score => _score;

  int? _place;
  int? get place => _place;

  bool updatePlayerScore(String score) {
    if (score.isEmpty) {
      return false;
    }

    _score.value = score;

    notifyListeners();

    return true;
  }
}
