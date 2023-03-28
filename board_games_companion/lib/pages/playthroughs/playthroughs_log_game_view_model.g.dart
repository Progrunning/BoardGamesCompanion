// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_log_game_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsLogGameViewModel on _PlaythroughsLogGameViewModel, Store {
  Computed<String>? _$boardGameIdComputed;

  @override
  String get boardGameId =>
      (_$boardGameIdComputed ??= Computed<String>(() => super.boardGameId,
              name: '_PlaythroughsLogGameViewModel.boardGameId'))
          .value;
  Computed<bool>? _$anyPlayerSelectedComputed;

  @override
  bool get anyPlayerSelected => (_$anyPlayerSelectedComputed ??= Computed<bool>(
          () => super.anyPlayerSelected,
          name: '_PlaythroughsLogGameViewModel.anyPlayerSelected'))
      .value;
  Computed<bool>? _$hasAnyPlayersComputed;

  @override
  bool get hasAnyPlayers =>
      (_$hasAnyPlayersComputed ??= Computed<bool>(() => super.hasAnyPlayers,
              name: '_PlaythroughsLogGameViewModel.hasAnyPlayers'))
          .value;
  Computed<List<PlaythroughPlayer>>? _$_selectedPlaythroughPlayersComputed;

  @override
  List<PlaythroughPlayer> get _selectedPlaythroughPlayers =>
      (_$_selectedPlaythroughPlayersComputed ??= Computed<
                  List<PlaythroughPlayer>>(
              () => super._selectedPlaythroughPlayers,
              name:
                  '_PlaythroughsLogGameViewModel._selectedPlaythroughPlayers'))
          .value;
  Computed<GameClassification>? _$gameClassificationComputed;

  @override
  GameClassification get gameClassification => (_$gameClassificationComputed ??=
          Computed<GameClassification>(() => super.gameClassification,
              name: '_PlaythroughsLogGameViewModel.gameClassification'))
      .value;

  late final _$playerScoresAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.playerScores', context: context);

  @override
  ObservableMap<String, PlayerScore> get playerScores {
    _$playerScoresAtom.reportRead();
    return super.playerScores;
  }

  @override
  set playerScores(ObservableMap<String, PlayerScore> value) {
    _$playerScoresAtom.reportWrite(value, super.playerScores, () {
      super.playerScores = value;
    });
  }

  late final _$playthroughDateAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.playthroughDate', context: context);

  @override
  DateTime get playthroughDate {
    _$playthroughDateAtom.reportRead();
    return super.playthroughDate;
  }

  @override
  set playthroughDate(DateTime value) {
    _$playthroughDateAtom.reportWrite(value, super.playthroughDate, () {
      super.playthroughDate = value;
    });
  }

  late final _$playthroughDurationAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.playthroughDuration',
      context: context);

  @override
  Duration get playthroughDuration {
    _$playthroughDurationAtom.reportRead();
    return super.playthroughDuration;
  }

  @override
  set playthroughDuration(Duration value) {
    _$playthroughDurationAtom.reportWrite(value, super.playthroughDuration, () {
      super.playthroughDuration = value;
    });
  }

  late final _$logGameStepAtom =
      Atom(name: '_PlaythroughsLogGameViewModel.logGameStep', context: context);

  @override
  int get logGameStep {
    _$logGameStepAtom.reportRead();
    return super.logGameStep;
  }

  @override
  set logGameStep(int value) {
    _$logGameStepAtom.reportWrite(value, super.logGameStep, () {
      super.logGameStep = value;
    });
  }

  late final _$futureLoadPlaythroughPlayersAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.futureLoadPlaythroughPlayers',
      context: context);

  @override
  ObservableFuture<void>? get futureLoadPlaythroughPlayers {
    _$futureLoadPlaythroughPlayersAtom.reportRead();
    return super.futureLoadPlaythroughPlayers;
  }

  @override
  set futureLoadPlaythroughPlayers(ObservableFuture<void>? value) {
    _$futureLoadPlaythroughPlayersAtom
        .reportWrite(value, super.futureLoadPlaythroughPlayers, () {
      super.futureLoadPlaythroughPlayers = value;
    });
  }

  late final _$playthroughPlayersAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.playthroughPlayers',
      context: context);

  @override
  ObservableList<PlaythroughPlayer> get playthroughPlayers {
    _$playthroughPlayersAtom.reportRead();
    return super.playthroughPlayers;
  }

  @override
  set playthroughPlayers(ObservableList<PlaythroughPlayer> value) {
    _$playthroughPlayersAtom.reportWrite(value, super.playthroughPlayers, () {
      super.playthroughPlayers = value;
    });
  }

  late final _$cooperativeGameResultAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.cooperativeGameResult',
      context: context);

  @override
  CooperativeGameResult? get cooperativeGameResult {
    _$cooperativeGameResultAtom.reportRead();
    return super.cooperativeGameResult;
  }

  @override
  set cooperativeGameResult(CooperativeGameResult? value) {
    _$cooperativeGameResultAtom.reportWrite(value, super.cooperativeGameResult,
        () {
      super.cooperativeGameResult = value;
    });
  }

  late final _$playthroughTimelineAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.playthroughTimeline',
      context: context);

  @override
  PlaythroughTimeline get playthroughTimeline {
    _$playthroughTimelineAtom.reportRead();
    return super.playthroughTimeline;
  }

  @override
  set playthroughTimeline(PlaythroughTimeline value) {
    _$playthroughTimelineAtom.reportWrite(value, super.playthroughTimeline, () {
      super.playthroughTimeline = value;
    });
  }

  late final _$createPlaythroughAsyncAction = AsyncAction(
      '_PlaythroughsLogGameViewModel.createPlaythrough',
      context: context);

  @override
  Future<PlaythroughDetails?> createPlaythrough(String boardGameId) {
    return _$createPlaythroughAsyncAction
        .run(() => super.createPlaythrough(boardGameId));
  }

  late final _$_PlaythroughsLogGameViewModelActionController =
      ActionController(name: '_PlaythroughsLogGameViewModel', context: context);

  @override
  void selectPlayer(PlaythroughPlayer playthroughPlayer) {
    final _$actionInfo = _$_PlaythroughsLogGameViewModelActionController
        .startAction(name: '_PlaythroughsLogGameViewModel.selectPlayer');
    try {
      return super.selectPlayer(playthroughPlayer);
    } finally {
      _$_PlaythroughsLogGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deselectPlayer(PlaythroughPlayer playthroughPlayer) {
    final _$actionInfo = _$_PlaythroughsLogGameViewModelActionController
        .startAction(name: '_PlaythroughsLogGameViewModel.deselectPlayer');
    try {
      return super.deselectPlayer(playthroughPlayer);
    } finally {
      _$_PlaythroughsLogGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadPlaythroughPlayers() {
    final _$actionInfo =
        _$_PlaythroughsLogGameViewModelActionController.startAction(
            name: '_PlaythroughsLogGameViewModel.loadPlaythroughPlayers');
    try {
      return super.loadPlaythroughPlayers();
    } finally {
      _$_PlaythroughsLogGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePlayerScore(PlayerScore playerScore, int newScore) {
    final _$actionInfo = _$_PlaythroughsLogGameViewModelActionController
        .startAction(name: '_PlaythroughsLogGameViewModel.updatePlayerScore');
    try {
      return super.updatePlayerScore(playerScore, newScore);
    } finally {
      _$_PlaythroughsLogGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCooperativeGameResult(
      CooperativeGameResult cooperativeGameResult) {
    final _$actionInfo =
        _$_PlaythroughsLogGameViewModelActionController.startAction(
            name: '_PlaythroughsLogGameViewModel.updateCooperativeGameResult');
    try {
      return super.updateCooperativeGameResult(cooperativeGameResult);
    } finally {
      _$_PlaythroughsLogGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlaythroughTimeline(PlaythroughTimeline playthroughTimeline) {
    final _$actionInfo =
        _$_PlaythroughsLogGameViewModelActionController.startAction(
            name: '_PlaythroughsLogGameViewModel.setPlaythroughTimeline');
    try {
      return super.setPlaythroughTimeline(playthroughTimeline);
    } finally {
      _$_PlaythroughsLogGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
playerScores: ${playerScores},
playthroughDate: ${playthroughDate},
playthroughDuration: ${playthroughDuration},
logGameStep: ${logGameStep},
futureLoadPlaythroughPlayers: ${futureLoadPlaythroughPlayers},
playthroughPlayers: ${playthroughPlayers},
cooperativeGameResult: ${cooperativeGameResult},
playthroughTimeline: ${playthroughTimeline},
boardGameId: ${boardGameId},
anyPlayerSelected: ${anyPlayerSelected},
hasAnyPlayers: ${hasAnyPlayers},
gameClassification: ${gameClassification}
    ''';
  }
}
