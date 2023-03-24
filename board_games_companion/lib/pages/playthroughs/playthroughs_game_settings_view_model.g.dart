// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_game_settings_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsGameSettingsViewModel
    on _PlaythroughsGameSettingsViewModel, Store {
  Computed<AverageScorePrecision>? _$_averageScorePrecisionComputed;

  @override
  AverageScorePrecision get _averageScorePrecision =>
      (_$_averageScorePrecisionComputed ??= Computed<AverageScorePrecision>(
              () => super._averageScorePrecision,
              name:
                  '_PlaythroughsGameSettingsViewModel._averageScorePrecision'))
          .value;
  Computed<BoardGameClassificationSettings>?
      _$gameClassificationSettingsComputed;

  @override
  BoardGameClassificationSettings get gameClassificationSettings =>
      (_$gameClassificationSettingsComputed ??= Computed<
                  BoardGameClassificationSettings>(
              () => super.gameClassificationSettings,
              name:
                  '_PlaythroughsGameSettingsViewModel.gameClassificationSettings'))
          .value;
  Computed<GameClassification>? _$gameClassificationComputed;

  @override
  GameClassification get gameClassification => (_$gameClassificationComputed ??=
          Computed<GameClassification>(() => super.gameClassification,
              name: '_PlaythroughsGameSettingsViewModel.gameClassification'))
      .value;

  late final _$updateGameFamilyAsyncAction = AsyncAction(
      '_PlaythroughsGameSettingsViewModel.updateGameFamily',
      context: context);

  @override
  Future<void> updateGameFamily(GameFamily gameFamily) {
    return _$updateGameFamilyAsyncAction
        .run(() => super.updateGameFamily(gameFamily));
  }

  late final _$updateGameClassificationAsyncAction = AsyncAction(
      '_PlaythroughsGameSettingsViewModel.updateGameClassification',
      context: context);

  @override
  Future<void> updateGameClassification(GameClassification gameClassification) {
    return _$updateGameClassificationAsyncAction
        .run(() => super.updateGameClassification(gameClassification));
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
gameClassificationSettings: ${gameClassificationSettings},
gameClassification: ${gameClassification}
    ''';
  }
}
