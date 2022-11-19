// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_statistics_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughStatisticsViewModel
    on _PlaythroughStatisticsViewModel, Store {
  Computed<List<String>>? _$_playthroughIdsComputed;

  @override
  List<String> get _playthroughIds => (_$_playthroughIdsComputed ??=
          Computed<List<String>>(() => super._playthroughIds,
              name: '_PlaythroughStatisticsViewModel._playthroughIds'))
      .value;
  Computed<List<Score>>? _$_playthroughsScoresComputed;

  @override
  List<Score> get _playthroughsScores => (_$_playthroughsScoresComputed ??=
          Computed<List<Score>>(() => super._playthroughsScores,
              name: '_PlaythroughStatisticsViewModel._playthroughsScores'))
      .value;
  Computed<String>? _$boardGameIdComputed;

  @override
  String get boardGameId =>
      (_$boardGameIdComputed ??= Computed<String>(() => super.boardGameId,
              name: '_PlaythroughStatisticsViewModel.boardGameId'))
          .value;
  Computed<String?>? _$boardGameImageUrlComputed;

  @override
  String? get boardGameImageUrl => (_$boardGameImageUrlComputed ??=
          Computed<String?>(() => super.boardGameImageUrl,
              name: '_PlaythroughStatisticsViewModel.boardGameImageUrl'))
      .value;
  Computed<String>? _$boardGameNameComputed;

  @override
  String get boardGameName =>
      (_$boardGameNameComputed ??= Computed<String>(() => super.boardGameName,
              name: '_PlaythroughStatisticsViewModel.boardGameName'))
          .value;

  late final _$futureLoadBoardGamesStatisticsAtom = Atom(
      name: '_PlaythroughStatisticsViewModel.futureLoadBoardGamesStatistics',
      context: context);

  @override
  ObservableFuture<void>? get futureLoadBoardGamesStatistics {
    _$futureLoadBoardGamesStatisticsAtom.reportRead();
    return super.futureLoadBoardGamesStatistics;
  }

  @override
  set futureLoadBoardGamesStatistics(ObservableFuture<void>? value) {
    _$futureLoadBoardGamesStatisticsAtom
        .reportWrite(value, super.futureLoadBoardGamesStatistics, () {
      super.futureLoadBoardGamesStatistics = value;
    });
  }

  late final _$_PlaythroughStatisticsViewModelActionController =
      ActionController(
          name: '_PlaythroughStatisticsViewModel', context: context);

  @override
  void loadBoardGamesStatistics() {
    final _$actionInfo =
        _$_PlaythroughStatisticsViewModelActionController.startAction(
            name: '_PlaythroughStatisticsViewModel.loadBoardGamesStatistics');
    try {
      return super.loadBoardGamesStatistics();
    } finally {
      _$_PlaythroughStatisticsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
futureLoadBoardGamesStatistics: ${futureLoadBoardGamesStatistics},
boardGameId: ${boardGameId},
boardGameImageUrl: ${boardGameImageUrl},
boardGameName: ${boardGameName}
    ''';
  }
}
