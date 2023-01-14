// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeViewModel on _HomeViewModelBase, Store {
  Computed<List<BoardGameDetails>>? _$allBoardGamesComputed;

  @override
  List<BoardGameDetails> get allBoardGames => (_$allBoardGamesComputed ??=
          Computed<List<BoardGameDetails>>(() => super.allBoardGames,
              name: '_HomeViewModelBase.allBoardGames'))
      .value;
  Computed<bool>? _$anyBoardGamesInCollectionsComputed;

  @override
  bool get anyBoardGamesInCollections =>
      (_$anyBoardGamesInCollectionsComputed ??= Computed<bool>(
              () => super.anyBoardGamesInCollections,
              name: '_HomeViewModelBase.anyBoardGamesInCollections'))
          .value;
  Computed<List<SearchHistoryEntry>>? _$searchHistoryComputed;

  @override
  List<SearchHistoryEntry> get searchHistory => (_$searchHistoryComputed ??=
          Computed<List<SearchHistoryEntry>>(() => super.searchHistory,
              name: '_HomeViewModelBase.searchHistory'))
      .value;

  late final _$futureloadDataAtom =
      Atom(name: '_HomeViewModelBase.futureloadData', context: context);

  @override
  ObservableFuture<void>? get futureloadData {
    _$futureloadDataAtom.reportRead();
    return super.futureloadData;
  }

  @override
  set futureloadData(ObservableFuture<void>? value) {
    _$futureloadDataAtom.reportWrite(value, super.futureloadData, () {
      super.futureloadData = value;
    });
  }

  late final _$searchCollectionsAsyncAction =
      AsyncAction('_HomeViewModelBase.searchCollections', context: context);

  @override
  Future<List<BoardGameDetails>> searchCollections(String query) {
    return _$searchCollectionsAsyncAction
        .run(() => super.searchCollections(query));
  }

  late final _$searchBggAsyncAction =
      AsyncAction('_HomeViewModelBase.searchBgg', context: context);

  @override
  Future<List<BoardGameDetails>> searchBgg(String query) {
    return _$searchBggAsyncAction.run(() => super.searchBgg(query));
  }

  late final _$_HomeViewModelBaseActionController =
      ActionController(name: '_HomeViewModelBase', context: context);

  @override
  void loadData() {
    final _$actionInfo = _$_HomeViewModelBaseActionController.startAction(
        name: '_HomeViewModelBase.loadData');
    try {
      return super.loadData();
    } finally {
      _$_HomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
futureloadData: ${futureloadData},
allBoardGames: ${allBoardGames},
anyBoardGamesInCollections: ${anyBoardGamesInCollections},
searchHistory: ${searchHistory}
    ''';
  }
}
