// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enter_score_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EnterScoreViewModel on _EnterScoreViewModel, Store {
  Computed<double>? _$scoreComputed;

  @override
  double get score => (_$scoreComputed ??= Computed<double>(() => super.score,
          name: '_EnterScoreViewModel.score'))
      .value;
  Computed<String?>? _$playerNameComputed;

  @override
  String? get playerName =>
      (_$playerNameComputed ??= Computed<String?>(() => super.playerName,
              name: '_EnterScoreViewModel.playerName'))
          .value;
  Computed<bool>? _$canUndoComputed;

  @override
  bool get canUndo => (_$canUndoComputed ??= Computed<bool>(() => super.canUndo,
          name: '_EnterScoreViewModel.canUndo'))
      .value;
  Computed<bool>? _$canCommitScoreEntryComputed;

  @override
  bool get canCommitScoreEntry => (_$canCommitScoreEntryComputed ??=
          Computed<bool>(() => super.canCommitScoreEntry,
              name: '_EnterScoreViewModel.canCommitScoreEntry'))
      .value;
  Computed<bool>? _$hasScoreChangedComputed;

  @override
  bool get hasScoreChanged =>
      (_$hasScoreChangedComputed ??= Computed<bool>(() => super.hasScoreChanged,
              name: '_EnterScoreViewModel.hasScoreChanged'))
          .value;
  Computed<double>? _$previewScoreComputed;

  @override
  double get previewScore =>
      (_$previewScoreComputed ??= Computed<double>(() => super.previewScore,
              name: '_EnterScoreViewModel.previewScore'))
          .value;
  Computed<String>? _$scoreEquationComputed;

  @override
  String get scoreEquation =>
      (_$scoreEquationComputed ??= Computed<String>(() => super.scoreEquation,
              name: '_EnterScoreViewModel.scoreEquation'))
          .value;

  late final _$_playerScoreAtom =
      Atom(name: '_EnterScoreViewModel._playerScore', context: context);

  @override
  PlayerScore get _playerScore {
    _$_playerScoreAtom.reportRead();
    return super._playerScore;
  }

  @override
  set _playerScore(PlayerScore value) {
    _$_playerScoreAtom.reportWrite(value, super._playerScore, () {
      super._playerScore = value;
    });
  }

  late final _$partialScoresAtom =
      Atom(name: '_EnterScoreViewModel.partialScores', context: context);

  @override
  ObservableList<double> get partialScores {
    _$partialScoresAtom.reportRead();
    return super.partialScores;
  }

  @override
  set partialScores(ObservableList<double> value) {
    _$partialScoresAtom.reportWrite(value, super.partialScores, () {
      super.partialScores = value;
    });
  }

  late final _$scoreEntryAtom =
      Atom(name: '_EnterScoreViewModel.scoreEntry', context: context);

  @override
  String get scoreEntry {
    _$scoreEntryAtom.reportRead();
    return super.scoreEntry;
  }

  @override
  set scoreEntry(String value) {
    _$scoreEntryAtom.reportWrite(value, super.scoreEntry, () {
      super.scoreEntry = value;
    });
  }

  late final _$pendingOperatorAtom =
      Atom(name: '_EnterScoreViewModel.pendingOperator', context: context);

  @override
  ScoreOperator? get pendingOperator {
    _$pendingOperatorAtom.reportRead();
    return super.pendingOperator;
  }

  @override
  set pendingOperator(ScoreOperator? value) {
    _$pendingOperatorAtom.reportWrite(value, super.pendingOperator, () {
      super.pendingOperator = value;
    });
  }

  late final _$_EnterScoreViewModelActionController =
      ActionController(name: '_EnterScoreViewModel', context: context);

  @override
  void updateScore(double partialScore) {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.updateScore');
    try {
      return super.updateScore(partialScore);
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addInstantScore(double value) {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.addInstantScore');
    try {
      return super.addInstantScore(value);
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void appendDigit(String digit) {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.appendDigit');
    try {
      return super.appendDigit(digit);
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void backspace() {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.backspace');
    try {
      return super.backspace();
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void commitAdd() {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.commitAdd');
    try {
      return super.commitAdd();
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void commitSubtract() {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.commitSubtract');
    try {
      return super.commitSubtract();
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void undo() {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.undo');
    try {
      return super.undo();
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void close() {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.close');
    try {
      return super.close();
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
partialScores: ${partialScores},
scoreEntry: ${scoreEntry},
pendingOperator: ${pendingOperator},
score: ${score},
playerName: ${playerName},
canUndo: ${canUndo},
canCommitScoreEntry: ${canCommitScoreEntry},
hasScoreChanged: ${hasScoreChanged},
previewScore: ${previewScore},
scoreEquation: ${scoreEquation}
    ''';
  }
}
