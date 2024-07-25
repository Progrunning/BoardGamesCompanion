// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'players_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayersViewModel on _PlayersViewModel, Store {
  Computed<List<Player>>? _$activePlayersComputed;

  @override
  List<Player> get activePlayers => (_$activePlayersComputed ??=
          Computed<List<Player>>(() => super.activePlayers,
              name: '_PlayersViewModel.activePlayers'))
      .value;
  Computed<List<Player>>? _$deletedPlayersComputed;

  @override
  List<Player> get deletedPlayers => (_$deletedPlayersComputed ??=
          Computed<List<Player>>(() => super.deletedPlayers,
              name: '_PlayersViewModel.deletedPlayers'))
      .value;
  Computed<bool>? _$hasAnyActivePlayersComputed;

  @override
  bool get hasAnyActivePlayers => (_$hasAnyActivePlayersComputed ??=
          Computed<bool>(() => super.hasAnyActivePlayers,
              name: '_PlayersViewModel.hasAnyActivePlayers'))
      .value;
  Computed<bool>? _$hasAnyDeletedPlayersComputed;

  @override
  bool get hasAnyDeletedPlayers => (_$hasAnyDeletedPlayersComputed ??=
          Computed<bool>(() => super.hasAnyDeletedPlayers,
              name: '_PlayersViewModel.hasAnyDeletedPlayers'))
      .value;
  Computed<bool>? _$hasAnyPlayersComputed;

  @override
  bool get hasAnyPlayers =>
      (_$hasAnyPlayersComputed ??= Computed<bool>(() => super.hasAnyPlayers,
              name: '_PlayersViewModel.hasAnyPlayers'))
          .value;

  late final _$futureLoadPlayersAtom =
      Atom(name: '_PlayersViewModel.futureLoadPlayers', context: context);

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

  late final _$visualStateAtom =
      Atom(name: '_PlayersViewModel.visualState', context: context);

  @override
  PlayersVisualState get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(PlayersVisualState value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$deleteSelectedPlayersAsyncAction =
      AsyncAction('_PlayersViewModel.deleteSelectedPlayers', context: context);

  @override
  Future<void> deleteSelectedPlayers() {
    return _$deleteSelectedPlayersAsyncAction
        .run(() => super.deleteSelectedPlayers());
  }

  late final _$_PlayersViewModelActionController =
      ActionController(name: '_PlayersViewModel', context: context);

  @override
  void loadPlayers() {
    final _$actionInfo = _$_PlayersViewModelActionController.startAction(
        name: '_PlayersViewModel.loadPlayers');
    try {
      return super.loadPlayers();
    } finally {
      _$_PlayersViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleDeletePlayersMode() {
    final _$actionInfo = _$_PlayersViewModelActionController.startAction(
        name: '_PlayersViewModel.toggleDeletePlayersMode');
    try {
      return super.toggleDeletePlayersMode();
    } finally {
      _$_PlayersViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleShowDeletedPlayers() {
    final _$actionInfo = _$_PlayersViewModelActionController.startAction(
        name: '_PlayersViewModel.toggleShowDeletedPlayers');
    try {
      return super.toggleShowDeletedPlayers();
    } finally {
      _$_PlayersViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
futureLoadPlayers: ${futureLoadPlayers},
visualState: ${visualState},
activePlayers: ${activePlayers},
deletedPlayers: ${deletedPlayers},
hasAnyActivePlayers: ${hasAnyActivePlayers},
hasAnyDeletedPlayers: ${hasAnyDeletedPlayers},
hasAnyPlayers: ${hasAnyPlayers}
    ''';
  }
}
