// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_migration_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughMigrationViewModel on _PlaythroughMigrationViewModel, Store {
  late final _$playthroughMighrationAtom = Atom(
      name: '_PlaythroughMigrationViewModel.playthroughMighration',
      context: context);

  @override
  PlaythroughMigration get playthroughMighration {
    _$playthroughMighrationAtom.reportRead();
    return super.playthroughMighration;
  }

  @override
  set playthroughMighration(PlaythroughMigration value) {
    _$playthroughMighrationAtom.reportWrite(value, super.playthroughMighration,
        () {
      super.playthroughMighration = value;
    });
  }

  late final _$playthroughMighrationProgressAtom = Atom(
      name: '_PlaythroughMigrationViewModel.playthroughMighrationProgress',
      context: context);

  @override
  PlaythroughMigrationProgress get playthroughMighrationProgress {
    _$playthroughMighrationProgressAtom.reportRead();
    return super.playthroughMighrationProgress;
  }

  @override
  set playthroughMighrationProgress(PlaythroughMigrationProgress value) {
    _$playthroughMighrationProgressAtom
        .reportWrite(value, super.playthroughMighrationProgress, () {
      super.playthroughMighrationProgress = value;
    });
  }

  late final _$migrateAsyncAction =
      AsyncAction('_PlaythroughMigrationViewModel.migrate', context: context);

  @override
  Future<void> migrate() {
    return _$migrateAsyncAction.run(() => super.migrate());
  }

  late final _$_PlaythroughMigrationViewModelActionController =
      ActionController(
          name: '_PlaythroughMigrationViewModel', context: context);

  @override
  void setPlaythroughMigration(PlaythroughMigration playthroughMighration) {
    final _$actionInfo =
        _$_PlaythroughMigrationViewModelActionController.startAction(
            name: '_PlaythroughMigrationViewModel.setPlaythroughMigration');
    try {
      return super.setPlaythroughMigration(playthroughMighration);
    } finally {
      _$_PlaythroughMigrationViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCooperativeGameResult(
      CooperativeGameResult newCooperativeGameResult) {
    final _$actionInfo =
        _$_PlaythroughMigrationViewModelActionController.startAction(
            name: '_PlaythroughMigrationViewModel.updateCooperativeGameResult');
    try {
      return super.updateCooperativeGameResult(newCooperativeGameResult);
    } finally {
      _$_PlaythroughMigrationViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePlayerScore(PlayerScore playerScoreToRemove) {
    final _$actionInfo = _$_PlaythroughMigrationViewModelActionController
        .startAction(name: '_PlaythroughMigrationViewModel.removePlayerScore');
    try {
      return super.removePlayerScore(playerScoreToRemove);
    } finally {
      _$_PlaythroughMigrationViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
playthroughMighration: ${playthroughMighration},
playthroughMighrationProgress: ${playthroughMighrationProgress}
    ''';
  }
}
