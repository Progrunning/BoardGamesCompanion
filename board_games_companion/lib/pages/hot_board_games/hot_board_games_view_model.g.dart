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

  late final _$visualStateAtom =
      Atom(name: '_HotBoardGamesViewModel.visualState', context: context);

  @override
  HotBoardGamesPageVisualState get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(HotBoardGamesPageVisualState value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$loadHotBoardGamesAsyncAction = AsyncAction(
      '_HotBoardGamesViewModel.loadHotBoardGames',
      context: context);

  @override
  Future<void> loadHotBoardGames() {
    return _$loadHotBoardGamesAsyncAction.run(() => super.loadHotBoardGames());
  }

  @override
  String toString() {
    return '''
hotBoardGames: ${hotBoardGames},
visualState: ${visualState},
hasAnyHotBoardGames: ${hasAnyHotBoardGames}
    ''';
  }
}
