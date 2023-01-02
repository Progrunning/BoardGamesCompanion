// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_playthroughs_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GamePlaythroughsDetailsStore on _GamePlaythroughsDetailsStore, Store {
  Computed<List<Playthrough>>? _$playthroughsComputed;

  @override
  List<Playthrough> get playthroughs => (_$playthroughsComputed ??=
          Computed<List<Playthrough>>(() => super.playthroughs,
              name: '_GamePlaythroughsDetailsStore.playthroughs'))
      .value;
  Computed<List<Playthrough>>? _$finishedPlaythroughsComputed;

  @override
  List<Playthrough> get finishedPlaythroughs =>
      (_$finishedPlaythroughsComputed ??= Computed<List<Playthrough>>(
              () => super.finishedPlaythroughs,
              name: '_GamePlaythroughsDetailsStore.finishedPlaythroughs'))
          .value;
  Computed<String>? _$boardGameNameComputed;

  @override
  String get boardGameName =>
      (_$boardGameNameComputed ??= Computed<String>(() => super.boardGameName,
              name: '_GamePlaythroughsDetailsStore.boardGameName'))
          .value;
  Computed<String>? _$boardGameIdComputed;

  @override
  String get boardGameId =>
      (_$boardGameIdComputed ??= Computed<String>(() => super.boardGameId,
              name: '_GamePlaythroughsDetailsStore.boardGameId'))
          .value;
  Computed<String?>? _$boardGameImageUrlComputed;

  @override
  String? get boardGameImageUrl => (_$boardGameImageUrlComputed ??=
          Computed<String?>(() => super.boardGameImageUrl,
              name: '_GamePlaythroughsDetailsStore.boardGameImageUrl'))
      .value;
  Computed<GameWinningCondition>? _$gameWinningConditionComputed;

  @override
  GameWinningCondition get gameWinningCondition =>
      (_$gameWinningConditionComputed ??= Computed<GameWinningCondition>(
              () => super.gameWinningCondition,
              name: '_GamePlaythroughsDetailsStore.gameWinningCondition'))
          .value;
  Computed<int>? _$averageScorePrecisionComputed;

  @override
  int get averageScorePrecision => (_$averageScorePrecisionComputed ??=
          Computed<int>(() => super.averageScorePrecision,
              name: '_GamePlaythroughsDetailsStore.averageScorePrecision'))
      .value;

  late final _$_boardGameAtom =
      Atom(name: '_GamePlaythroughsDetailsStore._boardGame', context: context);

  @override
  BoardGameDetails? get _boardGame {
    _$_boardGameAtom.reportRead();
    return super._boardGame;
  }

  @override
  set _boardGame(BoardGameDetails? value) {
    _$_boardGameAtom.reportWrite(value, super._boardGame, () {
      super._boardGame = value;
    });
  }

  late final _$playthroughsDetailsAtom = Atom(
      name: '_GamePlaythroughsDetailsStore.playthroughsDetails',
      context: context);

  @override
  ObservableList<PlaythroughDetails> get playthroughsDetails {
    _$playthroughsDetailsAtom.reportRead();
    return super.playthroughsDetails;
  }

  @override
  set playthroughsDetails(ObservableList<PlaythroughDetails> value) {
    _$playthroughsDetailsAtom.reportWrite(value, super.playthroughsDetails, () {
      super.playthroughsDetails = value;
    });
  }

  late final _$_GamePlaythroughsDetailsStoreActionController =
      ActionController(name: '_GamePlaythroughsDetailsStore', context: context);

  @override
  void loadPlaythroughsDetails() {
    final _$actionInfo =
        _$_GamePlaythroughsDetailsStoreActionController.startAction(
            name: '_GamePlaythroughsDetailsStore.loadPlaythroughsDetails');
    try {
      return super.loadPlaythroughsDetails();
    } finally {
      _$_GamePlaythroughsDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBoardGame(BoardGameDetails boardGame) {
    final _$actionInfo = _$_GamePlaythroughsDetailsStoreActionController
        .startAction(name: '_GamePlaythroughsDetailsStore.setBoardGame');
    try {
      return super.setBoardGame(boardGame);
    } finally {
      _$_GamePlaythroughsDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
playthroughsDetails: ${playthroughsDetails},
playthroughs: ${playthroughs},
finishedPlaythroughs: ${finishedPlaythroughs},
boardGameName: ${boardGameName},
boardGameId: ${boardGameId},
boardGameImageUrl: ${boardGameImageUrl},
gameWinningCondition: ${gameWinningCondition},
averageScorePrecision: ${averageScorePrecision}
    ''';
  }
}
