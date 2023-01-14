// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_board_games_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HotBoardGamesViewModel on _HotBoardGamesViewModel, Store {
  Computed<bool>? _$hasAnyHotBoardGamesComputed;

  @override
  bool get hasAnyHotBoardGames => (_$hasAnyHotBoardGamesComputed ??=
          Computed<bool>(() => super.hasAnyHotBoardGames,
              name: '_HotBoardGamesViewModel.hasAnyHotBoardGames'))
      .value;
  Computed<bool>? _$isSearchPhraseEmptyComputed;

  @override
  bool get isSearchPhraseEmpty => (_$isSearchPhraseEmptyComputed ??=
          Computed<bool>(() => super.isSearchPhraseEmpty,
              name: '_HotBoardGamesViewModel.isSearchPhraseEmpty'))
      .value;

  late final _$hotBoardGamesAtom =
      Atom(name: '_HotBoardGamesViewModel.hotBoardGames', context: context);

  @override
  ObservableList<BoardGameDetails>? get hotBoardGames {
    _$hotBoardGamesAtom.reportRead();
    return super.hotBoardGames;
  }

  @override
  set hotBoardGames(ObservableList<BoardGameDetails>? value) {
    _$hotBoardGamesAtom.reportWrite(value, super.hotBoardGames, () {
      super.hotBoardGames = value;
    });
  }

  late final _$futureLoadHotBoardGamesAtom = Atom(
      name: '_HotBoardGamesViewModel.futureLoadHotBoardGames',
      context: context);

  @override
  ObservableFuture<void>? get futureLoadHotBoardGames {
    _$futureLoadHotBoardGamesAtom.reportRead();
    return super.futureLoadHotBoardGames;
  }

  @override
  set futureLoadHotBoardGames(ObservableFuture<void>? value) {
    _$futureLoadHotBoardGamesAtom
        .reportWrite(value, super.futureLoadHotBoardGames, () {
      super.futureLoadHotBoardGames = value;
    });
  }

  late final _$futureSearchBoardGamesAtom = Atom(
      name: '_HotBoardGamesViewModel.futureSearchBoardGames', context: context);

  @override
  ObservableFuture<void>? get futureSearchBoardGames {
    _$futureSearchBoardGamesAtom.reportRead();
    return super.futureSearchBoardGames;
  }

  @override
  set futureSearchBoardGames(ObservableFuture<void>? value) {
    _$futureSearchBoardGamesAtom
        .reportWrite(value, super.futureSearchBoardGames, () {
      super.futureSearchBoardGames = value;
    });
  }

  late final _$searchPhraseAtom =
      Atom(name: '_HotBoardGamesViewModel.searchPhrase', context: context);

  @override
  String? get searchPhrase {
    _$searchPhraseAtom.reportRead();
    return super.searchPhrase;
  }

  @override
  set searchPhrase(String? value) {
    _$searchPhraseAtom.reportWrite(value, super.searchPhrase, () {
      super.searchPhrase = value;
    });
  }

  late final _$_HotBoardGamesViewModelActionController =
      ActionController(name: '_HotBoardGamesViewModel', context: context);

  @override
  void loadHotBoardGames() {
    final _$actionInfo = _$_HotBoardGamesViewModelActionController.startAction(
        name: '_HotBoardGamesViewModel.loadHotBoardGames');
    try {
      return super.loadHotBoardGames();
    } finally {
      _$_HotBoardGamesViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchPhrase(String? searchPhrase) {
    final _$actionInfo = _$_HotBoardGamesViewModelActionController.startAction(
        name: '_HotBoardGamesViewModel.setSearchPhrase');
    try {
      return super.setSearchPhrase(searchPhrase);
    } finally {
      _$_HotBoardGamesViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hotBoardGames: ${hotBoardGames},
futureLoadHotBoardGames: ${futureLoadHotBoardGames},
futureSearchBoardGames: ${futureSearchBoardGames},
searchPhrase: ${searchPhrase},
hasAnyHotBoardGames: ${hasAnyHotBoardGames},
isSearchPhraseEmpty: ${isSearchPhraseEmpty}
    ''';
  }
}
