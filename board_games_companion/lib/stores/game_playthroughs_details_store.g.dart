// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_playthroughs_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GamePlaythroughsDetailsStore on _GamePlaythroughsDetailsStore, Store {
  Computed<BoardGameDetails?>? _$_boardGameComputed;

  @override
  BoardGameDetails? get _boardGame => (_$_boardGameComputed ??=
          Computed<BoardGameDetails?>(() => super._boardGame,
              name: '_GamePlaythroughsDetailsStore._boardGame'))
      .value;
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
  Computed<GameFamily>? _$gameGameFamilyComputed;

  @override
  GameFamily get gameGameFamily => (_$gameGameFamilyComputed ??=
          Computed<GameFamily>(() => super.gameGameFamily,
              name: '_GamePlaythroughsDetailsStore.gameGameFamily'))
      .value;
  Computed<GameClassification>? _$gameClassificationComputed;

  @override
  GameClassification get gameClassification => (_$gameClassificationComputed ??=
          Computed<GameClassification>(() => super.gameClassification,
              name: '_GamePlaythroughsDetailsStore.gameClassification'))
      .value;
  Computed<int>? _$averageScorePrecisionComputed;

  @override
  int get averageScorePrecision => (_$averageScorePrecisionComputed ??=
          Computed<int>(() => super.averageScorePrecision,
              name: '_GamePlaythroughsDetailsStore.averageScorePrecision'))
      .value;

  late final _$_boardGameIdAtom = Atom(
      name: '_GamePlaythroughsDetailsStore._boardGameId', context: context);

  @override
  String? get _boardGameId {
    _$_boardGameIdAtom.reportRead();
    return super._boardGameId;
  }

  @override
  set _boardGameId(String? value) {
    _$_boardGameIdAtom.reportWrite(value, super._boardGameId, () {
      super._boardGameId = value;
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
  void setBoardGameId(String boardGameId) {
    final _$actionInfo = _$_GamePlaythroughsDetailsStoreActionController
        .startAction(name: '_GamePlaythroughsDetailsStore.setBoardGameId');
    try {
      return super.setBoardGameId(boardGameId);
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
gameGameFamily: ${gameGameFamily},
gameClassification: ${gameClassification},
averageScorePrecision: ${averageScorePrecision}
    ''';
  }
}
