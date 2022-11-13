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
  Computed<String?>? _$playerAvatarImageUriComputed;

  @override
  String? get playerAvatarImageUri => (_$playerAvatarImageUriComputed ??=
          Computed<String?>(() => super.playerAvatarImageUri,
              name: '_PlayerViewModel.playerAvatarImageUri'))
      .value;
  Computed<bool>? _$playerHasNameComputed;

  @override
  bool get playerHasName =>
      (_$playerHasNameComputed ??= Computed<bool>(() => super.playerHasName,
              name: '_PlayerViewModel.playerHasName'))
          .value;
  Computed<bool>? _$isEditModeComputed;

  @override
  bool get isEditMode =>
      (_$isEditModeComputed ??= Computed<bool>(() => super.isEditMode,
              name: '_PlayerViewModel.isEditMode'))
          .value;
  Computed<bool>? _$hasUnsavedChangesComputed;

  @override
  bool get hasUnsavedChanges => (_$hasUnsavedChangesComputed ??= Computed<bool>(
          () => super.hasUnsavedChanges,
          name: '_PlayerViewModel.hasUnsavedChanges'))
      .value;

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

  late final _$createOrUpdatePlayerAsyncAction =
      AsyncAction('_PlayerViewModel.createOrUpdatePlayer', context: context);

  @override
  Future<bool> createOrUpdatePlayer(Player playerToCreateOrUpdate) {
    return _$createOrUpdatePlayerAsyncAction
        .run(() => super.createOrUpdatePlayer(playerToCreateOrUpdate));
  }

  late final _$deletePlayerAsyncAction =
      AsyncAction('_PlayerViewModel.deletePlayer', context: context);

  @override
  Future<void> deletePlayer() {
    return _$deletePlayerAsyncAction.run(() => super.deletePlayer());
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
playerWorkingCopy: ${playerWorkingCopy},
playerName: ${playerName},
playerAvatarImageUri: ${playerAvatarImageUri},
playerHasName: ${playerHasName},
isEditMode: ${isEditMode},
hasUnsavedChanges: ${hasUnsavedChanges}
    ''';
  }
}
