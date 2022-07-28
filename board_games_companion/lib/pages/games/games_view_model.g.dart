// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GamesViewModel on _GamesViewModel, Store {
  Computed<Map<String, BoardGameDetails>>? _$filteredBoardGamesComputed;

  @override
  Map<String, BoardGameDetails> get filteredBoardGames =>
      (_$filteredBoardGamesComputed ??= Computed<Map<String, BoardGameDetails>>(
              () => super.filteredBoardGames,
              name: '_GamesViewModel.filteredBoardGames'))
          .value;
  Computed<bool>? _$anyBoardGamesInCollectionsComputed;

  @override
  bool get anyBoardGamesInCollections =>
      (_$anyBoardGamesInCollectionsComputed ??= Computed<bool>(
              () => super.anyBoardGamesInCollections,
              name: '_GamesViewModel.anyBoardGamesInCollections'))
          .value;
  Computed<bool>? _$anyBoardGamesComputed;

  @override
  bool get anyBoardGames =>
      (_$anyBoardGamesComputed ??= Computed<bool>(() => super.anyBoardGames,
              name: '_GamesViewModel.anyBoardGames'))
          .value;
  Computed<List<BoardGameDetails>>? _$allBoardGamesComputed;

  @override
  List<BoardGameDetails> get allBoardGames => (_$allBoardGamesComputed ??=
          Computed<List<BoardGameDetails>>(() => super.allBoardGames,
              name: '_GamesViewModel.allBoardGames'))
      .value;
  Computed<CollectionState>? _$collectionSateComputed;

  @override
  CollectionState get collectionSate => (_$collectionSateComputed ??=
          Computed<CollectionState>(() => super.collectionSate,
              name: '_GamesViewModel.collectionSate'))
      .value;
  Computed<List<BoardGameDetails>>? _$boardGamesInSelectedCollectionComputed;

  @override
  List<BoardGameDetails> get boardGamesInSelectedCollection =>
      (_$boardGamesInSelectedCollectionComputed ??=
              Computed<List<BoardGameDetails>>(
                  () => super.boardGamesInSelectedCollection,
                  name: '_GamesViewModel.boardGamesInSelectedCollection'))
          .value;
  Computed<bool>? _$anyBoardGamesInSelectedCollectionComputed;

  @override
  bool get anyBoardGamesInSelectedCollection =>
      (_$anyBoardGamesInSelectedCollectionComputed ??= Computed<bool>(
              () => super.anyBoardGamesInSelectedCollection,
              name: '_GamesViewModel.anyBoardGamesInSelectedCollection'))
          .value;
  Computed<List<BoardGameDetails>>? _$mainGamesInCollectionsComputed;

  @override
  List<BoardGameDetails> get mainGamesInCollections =>
      (_$mainGamesInCollectionsComputed ??= Computed<List<BoardGameDetails>>(
              () => super.mainGamesInCollections,
              name: '_GamesViewModel.mainGamesInCollections'))
          .value;
  Computed<bool>? _$hasAnyMainGameInSelectedCollectionComputed;

  @override
  bool get hasAnyMainGameInSelectedCollection =>
      (_$hasAnyMainGameInSelectedCollectionComputed ??= Computed<bool>(
              () => super.hasAnyMainGameInSelectedCollection,
              name: '_GamesViewModel.hasAnyMainGameInSelectedCollection'))
          .value;
  Computed<int>? _$totalMainGamesInCollectionsComputed;

  @override
  int get totalMainGamesInCollections =>
      (_$totalMainGamesInCollectionsComputed ??= Computed<int>(
              () => super.totalMainGamesInCollections,
              name: '_GamesViewModel.totalMainGamesInCollections'))
          .value;
  Computed<int>? _$totalExpansionsInCollectionsComputed;

  @override
  int get totalExpansionsInCollections =>
      (_$totalExpansionsInCollectionsComputed ??= Computed<int>(
              () => super.totalExpansionsInCollections,
              name: '_GamesViewModel.totalExpansionsInCollections'))
          .value;
  Computed<bool>? _$hasAnyExpansionsInSelectedCollectionComputed;

  @override
  bool get hasAnyExpansionsInSelectedCollection =>
      (_$hasAnyExpansionsInSelectedCollectionComputed ??= Computed<bool>(
              () => super.hasAnyExpansionsInSelectedCollection,
              name: '_GamesViewModel.hasAnyExpansionsInSelectedCollection'))
          .value;
  Computed<Map<BoardGameDetails, List<BoardGameDetails>>>?
      _$expansionsGroupedByMainGameComputed;

  @override
  Map<BoardGameDetails, List<BoardGameDetails>>
      get expansionsGroupedByMainGame =>
          (_$expansionsGroupedByMainGameComputed ??=
                  Computed<Map<BoardGameDetails, List<BoardGameDetails>>>(
                      () => super.expansionsGroupedByMainGame,
                      name: '_GamesViewModel.expansionsGroupedByMainGame'))
              .value;
  Computed<Map<BoardGameDetails, List<BoardGameDetails>>>?
      _$expansionsInSelectedCollectionGroupedByMainGameComputed;

  @override
  Map<
      BoardGameDetails,
      List<
          BoardGameDetails>> get expansionsInSelectedCollectionGroupedByMainGame =>
      (_$expansionsInSelectedCollectionGroupedByMainGameComputed ??= Computed<
                  Map<BoardGameDetails, List<BoardGameDetails>>>(
              () => super.expansionsInSelectedCollectionGroupedByMainGame,
              name:
                  '_GamesViewModel.expansionsInSelectedCollectionGroupedByMainGame'))
          .value;

  late final _$selectedTabAtom =
      Atom(name: '_GamesViewModel.selectedTab', context: context);

  @override
  GamesTab get selectedTab {
    _$selectedTabAtom.reportRead();
    return super.selectedTab;
  }

  @override
  set selectedTab(GamesTab value) {
    _$selectedTabAtom.reportWrite(value, super.selectedTab, () {
      super.selectedTab = value;
    });
  }

  late final _$futureLoadBoardGamesAtom =
      Atom(name: '_GamesViewModel.futureLoadBoardGames', context: context);

  @override
  ObservableFuture<void>? get futureLoadBoardGames {
    _$futureLoadBoardGamesAtom.reportRead();
    return super.futureLoadBoardGames;
  }

  @override
  set futureLoadBoardGames(ObservableFuture<void>? value) {
    _$futureLoadBoardGamesAtom.reportWrite(value, super.futureLoadBoardGames,
        () {
      super.futureLoadBoardGames = value;
    });
  }

  late final _$refreshBoardGameDetailsAsyncAction =
      AsyncAction('_GamesViewModel.refreshBoardGameDetails', context: context);

  @override
  Future<void> refreshBoardGameDetails(String boardGameId) {
    return _$refreshBoardGameDetailsAsyncAction
        .run(() => super.refreshBoardGameDetails(boardGameId));
  }

  late final _$_GamesViewModelActionController =
      ActionController(name: '_GamesViewModel', context: context);

  @override
  void setSelectedTab(GamesTab newlySelectedTab) {
    final _$actionInfo = _$_GamesViewModelActionController.startAction(
        name: '_GamesViewModel.setSelectedTab');
    try {
      return super.setSelectedTab(newlySelectedTab);
    } finally {
      _$_GamesViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadBoardGames() {
    final _$actionInfo = _$_GamesViewModelActionController.startAction(
        name: '_GamesViewModel.loadBoardGames');
    try {
      return super.loadBoardGames();
    } finally {
      _$_GamesViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTab: ${selectedTab},
futureLoadBoardGames: ${futureLoadBoardGames},
filteredBoardGames: ${filteredBoardGames},
anyBoardGamesInCollections: ${anyBoardGamesInCollections},
anyBoardGames: ${anyBoardGames},
allBoardGames: ${allBoardGames},
collectionSate: ${collectionSate},
boardGamesInSelectedCollection: ${boardGamesInSelectedCollection},
anyBoardGamesInSelectedCollection: ${anyBoardGamesInSelectedCollection},
mainGamesInCollections: ${mainGamesInCollections},
hasAnyMainGameInSelectedCollection: ${hasAnyMainGameInSelectedCollection},
totalMainGamesInCollections: ${totalMainGamesInCollections},
totalExpansionsInCollections: ${totalExpansionsInCollections},
hasAnyExpansionsInSelectedCollection: ${hasAnyExpansionsInSelectedCollection},
expansionsGroupedByMainGame: ${expansionsGroupedByMainGame},
expansionsInSelectedCollectionGroupedByMainGame: ${expansionsInSelectedCollectionGroupedByMainGame}
    ''';
  }
}
