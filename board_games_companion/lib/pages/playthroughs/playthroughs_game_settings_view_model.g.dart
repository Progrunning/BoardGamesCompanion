// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_game_settings_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsGameSettingsViewModel
    on _PlaythroughsGameSettingsViewModel, Store {
  Computed<GameWinCondition>? _$winConditionComputed;

  @override
  GameWinCondition get winCondition => (_$winConditionComputed ??=
          Computed<GameWinCondition>(() => super.winCondition,
              name: '_PlaythroughsGameSettingsViewModel.winCondition'))
      .value;
  Computed<GameMode>? _$gameModeComputed;

  @override
  GameMode get gameMode =>
      (_$gameModeComputed ??= Computed<GameMode>(() => super.gameMode,
              name: '_PlaythroughsGameSettingsViewModel.gameMode'))
          .value;
  Computed<AverageScorePrecision>? _$averageScorePrecisionComputed;

  @override
  AverageScorePrecision get averageScorePrecision =>
      (_$averageScorePrecisionComputed ??= Computed<AverageScorePrecision>(
              () => super.averageScorePrecision,
              name: '_PlaythroughsGameSettingsViewModel.averageScorePrecision'))
          .value;

  late final _$updateWinConditionAsyncAction = AsyncAction(
      '_PlaythroughsGameSettingsViewModel.updateWinCondition',
      context: context);

  @override
  Future<void> updateWinCondition(GameWinCondition winCondition) {
    return _$updateWinConditionAsyncAction
        .run(() => super.updateWinCondition(winCondition));
  }

  late final _$updateAverageScorePrecisionAsyncAction = AsyncAction(
      '_PlaythroughsGameSettingsViewModel.updateAverageScorePrecision',
      context: context);

  @override
  Future<void> updateAverageScorePrecision(
      AverageScorePrecision averageScorePrecision) {
    return _$updateAverageScorePrecisionAsyncAction
        .run(() => super.updateAverageScorePrecision(averageScorePrecision));
  }

  @override
  String toString() {
    return '''
winCondition: ${winCondition},
gameMode: ${gameMode},
averageScorePrecision: ${averageScorePrecision}
    ''';
  }
}
