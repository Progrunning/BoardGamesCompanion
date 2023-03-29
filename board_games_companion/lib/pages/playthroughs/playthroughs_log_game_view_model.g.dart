// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_log_game_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsLogGameViewModel on _PlaythroughsLogGameViewModel, Store {
  Computed<ObservableList<Player>>? _$playersComputed;

  @override
  ObservableList<Player> get players => (_$playersComputed ??=
          Computed<ObservableList<Player>>(() => super.players,
              name: '_PlaythroughsLogGameViewModel.players'))
      .value;
  Computed<String>? _$boardGameIdComputed;

  @override
  String get boardGameId =>
      (_$boardGameIdComputed ??= Computed<String>(() => super.boardGameId,
              name: '_PlaythroughsLogGameViewModel.boardGameId'))
          .value;
  Computed<GameClassification>? _$gameClassificationComputed;

  @override
  GameClassification get gameClassification => (_$gameClassificationComputed ??=
          Computed<GameClassification>(() => super.gameClassification,
              name: '_PlaythroughsLogGameViewModel.gameClassification'))
      .value;

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

  late final _$futureLoadPlayersAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.futureLoadPlayers',
      context: context);

  @override
  ObservableFuture<void>? get futureLoadPlayers {
    _$futureLoadPlayersAtom.reportRead();
    return super.futureLoadPlayers;
  }

  @override
  set futureLoadPlayers(ObservableFuture<void>? value) {
    _$futureLoadPlayersAtom.reportWrite(value, super.futureLoadPlayers, () {
      super.futureLoadPlayers = value;
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

  late final _$playersStateAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.playersState', context: context);

  @override
  PlaythroughsLogGamePlayers get playersState {
    _$playersStateAtom.reportRead();
    return super.playersState;
  }

  @override
  set playersState(PlaythroughsLogGamePlayers value) {
    _$playersStateAtom.reportWrite(value, super.playersState, () {
      super.playersState = value;
    });
  }

  late final _$createPlaythroughAsyncAction = AsyncAction(
      '_PlaythroughsLogGameViewModel.createPlaythrough',
      context: context);

  @override
  Future<PlaythroughDetails?> createPlaythrough() {
    return _$createPlaythroughAsyncAction.run(() => super.createPlaythrough());
  }

  late final _$_PlaythroughsLogGameViewModelActionController =
      ActionController(name: '_PlaythroughsLogGameViewModel', context: context);

  @override
  void loadPlayers() {
    final _$actionInfo = _$_PlaythroughsLogGameViewModelActionController
        .startAction(name: '_PlaythroughsLogGameViewModel.loadPlayers');
    try {
      return super.loadPlayers();
    } finally {
      _$_PlaythroughsLogGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPlayers(List<Player> selectedPlayers) {
    final _$actionInfo = _$_PlaythroughsLogGameViewModelActionController
        .startAction(name: '_PlaythroughsLogGameViewModel.setSelectedPlayers');
    try {
      return super.setSelectedPlayers(selectedPlayers);
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
playthroughDate: ${playthroughDate},
playthroughDuration: ${playthroughDuration},
futureLoadPlayers: ${futureLoadPlayers},
cooperativeGameResult: ${cooperativeGameResult},
playthroughTimeline: ${playthroughTimeline},
playersState: ${playersState},
players: ${players},
boardGameId: ${boardGameId},
gameClassification: ${gameClassification}
    ''';
  }
}
