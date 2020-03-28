import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:flutter/foundation.dart';

class PlayerScore with ChangeNotifier {
  final Player _player;
  Player get player => _player;

  final Score _score;
  Score get score => _score;

  PlayerScore(
    this._player,
    this._score,
  );
}
