import 'package:flutter/material.dart';

import '../../models/player_score.dart';

enum EnterScoreOperation {
  add,
  subtract,
}

class EnterScoreViewModel with ChangeNotifier {
  EnterScoreViewModel(this.playerScore);

  final PlayerScore playerScore;

  int? _score;
  int get score {
    if (_score == null) {
      _score = playerScore.score.valueInt;
    }

    return _score!;
  }

  EnterScoreOperation _operation = EnterScoreOperation.add;
  EnterScoreOperation get operation => _operation;

  bool get canUndo => partialScores.isNotEmpty;

  List<int> partialScores = <int>[];

  void updateOperation(EnterScoreOperation operation) {
    _operation = operation;
    notifyListeners();
  }

  void updateScore(int partialScore) {
    _score = score + partialScore;
    partialScores.add(partialScore);

    notifyListeners();
  }

  void undo() {
    if (!canUndo) {
      return;
    }

    partialScores.removeLast();

    notifyListeners();
  }
}
