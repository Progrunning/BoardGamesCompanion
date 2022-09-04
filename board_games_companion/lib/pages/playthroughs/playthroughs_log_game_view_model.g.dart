// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_log_game_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsLogGameViewModel on _PlaythroughsLogGameViewModel, Store {
  Computed<ObservableList<PlaythroughPlayer>>? _$playthroughPlayersComputed;

  @override
  ObservableList<PlaythroughPlayer> get playthroughPlayers =>
      (_$playthroughPlayersComputed ??=
              Computed<ObservableList<PlaythroughPlayer>>(
                  () => super.playthroughPlayers,
                  name: '_PlaythroughsLogGameViewModel.playthroughPlayers'))
          .value;
  Computed<BoardGameDetails>? _$boardGameComputed;

  @override
  BoardGameDetails get boardGame =>
      (_$boardGameComputed ??= Computed<BoardGameDetails>(() => super.boardGame,
              name: '_PlaythroughsLogGameViewModel.boardGame'))
          .value;
  Computed<bool>? _$anyPlayerSelectedComputed;

  @override
  bool get anyPlayerSelected => (_$anyPlayerSelectedComputed ??= Computed<bool>(
          () => super.anyPlayerSelected,
          name: '_PlaythroughsLogGameViewModel.anyPlayerSelected'))
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

  late final _$playthroughStartTimeAtom = Atom(
      name: '_PlaythroughsLogGameViewModel.playthroughStartTime',
      context: context);

  @override
  PlaythroughStartTime get playthroughStartTime {
    _$playthroughStartTimeAtom.reportRead();
    return super.playthroughStartTime;
  }

  @override
  set playthroughStartTime(PlaythroughStartTime value) {
    _$playthroughStartTimeAtom.reportWrite(value, super.playthroughStartTime,
        () {
      super.playthroughStartTime = value;
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
  void setLogGameStep(int value) {
    final _$actionInfo = _$_PlaythroughsLogGameViewModelActionController
        .startAction(name: '_PlaythroughsLogGameViewModel.setLogGameStep');
    try {
      return super.setLogGameStep(value);
    } finally {
      _$_PlaythroughsLogGameViewModelActionController.endAction(_$actionInfo);
    }
  }

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
  String toString() {
    return '''
playthroughDate: ${playthroughDate},
playthroughDuration: ${playthroughDuration},
playthroughStartTime: ${playthroughStartTime},
logGameStep: ${logGameStep},
futureLoadPlaythroughPlayers: ${futureLoadPlaythroughPlayers},
playthroughPlayers: ${playthroughPlayers},
boardGame: ${boardGame},
anyPlayerSelected: ${anyPlayerSelected}
    ''';
  }
}
