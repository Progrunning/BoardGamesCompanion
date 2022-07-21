import 'package:flutter/material.dart';

import '../../models/player_score.dart';

enum EnterScoreOperation {
  add,
  subtract,
}

class EnterScoreViewModel with ChangeNotifier {
  EnterScoreViewModel(this._playerScore) : _initialScore = _playerScore.score.valueInt;

  final int _initialScore;
  final PlayerScore _playerScore;

  int? _score;
  int get score {
    _score ??= _playerScore.score.valueInt;
    return _score!;
  }

  String? get playerName => _playerScore.player?.name;

  EnterScoreOperation _operation = EnterScoreOperation.add;
  EnterScoreOperation get operation => _operation;

  bool get canUndo => partialScores.isNotEmpty;

  bool get hasUnsavedChanged => partialScores.isNotEmpty;

  List<int> partialScores = <int>[];

  void updateOperation(EnterScoreOperation operation) {
    _operation = operation;
    notifyListeners();
  }

  void updateScore(int partialScore) {
    _score = score + partialScore;
    partialScores.add(partialScore);

    _playerScore.updatePlayerScore(_score.toString());

    notifyListeners();
  }

  void scoreZero() {
    _playerScore.updatePlayerScore(0.toString());

    notifyListeners();
  }

  void undo() {
    if (!canUndo) {
      return;
    }

    partialScores.removeLast();

    _score = _initialScore + _partialScoresSum;
    _playerScore.updatePlayerScore(_score.toString());

    notifyListeners();
  }

  int get _partialScoresSum {
    if (partialScores.isEmpty) {
      return 0;
    }

    return partialScores.reduce((a, b) => a + b);
  }
}
