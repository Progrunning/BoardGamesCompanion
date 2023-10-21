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
  Computed<bool>? _$hasUnsavedChangedComputed;

  @override
  bool get hasUnsavedChanged => (_$hasUnsavedChangedComputed ??= Computed<bool>(
          () => super.hasUnsavedChanged,
          name: '_EnterScoreViewModel.hasUnsavedChanged'))
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

  late final _$operationAtom =
      Atom(name: '_EnterScoreViewModel.operation', context: context);

  @override
  EnterScoreOperation get operation {
    _$operationAtom.reportRead();
    return super.operation;
  }

  @override
  set operation(EnterScoreOperation value) {
    _$operationAtom.reportWrite(value, super.operation, () {
      super.operation = value;
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

  late final _$_EnterScoreViewModelActionController =
      ActionController(name: '_EnterScoreViewModel', context: context);

  @override
  void updateOperation(EnterScoreOperation operation) {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.updateOperation');
    try {
      return super.updateOperation(operation);
    } finally {
      _$_EnterScoreViewModelActionController.endAction(_$actionInfo);
    }
  }

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
  void scoreZero() {
    final _$actionInfo = _$_EnterScoreViewModelActionController.startAction(
        name: '_EnterScoreViewModel.scoreZero');
    try {
      return super.scoreZero();
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
  String toString() {
    return '''
operation: ${operation},
partialScores: ${partialScores},
score: ${score},
playerName: ${playerName},
canUndo: ${canUndo},
hasUnsavedChanged: ${hasUnsavedChanged}
    ''';
  }
}
