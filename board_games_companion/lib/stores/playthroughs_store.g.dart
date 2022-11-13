// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsStore on _PlaythroughsStore, Store {
  Computed<String>? _$boardGameNameComputed;

  @override
  String get boardGameName =>
      (_$boardGameNameComputed ??= Computed<String>(() => super.boardGameName,
              name: '_PlaythroughsStore.boardGameName'))
          .value;
  Computed<String>? _$boardGameIdComputed;

  @override
  String get boardGameId =>
      (_$boardGameIdComputed ??= Computed<String>(() => super.boardGameId,
              name: '_PlaythroughsStore.boardGameId'))
          .value;
  Computed<String?>? _$boardGameImageUrlComputed;

  @override
  String? get boardGameImageUrl => (_$boardGameImageUrlComputed ??=
          Computed<String?>(() => super.boardGameImageUrl,
              name: '_PlaythroughsStore.boardGameImageUrl'))
      .value;
  Computed<GameWinningCondition>? _$gameWinningConditionComputed;

  @override
  GameWinningCondition get gameWinningCondition =>
      (_$gameWinningConditionComputed ??= Computed<GameWinningCondition>(
              () => super.gameWinningCondition,
              name: '_PlaythroughsStore.gameWinningCondition'))
          .value;

  late final _$_boardGameAtom =
      Atom(name: '_PlaythroughsStore._boardGame', context: context);

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

  late final _$playthroughsDetailsAtom =
      Atom(name: '_PlaythroughsStore.playthroughsDetails', context: context);

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

  late final _$loadPlaythroughsAsyncAction =
      AsyncAction('_PlaythroughsStore.loadPlaythroughs', context: context);

  @override
  Future<void> loadPlaythroughs() {
    return _$loadPlaythroughsAsyncAction.run(() => super.loadPlaythroughs());
  }

  late final _$_PlaythroughsStoreActionController =
      ActionController(name: '_PlaythroughsStore', context: context);

  @override
  void setBoardGame(BoardGameDetails boardGame) {
    final _$actionInfo = _$_PlaythroughsStoreActionController.startAction(
        name: '_PlaythroughsStore.setBoardGame');
    try {
      return super.setBoardGame(boardGame);
    } finally {
      _$_PlaythroughsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
playthroughsDetails: ${playthroughsDetails},
boardGameName: ${boardGameName},
boardGameId: ${boardGameId},
boardGameImageUrl: ${boardGameImageUrl},
gameWinningCondition: ${gameWinningCondition}
    ''';
  }
}
