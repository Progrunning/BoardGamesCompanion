// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_statistics_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayerStatisticsViewModel on _PlayerStatisticsViewModel, Store {
  Computed<bool>? _$isPlayerDeletedComputed;

  @override
  bool get isPlayerDeleted =>
      (_$isPlayerDeletedComputed ??= Computed<bool>(() => super.isPlayerDeleted,
              name: '_PlayerStatisticsViewModel.isPlayerDeleted'))
          .value;
  Computed<List<GamePlaysCount>>? _$displayedGamesComputed;

  @override
  List<GamePlaysCount> get displayedGames => (_$displayedGamesComputed ??=
          Computed<List<GamePlaysCount>>(() => super.displayedGames,
              name: '_PlayerStatisticsViewModel.displayedGames'))
      .value;
  Computed<bool>? _$canExpandGamesComputed;

  @override
  bool get canExpandGames =>
      (_$canExpandGamesComputed ??= Computed<bool>(() => super.canExpandGames,
              name: '_PlayerStatisticsViewModel.canExpandGames'))
          .value;

  late final _$playerAtom =
      Atom(name: '_PlayerStatisticsViewModel.player', context: context);

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

  late final _$visualStateAtom =
      Atom(name: '_PlayerStatisticsViewModel.visualState', context: context);

  @override
  PlayerStatisticsVisualState get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(PlayerStatisticsVisualState value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$statisticsAtom =
      Atom(name: '_PlayerStatisticsViewModel.statistics', context: context);

  @override
  PlayerOverallStatistics? get statistics {
    _$statisticsAtom.reportRead();
    return super.statistics;
  }

  @override
  set statistics(PlayerOverallStatistics? value) {
    _$statisticsAtom.reportWrite(value, super.statistics, () {
      super.statistics = value;
    });
  }

  late final _$isGamesListExpandedAtom = Atom(
      name: '_PlayerStatisticsViewModel.isGamesListExpanded', context: context);

  @override
  bool get isGamesListExpanded {
    _$isGamesListExpandedAtom.reportRead();
    return super.isGamesListExpanded;
  }

  @override
  set isGamesListExpanded(bool value) {
    _$isGamesListExpandedAtom.reportWrite(value, super.isGamesListExpanded, () {
      super.isGamesListExpanded = value;
    });
  }

  late final _$futureLoadStatisticsAtom = Atom(
      name: '_PlayerStatisticsViewModel.futureLoadStatistics',
      context: context);

  @override
  ObservableFuture<void>? get futureLoadStatistics {
    _$futureLoadStatisticsAtom.reportRead();
    return super.futureLoadStatistics;
  }

  @override
  set futureLoadStatistics(ObservableFuture<void>? value) {
    _$futureLoadStatisticsAtom.reportWrite(value, super.futureLoadStatistics,
        () {
      super.futureLoadStatistics = value;
    });
  }

  late final _$_PlayerStatisticsViewModelActionController =
      ActionController(name: '_PlayerStatisticsViewModel', context: context);

  @override
  void setPlayer(Player? player) {
    final _$actionInfo = _$_PlayerStatisticsViewModelActionController
        .startAction(name: '_PlayerStatisticsViewModel.setPlayer');
    try {
      return super.setPlayer(player);
    } finally {
      _$_PlayerStatisticsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleGamesExpansion() {
    final _$actionInfo = _$_PlayerStatisticsViewModelActionController
        .startAction(name: '_PlayerStatisticsViewModel.toggleGamesExpansion');
    try {
      return super.toggleGamesExpansion();
    } finally {
      _$_PlayerStatisticsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadPlayerStatistics() {
    final _$actionInfo = _$_PlayerStatisticsViewModelActionController
        .startAction(name: '_PlayerStatisticsViewModel.loadPlayerStatistics');
    try {
      return super.loadPlayerStatistics();
    } finally {
      _$_PlayerStatisticsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
player: ${player},
visualState: ${visualState},
statistics: ${statistics},
isGamesListExpanded: ${isGamesListExpanded},
futureLoadStatistics: ${futureLoadStatistics},
isPlayerDeleted: ${isPlayerDeleted},
displayedGames: ${displayedGames},
canExpandGames: ${canExpandGames}
    ''';
  }
}
