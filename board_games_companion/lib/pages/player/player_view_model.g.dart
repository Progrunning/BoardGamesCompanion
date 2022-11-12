// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayerViewModel on _PlayerViewModel, Store {
  Computed<bool>? _$isEditModeComputed;

  @override
  bool get isEditMode =>
      (_$isEditModeComputed ??= Computed<bool>(() => super.isEditMode,
              name: '_PlayerViewModel.isEditMode'))
          .value;

  late final _$playerAtom =
      Atom(name: '_PlayerViewModel.player', context: context);

  @override
  Player? get player {
    _$playerAtom.reportRead();
    return super.player;
  }

  @override
  set player(Player? value) {
    _$playerAtom.reportWrite(value, super.player, () {
      super.player = value;
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
  String toString() {
    return '''
player: ${player},
isEditMode: ${isEditMode}
    ''';
  }
}
