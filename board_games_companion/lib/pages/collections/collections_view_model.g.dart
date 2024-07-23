// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CollectionsViewModel on _CollectionsViewModel, Store {
  Computed<List<BoardGameDetails>>? _$allMainGamesComputed;

  @override
  List<BoardGameDetails> get allMainGames => (_$allMainGamesComputed ??=
          Computed<List<BoardGameDetails>>(() => super.allMainGames,
              name: '_CollectionsViewModel.allMainGames'))
      .value;
  Computed<ObservableMap<String, BoardGameDetails>>?
      _$_mainBoardGameByExpansionIdComputed;

  @override
  ObservableMap<String, BoardGameDetails> get _mainBoardGameByExpansionId =>
      (_$_mainBoardGameByExpansionIdComputed ??=
              Computed<ObservableMap<String, BoardGameDetails>>(
                  () => super._mainBoardGameByExpansionId,
                  name: '_CollectionsViewModel._mainBoardGameByExpansionId'))
          .value;
  Computed<List<SortBy>>? _$sortByOptionsComputed;

  @override
  List<SortBy> get sortByOptions => (_$sortByOptionsComputed ??=
          Computed<List<SortBy>>(() => super.sortByOptions,
              name: '_CollectionsViewModel.sortByOptions'))
      .value;
  Computed<SortBy?>? _$selectedSortByComputed;

  @override
  SortBy? get selectedSortBy => (_$selectedSortByComputed ??= Computed<SortBy?>(
          () => super.selectedSortBy,
          name: '_CollectionsViewModel.selectedSortBy'))
      .value;
  Computed<bool>? _$anyFiltersAppliedComputed;

  @override
  bool get anyFiltersApplied => (_$anyFiltersAppliedComputed ??= Computed<bool>(
          () => super.anyFiltersApplied,
          name: '_CollectionsViewModel.anyFiltersApplied'))
      .value;
  Computed<double?>? _$filterByRatingComputed;

  @override
  double? get filterByRating => (_$filterByRatingComputed ??= Computed<double?>(
          () => super.filterByRating,
          name: '_CollectionsViewModel.filterByRating'))
      .value;
  Computed<ObservableList<BoardGameDetails>>? _$filteredBoardGamesComputed;

  @override
  ObservableList<BoardGameDetails> get filteredBoardGames =>
      (_$filteredBoardGamesComputed ??=
              Computed<ObservableList<BoardGameDetails>>(
                  () => super.filteredBoardGames,
                  name: '_CollectionsViewModel.filteredBoardGames'))
          .value;
  Computed<bool>? _$anyBoardGamesInCollectionsComputed;

  @override
  bool get anyBoardGamesInCollections =>
      (_$anyBoardGamesInCollectionsComputed ??= Computed<bool>(
              () => super.anyBoardGamesInCollections,
              name: '_CollectionsViewModel.anyBoardGamesInCollections'))
          .value;
  Computed<bool>? _$anyBoardGamesComputed;

  @override
  bool get anyBoardGames =>
      (_$anyBoardGamesComputed ??= Computed<bool>(() => super.anyBoardGames,
              name: '_CollectionsViewModel.anyBoardGames'))
          .value;
  Computed<double>? _$minNumberOfPlayersComputed;

  @override
  double get minNumberOfPlayers => (_$minNumberOfPlayersComputed ??=
          Computed<double>(() => super.minNumberOfPlayers,
              name: '_CollectionsViewModel.minNumberOfPlayers'))
      .value;
  Computed<int?>? _$filterByNumberOfPlayersComputed;

  @override
  int? get filterByNumberOfPlayers => (_$filterByNumberOfPlayersComputed ??=
          Computed<int?>(() => super.filterByNumberOfPlayers,
              name: '_CollectionsViewModel.filterByNumberOfPlayers'))
      .value;
  Computed<String>? _$numberOfPlayersSliderValueComputed;

  @override
  String get numberOfPlayersSliderValue =>
      (_$numberOfPlayersSliderValueComputed ??= Computed<String>(
              () => super.numberOfPlayersSliderValue,
              name: '_CollectionsViewModel.numberOfPlayersSliderValue'))
          .value;
  Computed<double>? _$maxNumberOfPlayersComputed;

  @override
  double get maxNumberOfPlayers => (_$maxNumberOfPlayersComputed ??=
          Computed<double>(() => super.maxNumberOfPlayers,
              name: '_CollectionsViewModel.maxNumberOfPlayers'))
      .value;
  Computed<List<BoardGameDetails>>? _$allBoardGamesComputed;

  @override
  List<BoardGameDetails> get allBoardGames => (_$allBoardGamesComputed ??=
          Computed<List<BoardGameDetails>>(() => super.allBoardGames,
              name: '_CollectionsViewModel.allBoardGames'))
      .value;
  Computed<List<BoardGameDetails>>? _$boardGamesInCollectionComputed;

  @override
  List<BoardGameDetails> get boardGamesInCollection =>
      (_$boardGamesInCollectionComputed ??= Computed<List<BoardGameDetails>>(
              () => super.boardGamesInCollection,
              name: '_CollectionsViewModel.boardGamesInCollection'))
          .value;
  Computed<bool>? _$isCollectionEmptyComputed;

  @override
  bool get isCollectionEmpty => (_$isCollectionEmptyComputed ??= Computed<bool>(
          () => super.isCollectionEmpty,
          name: '_CollectionsViewModel.isCollectionEmpty'))
      .value;
  Computed<List<BoardGameDetails>>? _$baseGamesInCollectionComputed;

  @override
  List<BoardGameDetails> get baseGamesInCollection =>
      (_$baseGamesInCollectionComputed ??= Computed<List<BoardGameDetails>>(
              () => super.baseGamesInCollection,
              name: '_CollectionsViewModel.baseGamesInCollection'))
          .value;
  Computed<List<BoardGameDetails>>? _$expansionsInCollectionComputed;

  @override
  List<BoardGameDetails> get expansionsInCollection =>
      (_$expansionsInCollectionComputed ??= Computed<List<BoardGameDetails>>(
              () => super.expansionsInCollection,
              name: '_CollectionsViewModel.expansionsInCollection'))
          .value;
  Computed<bool>? _$anyBaseGamesInCollectionComputed;

  @override
  bool get anyBaseGamesInCollection => (_$anyBaseGamesInCollectionComputed ??=
          Computed<bool>(() => super.anyBaseGamesInCollection,
              name: '_CollectionsViewModel.anyBaseGamesInCollection'))
      .value;
  Computed<int>? _$baseGamesInCollectionTotalComputed;

  @override
  int get baseGamesInCollectionTotal =>
      (_$baseGamesInCollectionTotalComputed ??= Computed<int>(
              () => super.baseGamesInCollectionTotal,
              name: '_CollectionsViewModel.baseGamesInCollectionTotal'))
          .value;
  Computed<int>? _$expansionsInCollectionTotalComputed;

  @override
  int get expansionsInCollectionTotal =>
      (_$expansionsInCollectionTotalComputed ??= Computed<int>(
              () => super.expansionsInCollectionTotal,
              name: '_CollectionsViewModel.expansionsInCollectionTotal'))
          .value;
  Computed<bool>? _$anyExpansionsInCollectionComputed;

  @override
  bool get anyExpansionsInCollection => (_$anyExpansionsInCollectionComputed ??=
          Computed<bool>(() => super.anyExpansionsInCollection,
              name: '_CollectionsViewModel.anyExpansionsInCollection'))
      .value;
  Computed<Map<Tuple2<String, String>, List<BoardGameDetails>>>?
      _$expansionsInCollectionMapComputed;

  @override
  Map<Tuple2<String, String>, List<BoardGameDetails>>
      get expansionsInCollectionMap => (_$expansionsInCollectionMapComputed ??=
              Computed<Map<Tuple2<String, String>, List<BoardGameDetails>>>(
                  () => super.expansionsInCollectionMap,
                  name: '_CollectionsViewModel.expansionsInCollectionMap'))
          .value;
  Computed<List<BoardGameDetails>>? _$_allExpansionsComputed;

  @override
  List<BoardGameDetails> get _allExpansions => (_$_allExpansionsComputed ??=
          Computed<List<BoardGameDetails>>(() => super._allExpansions,
              name: '_CollectionsViewModel._allExpansions'))
      .value;
  Computed<String?>? _$userNameComputed;

  @override
  String? get userName =>
      (_$userNameComputed ??= Computed<String?>(() => super.userName,
              name: '_CollectionsViewModel.userName'))
          .value;
  Computed<bool>? _$isUserNameEmptyComputed;

  @override
  bool get isUserNameEmpty =>
      (_$isUserNameEmptyComputed ??= Computed<bool>(() => super.isUserNameEmpty,
              name: '_CollectionsViewModel.isUserNameEmpty'))
          .value;

  late final _$selectedTabAtom =
      Atom(name: '_CollectionsViewModel.selectedTab', context: context);

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

  late final _$futureLoadBoardGamesAtom = Atom(
      name: '_CollectionsViewModel.futureLoadBoardGames', context: context);

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

  late final _$_CollectionsViewModelActionController =
      ActionController(name: '_CollectionsViewModel', context: context);

  @override
  void setSelectedTab(GamesTab newlySelectedTab) {
    final _$actionInfo = _$_CollectionsViewModelActionController.startAction(
        name: '_CollectionsViewModel.setSelectedTab');
    try {
      return super.setSelectedTab(newlySelectedTab);
    } finally {
      _$_CollectionsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadBoardGames() {
    final _$actionInfo = _$_CollectionsViewModelActionController.startAction(
        name: '_CollectionsViewModel.loadBoardGames');
    try {
      return super.loadBoardGames();
    } finally {
      _$_CollectionsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSortBySelection(SortBy sortBy) {
    final _$actionInfo = _$_CollectionsViewModelActionController.startAction(
        name: '_CollectionsViewModel.updateSortBySelection');
    try {
      return super.updateSortBySelection(sortBy);
    } finally {
      _$_CollectionsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> clearFilters() {
    final _$actionInfo = _$_CollectionsViewModelActionController.startAction(
        name: '_CollectionsViewModel.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$_CollectionsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> changeNumberOfPlayers(int? numberOfPlayers) {
    final _$actionInfo = _$_CollectionsViewModelActionController.startAction(
        name: '_CollectionsViewModel.changeNumberOfPlayers');
    try {
      return super.changeNumberOfPlayers(numberOfPlayers);
    } finally {
      _$_CollectionsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> updateNumberOfPlayersFilter() {
    final _$actionInfo = _$_CollectionsViewModelActionController.startAction(
        name: '_CollectionsViewModel.updateNumberOfPlayersFilter');
    try {
      return super.updateNumberOfPlayersFilter();
    } finally {
      _$_CollectionsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> updateFilterByRating(double? rating) {
    final _$actionInfo = _$_CollectionsViewModelActionController.startAction(
        name: '_CollectionsViewModel.updateFilterByRating');
    try {
      return super.updateFilterByRating(rating);
    } finally {
      _$_CollectionsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTab: ${selectedTab},
futureLoadBoardGames: ${futureLoadBoardGames},
allMainGames: ${allMainGames},
sortByOptions: ${sortByOptions},
selectedSortBy: ${selectedSortBy},
anyFiltersApplied: ${anyFiltersApplied},
filterByRating: ${filterByRating},
filteredBoardGames: ${filteredBoardGames},
anyBoardGamesInCollections: ${anyBoardGamesInCollections},
anyBoardGames: ${anyBoardGames},
minNumberOfPlayers: ${minNumberOfPlayers},
filterByNumberOfPlayers: ${filterByNumberOfPlayers},
numberOfPlayersSliderValue: ${numberOfPlayersSliderValue},
maxNumberOfPlayers: ${maxNumberOfPlayers},
allBoardGames: ${allBoardGames},
boardGamesInCollection: ${boardGamesInCollection},
isCollectionEmpty: ${isCollectionEmpty},
baseGamesInCollection: ${baseGamesInCollection},
expansionsInCollection: ${expansionsInCollection},
anyBaseGamesInCollection: ${anyBaseGamesInCollection},
baseGamesInCollectionTotal: ${baseGamesInCollectionTotal},
expansionsInCollectionTotal: ${expansionsInCollectionTotal},
anyExpansionsInCollection: ${anyExpansionsInCollection},
expansionsInCollectionMap: ${expansionsInCollectionMap},
userName: ${userName},
isUserNameEmpty: ${isUserNameEmpty}
    ''';
  }
}
