// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_board_games_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchBoardGamesViewModel on _SearchBoardGamesViewModel, Store {
  Computed<bool>? _$hasAnyHotBoardGamesComputed;

  @override
  bool get hasAnyHotBoardGames => (_$hasAnyHotBoardGamesComputed ??=
          Computed<bool>(() => super.hasAnyHotBoardGames,
              name: '_SearchBoardGamesViewModel.hasAnyHotBoardGames'))
      .value;

  late final _$hotBoardGamesAtom =
      Atom(name: '_SearchBoardGamesViewModel.hotBoardGames', context: context);

  @override
  ObservableList<BoardGame>? get hotBoardGames {
    _$hotBoardGamesAtom.reportRead();
    return super.hotBoardGames;
  }

  @override
  set hotBoardGames(ObservableList<BoardGame>? value) {
    _$hotBoardGamesAtom.reportWrite(value, super.hotBoardGames, () {
      super.hotBoardGames = value;
    });
  }

  late final _$futureLoadHotBoardGamesAtom = Atom(
      name: '_SearchBoardGamesViewModel.futureLoadHotBoardGames',
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

  @override
  String toString() {
    return '''
hotBoardGames: ${hotBoardGames},
futureLoadHotBoardGames: ${futureLoadHotBoardGames},
hasAnyHotBoardGames: ${hasAnyHotBoardGames}
    ''';
  }
}
