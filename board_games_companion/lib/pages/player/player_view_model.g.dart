// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayerViewModel on _PlayerViewModel, Store {
  Computed<String?>? _$playerNameComputed;

  @override
  String? get playerName =>
      (_$playerNameComputed ??= Computed<String?>(() => super.playerName,
              name: '_PlayerViewModel.playerName'))
          .value;
  Computed<bool>? _$isBggUserComputed;

  @override
  bool get isBggUser =>
      (_$isBggUserComputed ??= Computed<bool>(() => super.isBggUser,
              name: '_PlayerViewModel.isBggUser'))
          .value;
  Computed<String?>? _$playerAvatarImageUriComputed;

  @override
  String? get playerAvatarImageUri => (_$playerAvatarImageUriComputed ??=
          Computed<String?>(() => super.playerAvatarImageUri,
              name: '_PlayerViewModel.playerAvatarImageUri'))
      .value;
  Computed<bool>? _$hasUnsavedChangesComputed;

  @override
  bool get hasUnsavedChanges => (_$hasUnsavedChangesComputed ??= Computed<bool>(
          () => super.hasUnsavedChanges,
          name: '_PlayerViewModel.hasUnsavedChanges'))
      .value;

  late final _$visualStateAtom =
      Atom(name: '_PlayerViewModel.visualState', context: context);

  @override
  PlayerVisualState get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(PlayerVisualState value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$_playerAtom =
      Atom(name: '_PlayerViewModel._player', context: context);

  @override
  Player? get _player {
    _$_playerAtom.reportRead();
    return super._player;
  }

  @override
  set _player(Player? value) {
    _$_playerAtom.reportWrite(value, super._player, () {
      super._player = value;
    });
  }

  late final _$playerWorkingCopyAtom =
      Atom(name: '_PlayerViewModel.playerWorkingCopy', context: context);

  @override
  Player? get playerWorkingCopy {
    _$playerWorkingCopyAtom.reportRead();
    return super.playerWorkingCopy;
  }

  @override
  set playerWorkingCopy(Player? value) {
    _$playerWorkingCopyAtom.reportWrite(value, super.playerWorkingCopy, () {
      super.playerWorkingCopy = value;
    });
  }

  late final _$createPlayerAsyncAction =
      AsyncAction('_PlayerViewModel.createPlayer', context: context);

  @override
  Future<bool> createPlayer(Player player) {
    return _$createPlayerAsyncAction.run(() => super.createPlayer(player));
  }

  late final _$updatePlayerAsyncAction =
      AsyncAction('_PlayerViewModel.updatePlayer', context: context);

  @override
  Future<bool> updatePlayer(Player player) {
    return _$updatePlayerAsyncAction.run(() => super.updatePlayer(player));
  }

  late final _$deletePlayerAsyncAction =
      AsyncAction('_PlayerViewModel.deletePlayer', context: context);

  @override
  Future<void> deletePlayer() {
    return _$deletePlayerAsyncAction.run(() => super.deletePlayer());
  }

  late final _$restorePlayerAsyncAction =
      AsyncAction('_PlayerViewModel.restorePlayer', context: context);

  @override
  Future<bool> restorePlayer() {
    return _$restorePlayerAsyncAction.run(() => super.restorePlayer());
  }

  late final _$_PlayerViewModelActionController =
      ActionController(name: '_PlayerViewModel', context: context);

  @override
  void setPlayer(Player? player) {
    final _$actionInfo = _$_PlayerViewModelActionController.startAction(
        name: '_PlayerViewModel.setPlayer');
    try {
      return super.setPlayer(player);
    } finally {
      _$_PlayerViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePlayerWorkingCopy(Player player) {
    final _$actionInfo = _$_PlayerViewModelActionController.startAction(
        name: '_PlayerViewModel.updatePlayerWorkingCopy');
    try {
      return super.updatePlayerWorkingCopy(player);
    } finally {
      _$_PlayerViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
visualState: ${visualState},
playerWorkingCopy: ${playerWorkingCopy},
playerName: ${playerName},
isBggUser: ${isBggUser},
playerAvatarImageUri: ${playerAvatarImageUri},
hasUnsavedChanges: ${hasUnsavedChanges}
    ''';
  }
}
