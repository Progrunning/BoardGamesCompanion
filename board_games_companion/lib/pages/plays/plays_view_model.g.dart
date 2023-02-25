// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plays_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaysViewModel on _PlaysViewModel, Store {
  Computed<Map<String, Score>>? _$_scoresComputed;

  @override
  Map<String, Score> get _scores =>
      (_$_scoresComputed ??= Computed<Map<String, Score>>(() => super._scores,
              name: '_PlaysViewModel._scores'))
          .value;
  Computed<List<Playthrough>>? _$finishedPlaythroughsComputed;

  @override
  List<Playthrough> get finishedPlaythroughs =>
      (_$finishedPlaythroughsComputed ??= Computed<List<Playthrough>>(
              () => super.finishedPlaythroughs,
              name: '_PlaysViewModel.finishedPlaythroughs'))
          .value;
  Computed<List<GroupedBoardGamePlaythroughs>>?
      _$finishedBoardGamePlaythroughsComputed;

  @override
  List<GroupedBoardGamePlaythroughs> get finishedBoardGamePlaythroughs =>
      (_$finishedBoardGamePlaythroughsComputed ??=
              Computed<List<GroupedBoardGamePlaythroughs>>(
                  () => super.finishedBoardGamePlaythroughs,
                  name: '_PlaysViewModel.finishedBoardGamePlaythroughs'))
          .value;
  Computed<bool>? _$hasAnyFinishedPlaythroughsComputed;

  @override
  bool get hasAnyFinishedPlaythroughs =>
      (_$hasAnyFinishedPlaythroughsComputed ??= Computed<bool>(
              () => super.hasAnyFinishedPlaythroughs,
              name: '_PlaysViewModel.hasAnyFinishedPlaythroughs'))
          .value;
  Computed<bool>? _$hasAnyBoardGamesComputed;

  @override
  bool get hasAnyBoardGames => (_$hasAnyBoardGamesComputed ??= Computed<bool>(
          () => super.hasAnyBoardGames,
          name: '_PlaysViewModel.hasAnyBoardGames'))
      .value;
  Computed<bool>? _$hasAnyBoardGamesToShuffleComputed;

  @override
  bool get hasAnyBoardGamesToShuffle => (_$hasAnyBoardGamesToShuffleComputed ??=
          Computed<bool>(() => super.hasAnyBoardGamesToShuffle,
              name: '_PlaysViewModel.hasAnyBoardGamesToShuffle'))
      .value;
  Computed<int>? _$minNumberOfPlayersComputed;

  @override
  int get minNumberOfPlayers => (_$minNumberOfPlayersComputed ??= Computed<int>(
          () => super.minNumberOfPlayers,
          name: '_PlaysViewModel.minNumberOfPlayers'))
      .value;
  Computed<int>? _$maxNumberOfPlayersComputed;

  @override
  int get maxNumberOfPlayers => (_$maxNumberOfPlayersComputed ??= Computed<int>(
          () => super.maxNumberOfPlayers,
          name: '_PlaysViewModel.maxNumberOfPlayers'))
      .value;
  Computed<List<BoardGameDetails>>? _$shuffledBoardGamesComputed;

  @override
  List<BoardGameDetails> get shuffledBoardGames =>
      (_$shuffledBoardGamesComputed ??= Computed<List<BoardGameDetails>>(
              () => super.shuffledBoardGames,
              name: '_PlaysViewModel.shuffledBoardGames'))
          .value;
  Computed<int>? _$randomItemIndexComputed;

  @override
  int get randomItemIndex =>
      (_$randomItemIndexComputed ??= Computed<int>(() => super.randomItemIndex,
              name: '_PlaysViewModel.randomItemIndex'))
          .value;

  late final _$_shuffledBoardGamesAtom =
      Atom(name: '_PlaysViewModel._shuffledBoardGames', context: context);

  @override
  List<BoardGameDetails> get _shuffledBoardGames {
    _$_shuffledBoardGamesAtom.reportRead();
    return super._shuffledBoardGames;
  }

  @override
  set _shuffledBoardGames(List<BoardGameDetails> value) {
    _$_shuffledBoardGamesAtom.reportWrite(value, super._shuffledBoardGames, () {
      super._shuffledBoardGames = value;
    });
  }

  late final _$futureLoadGamesPlaythroughsAtom = Atom(
      name: '_PlaysViewModel.futureLoadGamesPlaythroughs', context: context);

  @override
  ObservableFuture<void>? get futureLoadGamesPlaythroughs {
    _$futureLoadGamesPlaythroughsAtom.reportRead();
    return super.futureLoadGamesPlaythroughs;
  }

  @override
  set futureLoadGamesPlaythroughs(ObservableFuture<void>? value) {
    _$futureLoadGamesPlaythroughsAtom
        .reportWrite(value, super.futureLoadGamesPlaythroughs, () {
      super.futureLoadGamesPlaythroughs = value;
    });
  }

  late final _$visualStateAtom =
      Atom(name: '_PlaysViewModel.visualState', context: context);

  @override
  PlaysPageVisualState? get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(PlaysPageVisualState? value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$gameSpinnerFiltersAtom =
      Atom(name: '_PlaysViewModel.gameSpinnerFilters', context: context);

  @override
  GameSpinnerFilters get gameSpinnerFilters {
    _$gameSpinnerFiltersAtom.reportRead();
    return super.gameSpinnerFilters;
  }

  @override
  set gameSpinnerFilters(GameSpinnerFilters value) {
    _$gameSpinnerFiltersAtom.reportWrite(value, super.gameSpinnerFilters, () {
      super.gameSpinnerFilters = value;
    });
  }

  late final _$_PlaysViewModelActionController =
      ActionController(name: '_PlaysViewModel', context: context);

  @override
  void loadGamesPlaythroughs() {
    final _$actionInfo = _$_PlaysViewModelActionController.startAction(
        name: '_PlaysViewModel.loadGamesPlaythroughs');
    try {
      return super.loadGamesPlaythroughs();
    } finally {
      _$_PlaysViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectTab(PlaysTab selectedTab) {
    final _$actionInfo = _$_PlaysViewModelActionController.startAction(
        name: '_PlaysViewModel.setSelectTab');
    try {
      return super.setSelectTab(selectedTab);
    } finally {
      _$_PlaysViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleGameSpinnerCollectionFilter(CollectionType collectionTypeToggled) {
    final _$actionInfo = _$_PlaysViewModelActionController.startAction(
        name: '_PlaysViewModel.toggleGameSpinnerCollectionFilter');
    try {
      return super.toggleGameSpinnerCollectionFilter(collectionTypeToggled);
    } finally {
      _$_PlaysViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleIncludeExpansionsFilter(bool? includeExpansions) {
    final _$actionInfo = _$_PlaysViewModelActionController.startAction(
        name: '_PlaysViewModel.toggleIncludeExpansionsFilter');
    try {
      return super.toggleIncludeExpansionsFilter(includeExpansions);
    } finally {
      _$_PlaysViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateNumberOfPlayersNumber(
      NumberOfPlayersFilter numberOfPlayersFilter) {
    final _$actionInfo = _$_PlaysViewModelActionController.startAction(
        name: '_PlaysViewModel.updateNumberOfPlayersNumber');
    try {
      return super.updateNumberOfPlayersNumber(numberOfPlayersFilter);
    } finally {
      _$_PlaysViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
futureLoadGamesPlaythroughs: ${futureLoadGamesPlaythroughs},
visualState: ${visualState},
gameSpinnerFilters: ${gameSpinnerFilters},
finishedPlaythroughs: ${finishedPlaythroughs},
finishedBoardGamePlaythroughs: ${finishedBoardGamePlaythroughs},
hasAnyFinishedPlaythroughs: ${hasAnyFinishedPlaythroughs},
hasAnyBoardGames: ${hasAnyBoardGames},
hasAnyBoardGamesToShuffle: ${hasAnyBoardGamesToShuffle},
minNumberOfPlayers: ${minNumberOfPlayers},
maxNumberOfPlayers: ${maxNumberOfPlayers},
shuffledBoardGames: ${shuffledBoardGames},
randomItemIndex: ${randomItemIndex}
    ''';
  }
}
