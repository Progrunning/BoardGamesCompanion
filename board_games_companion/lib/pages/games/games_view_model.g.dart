// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GamesViewModel on _GamesViewModel, Store {
  Computed<List<BoardGameDetails>>? _$allMainGamesComputed;

  @override
  List<BoardGameDetails> get allMainGames => (_$allMainGamesComputed ??=
          Computed<List<BoardGameDetails>>(() => super.allMainGames,
              name: '_GamesViewModel.allMainGames'))
      .value;
  Computed<ObservableMap<String, BoardGameDetails>>?
      _$_mainBoardGameByExpansionIdComputed;

  @override
  ObservableMap<String, BoardGameDetails> get _mainBoardGameByExpansionId =>
      (_$_mainBoardGameByExpansionIdComputed ??=
              Computed<ObservableMap<String, BoardGameDetails>>(
                  () => super._mainBoardGameByExpansionId,
                  name: '_GamesViewModel._mainBoardGameByExpansionId'))
          .value;
  Computed<List<SortBy>>? _$sortByOptionsComputed;

  @override
  List<SortBy> get sortByOptions => (_$sortByOptionsComputed ??=
          Computed<List<SortBy>>(() => super.sortByOptions,
              name: '_GamesViewModel.sortByOptions'))
      .value;
  Computed<SortBy?>? _$selectedSortByComputed;

  @override
  SortBy? get selectedSortBy => (_$selectedSortByComputed ??= Computed<SortBy?>(
          () => super.selectedSortBy,
          name: '_GamesViewModel.selectedSortBy'))
      .value;
  Computed<bool>? _$anyFiltersAppliedComputed;

  @override
  bool get anyFiltersApplied => (_$anyFiltersAppliedComputed ??= Computed<bool>(
          () => super.anyFiltersApplied,
          name: '_GamesViewModel.anyFiltersApplied'))
      .value;
  Computed<double?>? _$filterByRatingComputed;

  @override
  double? get filterByRating => (_$filterByRatingComputed ??= Computed<double?>(
          () => super.filterByRating,
          name: '_GamesViewModel.filterByRating'))
      .value;
  Computed<ObservableList<BoardGameDetails>>? _$filteredBoardGamesComputed;

  @override
  ObservableList<BoardGameDetails> get filteredBoardGames =>
      (_$filteredBoardGamesComputed ??=
              Computed<ObservableList<BoardGameDetails>>(
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
  Computed<double>? _$minNumberOfPlayersComputed;

  @override
  double get minNumberOfPlayers => (_$minNumberOfPlayersComputed ??=
          Computed<double>(() => super.minNumberOfPlayers,
              name: '_GamesViewModel.minNumberOfPlayers'))
      .value;
  Computed<int?>? _$filterByNumberOfPlayersComputed;

  @override
  int? get filterByNumberOfPlayers => (_$filterByNumberOfPlayersComputed ??=
          Computed<int?>(() => super.filterByNumberOfPlayers,
              name: '_GamesViewModel.filterByNumberOfPlayers'))
      .value;
  Computed<String>? _$numberOfPlayersSliderValueComputed;

  @override
  String get numberOfPlayersSliderValue =>
      (_$numberOfPlayersSliderValueComputed ??= Computed<String>(
              () => super.numberOfPlayersSliderValue,
              name: '_GamesViewModel.numberOfPlayersSliderValue'))
          .value;
  Computed<double>? _$maxNumberOfPlayersComputed;

  @override
  double get maxNumberOfPlayers => (_$maxNumberOfPlayersComputed ??=
          Computed<double>(() => super.maxNumberOfPlayers,
              name: '_GamesViewModel.maxNumberOfPlayers'))
      .value;
  Computed<List<BoardGameDetails>>? _$allBoardGamesComputed;

  @override
  List<BoardGameDetails> get allBoardGames => (_$allBoardGamesComputed ??=
          Computed<List<BoardGameDetails>>(() => super.allBoardGames,
              name: '_GamesViewModel.allBoardGames'))
      .value;
  Computed<List<BoardGameDetails>>? _$boardGamesInCollectionComputed;

  @override
  List<BoardGameDetails> get boardGamesInCollection =>
      (_$boardGamesInCollectionComputed ??= Computed<List<BoardGameDetails>>(
              () => super.boardGamesInCollection,
              name: '_GamesViewModel.boardGamesInCollection'))
          .value;
  Computed<bool>? _$isCollectionEmptyComputed;

  @override
  bool get isCollectionEmpty => (_$isCollectionEmptyComputed ??= Computed<bool>(
          () => super.isCollectionEmpty,
          name: '_GamesViewModel.isCollectionEmpty'))
      .value;
  Computed<List<BoardGameDetails>>? _$mainGamesInCollectionComputed;

  @override
  List<BoardGameDetails> get mainGamesInCollection =>
      (_$mainGamesInCollectionComputed ??= Computed<List<BoardGameDetails>>(
              () => super.mainGamesInCollection,
              name: '_GamesViewModel.mainGamesInCollection'))
          .value;
  Computed<List<BoardGameDetails>>? _$expansionsInCollectionComputed;

  @override
  List<BoardGameDetails> get expansionsInCollection =>
      (_$expansionsInCollectionComputed ??= Computed<List<BoardGameDetails>>(
              () => super.expansionsInCollection,
              name: '_GamesViewModel.expansionsInCollection'))
          .value;
  Computed<bool>? _$anyMainGamesInCollectionComputed;

  @override
  bool get anyMainGamesInCollection => (_$anyMainGamesInCollectionComputed ??=
          Computed<bool>(() => super.anyMainGamesInCollection,
              name: '_GamesViewModel.anyMainGamesInCollection'))
      .value;
  Computed<int>? _$totalMainGamesInCollectionComputed;

  @override
  int get totalMainGamesInCollection =>
      (_$totalMainGamesInCollectionComputed ??= Computed<int>(
              () => super.totalMainGamesInCollection,
              name: '_GamesViewModel.totalMainGamesInCollection'))
          .value;
  Computed<int>? _$totalExpansionsInCollectionComputed;

  @override
  int get totalExpansionsInCollection =>
      (_$totalExpansionsInCollectionComputed ??= Computed<int>(
              () => super.totalExpansionsInCollection,
              name: '_GamesViewModel.totalExpansionsInCollection'))
          .value;
  Computed<bool>? _$anyExpansionsInCollectionComputed;

  @override
  bool get anyExpansionsInCollection => (_$anyExpansionsInCollectionComputed ??=
          Computed<bool>(() => super.anyExpansionsInCollection,
              name: '_GamesViewModel.anyExpansionsInCollection'))
      .value;
  Computed<Map<Tuple2<String, String>, List<BoardGameDetails>>>?
      _$expansionsInCollectionMapComputed;

  @override
  Map<Tuple2<String, String>, List<BoardGameDetails>>
      get expansionsInCollectionMap => (_$expansionsInCollectionMapComputed ??=
              Computed<Map<Tuple2<String, String>, List<BoardGameDetails>>>(
                  () => super.expansionsInCollectionMap,
                  name: '_GamesViewModel.expansionsInCollectionMap'))
          .value;
  Computed<List<BoardGameDetails>>? _$_allExpansionsComputed;

  @override
  List<BoardGameDetails> get _allExpansions => (_$_allExpansionsComputed ??=
          Computed<List<BoardGameDetails>>(() => super._allExpansions,
              name: '_GamesViewModel._allExpansions'))
      .value;
  Computed<String?>? _$userNameComputed;

  @override
  String? get userName =>
      (_$userNameComputed ??= Computed<String?>(() => super.userName,
              name: '_GamesViewModel.userName'))
          .value;
  Computed<bool>? _$isUserNameEmptyComputed;

  @override
  bool get isUserNameEmpty =>
      (_$isUserNameEmptyComputed ??= Computed<bool>(() => super.isUserNameEmpty,
              name: '_GamesViewModel.isUserNameEmpty'))
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
  void updateSortBySelection(SortBy sortBy) {
    final _$actionInfo = _$_GamesViewModelActionController.startAction(
        name: '_GamesViewModel.updateSortBySelection');
    try {
      return super.updateSortBySelection(sortBy);
    } finally {
      _$_GamesViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> clearFilters() {
    final _$actionInfo = _$_GamesViewModelActionController.startAction(
        name: '_GamesViewModel.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$_GamesViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> changeNumberOfPlayers(int? numberOfPlayers) {
    final _$actionInfo = _$_GamesViewModelActionController.startAction(
        name: '_GamesViewModel.changeNumberOfPlayers');
    try {
      return super.changeNumberOfPlayers(numberOfPlayers);
    } finally {
      _$_GamesViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> updateNumberOfPlayersFilter() {
    final _$actionInfo = _$_GamesViewModelActionController.startAction(
        name: '_GamesViewModel.updateNumberOfPlayersFilter');
    try {
      return super.updateNumberOfPlayersFilter();
    } finally {
      _$_GamesViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> updateFilterByRating(double? rating) {
    final _$actionInfo = _$_GamesViewModelActionController.startAction(
        name: '_GamesViewModel.updateFilterByRating');
    try {
      return super.updateFilterByRating(rating);
    } finally {
      _$_GamesViewModelActionController.endAction(_$actionInfo);
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
mainGamesInCollection: ${mainGamesInCollection},
expansionsInCollection: ${expansionsInCollection},
anyMainGamesInCollection: ${anyMainGamesInCollection},
totalMainGamesInCollection: ${totalMainGamesInCollection},
totalExpansionsInCollection: ${totalExpansionsInCollection},
anyExpansionsInCollection: ${anyExpansionsInCollection},
expansionsInCollectionMap: ${expansionsInCollectionMap},
userName: ${userName},
isUserNameEmpty: ${isUserNameEmpty}
    ''';
  }
}
