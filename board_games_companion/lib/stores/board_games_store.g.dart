// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_games_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BoardGamesStore on _BoardGamesStore, Store {
  Computed<ObservableMap<String, BoardGameDetails>>? _$allBoardGamesMapComputed;

  @override
  ObservableMap<String, BoardGameDetails> get allBoardGamesMap =>
      (_$allBoardGamesMapComputed ??=
              Computed<ObservableMap<String, BoardGameDetails>>(
                  () => super.allBoardGamesMap,
                  name: '_BoardGamesStore.allBoardGamesMap'))
          .value;
  Computed<List<BoardGameDetails>>? _$allBoardGamesInCollectionsComputed;

  @override
  List<BoardGameDetails> get allBoardGamesInCollections =>
      (_$allBoardGamesInCollectionsComputed ??=
              Computed<List<BoardGameDetails>>(
                  () => super.allBoardGamesInCollections,
                  name: '_BoardGamesStore.allBoardGamesInCollections'))
          .value;
  Computed<ObservableMap<String, BoardGameDetails>>?
      _$allBoardGamesInCollectionsMapComputed;

  @override
  ObservableMap<String, BoardGameDetails> get allBoardGamesInCollectionsMap =>
      (_$allBoardGamesInCollectionsMapComputed ??=
              Computed<ObservableMap<String, BoardGameDetails>>(
                  () => super.allBoardGamesInCollectionsMap,
                  name: '_BoardGamesStore.allBoardGamesInCollectionsMap'))
          .value;

  late final _$allBoardGamesAtom =
      Atom(name: '_BoardGamesStore.allBoardGames', context: context);

  @override
  ObservableList<BoardGameDetails> get allBoardGames {
    _$allBoardGamesAtom.reportRead();
    return super.allBoardGames;
  }

  @override
  set allBoardGames(ObservableList<BoardGameDetails> value) {
    _$allBoardGamesAtom.reportWrite(value, super.allBoardGames, () {
      super.allBoardGames = value;
    });
  }

  late final _$loadBoardGamesAsyncAction =
      AsyncAction('_BoardGamesStore.loadBoardGames', context: context);

  @override
  Future<void> loadBoardGames() {
    return _$loadBoardGamesAsyncAction.run(() => super.loadBoardGames());
  }

  late final _$addOrUpdateBoardGameAsyncAction =
      AsyncAction('_BoardGamesStore.addOrUpdateBoardGame', context: context);

  @override
  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) {
    return _$addOrUpdateBoardGameAsyncAction
        .run(() => super.addOrUpdateBoardGame(boardGameDetails));
  }

  late final _$refreshBoardGameDetailsAsyncAction =
      AsyncAction('_BoardGamesStore.refreshBoardGameDetails', context: context);

  @override
  Future<void> refreshBoardGameDetails(String boardGameId) {
    return _$refreshBoardGameDetailsAsyncAction
        .run(() => super.refreshBoardGameDetails(boardGameId));
  }

  late final _$removeBoardGameAsyncAction =
      AsyncAction('_BoardGamesStore.removeBoardGame', context: context);

  @override
  Future<void> removeBoardGame(String boardGameDetailsId) {
    return _$removeBoardGameAsyncAction
        .run(() => super.removeBoardGame(boardGameDetailsId));
  }

  late final _$removeAllBggBoardGamesAsyncAction =
      AsyncAction('_BoardGamesStore.removeAllBggBoardGames', context: context);

  @override
  Future<void> removeAllBggBoardGames() {
    return _$removeAllBggBoardGamesAsyncAction
        .run(() => super.removeAllBggBoardGames());
  }

  late final _$importCollectionsAsyncAction =
      AsyncAction('_BoardGamesStore.importCollections', context: context);

  @override
  Future<CollectionImportResult> importCollections(String username) {
    return _$importCollectionsAsyncAction
        .run(() => super.importCollections(username));
  }

  @override
  String toString() {
    return '''
allBoardGames: ${allBoardGames},
allBoardGamesMap: ${allBoardGamesMap},
allBoardGamesInCollections: ${allBoardGamesInCollections},
allBoardGamesInCollectionsMap: ${allBoardGamesInCollectionsMap}
    ''';
  }
}
