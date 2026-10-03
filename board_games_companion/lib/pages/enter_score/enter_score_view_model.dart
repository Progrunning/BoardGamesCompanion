// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:mobx/mobx.dart';

import '../../models/player_score.dart';

part 'enter_score_view_model.g.dart';

class EnterScoreViewModel = _EnterScoreViewModel with _$EnterScoreViewModel;

/// The sign a typed number carries. Calculator order: the operator is chosen before its number,
/// not after it, so it also labels the key that chooses it.
enum ScoreOperator {
  add('+'),

  /// U+2212, not an ASCII hyphen - the keypad key and the equation share this glyph.
  subtract('−');

  const ScoreOperator(this.symbol);

  final String symbol;

  int get sign => this == subtract ? -1 : 1;
}

abstract class _EnterScoreViewModel with Store {
  _EnterScoreViewModel(this._playerScore) : _initialScore = _playerScore.score.score ?? 0;

  /// A layout guard against a stuck key rather than a validation rule - it bounds a single
  /// score entry, not the total, which stays unbounded and may go negative.
  static const int maxScoreEntryDigits = 6;

  final double _initialScore;

  @observable
  PlayerScore _playerScore;

  @observable
  ObservableList<double> partialScores = <double>[].asObservable();

  @observable
  String scoreEntry = '';

  /// The operator that signs the number being typed. A sign key commits whatever is pending and
  /// then governs the next entry, so pressing one on an empty entry only chooses that sign.
  /// Null means no sign key has been pressed yet, which keeps the equation from opening on a
  /// dangling operator - an unsigned first number is an addition.
  @observable
  ScoreOperator? pendingOperator;

  @computed
  double get score => _playerScore.score.score ?? 0;

  @computed
  String? get playerName => _playerScore.player?.name;

  @computed
  bool get canUndo => partialScores.isNotEmpty;

  @computed
  bool get canCommitScoreEntry => _scoreEntryValue != 0;

  /// Whether the score, pending entry included, differs from the one the sheet opened with.
  /// Entries that cancel each other out leave nothing to confirm.
  @computed
  bool get hasScoreChanged => previewScore != _initialScore;

  /// The score with the number being typed folded in, so the header previews where the pending
  /// entry lands.
  @computed
  double get previewScore => score + _pendingTerm;

  /// The calculator tape: every committed term followed by the number being typed, each carrying
  /// the sign it was entered with. Neither the score walked in with nor the result appears - the
  /// header carries the total. Empty until the player touches a key, and it ends on a trailing
  /// operator while one is waiting for its number.
  @computed
  String get scoreEquation {
    final terms = <String>[
      for (final partialScore in partialScores)
        '${_operatorFor(partialScore).symbol} ${partialScore.abs().toStringAsFixed(0)}',
    ];

    if (scoreEntry.isNotEmpty || pendingOperator != null) {
      final operator = (pendingOperator ?? ScoreOperator.add).symbol;
      terms.add(scoreEntry.isEmpty ? operator : '$operator $scoreEntry');
    }

    return terms.join(' ');
  }

  @action
  void updateScore(double partialScore) {
    final newScore = score + partialScore;
    partialScores = ObservableList.of(partialScores..add(partialScore));

    _updatePlayerScore(newScore);
  }

  @action
  void appendDigit(String digit) {
    if (scoreEntry.length >= maxScoreEntryDigits) {
      return;
    }

    scoreEntry = scoreEntry == '0' ? digit : scoreEntry + digit;
  }

  @action
  void backspace() {
    if (scoreEntry.isEmpty) {
      return;
    }

    scoreEntry = scoreEntry.substring(0, scoreEntry.length - 1);
  }

  @action
  void commitAdd() => _applyOperator(ScoreOperator.add);

  @action
  void commitSubtract() => _applyOperator(ScoreOperator.subtract);

  @action
  void undo() {
    if (!canUndo) {
      return;
    }

    partialScores = ObservableList.of(partialScores..removeLast());

    _updatePlayerScore(_initialScore + _partialScoresSum);
  }

  /// Commits whatever is pending and settles the score, whether the sheet was dismissed with
  /// confirm or swiped away. Both call sites read [score] once the sheet closes, so skipping this
  /// on either route would lose the entry or leave the score unset.
  @action
  void close() {
    _commitScoreEntry();

    // MK In case score was not entered assume 0 was the score
    if (score == 0) {
      _updatePlayerScore(0);
    }
  }

  void _applyOperator(ScoreOperator operator) {
    _commitScoreEntry();

    pendingOperator = operator;
  }

  void _commitScoreEntry() {
    if (canCommitScoreEntry) {
      updateScore(_pendingTerm);
    }

    scoreEntry = '';
  }

  /// The number being typed, signed by [pendingOperator]. Addition is the default.
  double get _pendingTerm => (pendingOperator ?? ScoreOperator.add).sign * _scoreEntryValue;

  double get _scoreEntryValue => scoreEntry.isEmpty ? 0 : double.parse(scoreEntry);

  ScoreOperator _operatorFor(double partialScore) =>
      partialScore < 0 ? ScoreOperator.subtract : ScoreOperator.add;

  void _updatePlayerScore(double? score) {
    final scoreGameResult = _playerScore.score.scoreGameResult ?? const ScoreGameResult();
    _playerScore = _playerScore.copyWith(
      score: _playerScore.score.copyWith(
        scoreGameResult: scoreGameResult.copyWith(points: score),
      ),
    );
  }

  double get _partialScoresSum {
    if (partialScores.isEmpty) {
      return 0;
    }

    return partialScores.reduce((a, b) => a + b);
  }
}
