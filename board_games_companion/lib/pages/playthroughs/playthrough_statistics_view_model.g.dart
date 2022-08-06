// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_statistics_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughStatisticsViewModel
    on _PlaythroughStatisticsViewModel, Store {
  Computed<BoardGameDetails>? _$boardGameComputed;

  @override
  BoardGameDetails get boardGame =>
      (_$boardGameComputed ??= Computed<BoardGameDetails>(() => super.boardGame,
              name: '_PlaythroughStatisticsViewModel.boardGame'))
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
boardGame: ${boardGame}
    ''';
  }
}
