// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'players_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayersViewModel on _PlayersViewModel, Store {
  Computed<List<Player>>? _$playersComputed;

  @override
  List<Player> get players =>
      (_$playersComputed ??= Computed<List<Player>>(() => super.players,
              name: '_PlayersViewModel.players'))
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

  late final _$isEditModeAtom =
      Atom(name: '_PlayersViewModel.isEditMode', context: context);

  @override
  bool get isEditMode {
    _$isEditModeAtom.reportRead();
    return super.isEditMode;
  }

  @override
  set isEditMode(bool value) {
    _$isEditModeAtom.reportWrite(value, super.isEditMode, () {
      super.isEditMode = value;
    });
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
  void toggleEditMode() {
    final _$actionInfo = _$_PlayersViewModelActionController.startAction(
        name: '_PlayersViewModel.toggleEditMode');
    try {
      return super.toggleEditMode();
    } finally {
      _$_PlayersViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
futureLoadPlayers: ${futureLoadPlayers},
isEditMode: ${isEditMode},
players: ${players},
hasAnyPlayers: ${hasAnyPlayers}
    ''';
  }
}
