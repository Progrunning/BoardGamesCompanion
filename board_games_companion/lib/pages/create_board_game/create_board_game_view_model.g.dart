// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_board_game_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreateBoardGameViewModel on _CreateBoardGameViewModel, Store {
  Computed<BoardGameDetails>? _$boardGameComputed;

  @override
  BoardGameDetails get boardGame =>
      (_$boardGameComputed ??= Computed<BoardGameDetails>(() => super.boardGame,
              name: '_CreateBoardGameViewModel.boardGame'))
          .value;

  late final _$visualStateAtom =
      Atom(name: '_CreateBoardGameViewModel.visualState', context: context);

  @override
  CreateBoardGamePageVisualStates get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(CreateBoardGamePageVisualStates value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$_boardGameAtom =
      Atom(name: '_CreateBoardGameViewModel._boardGame', context: context);

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

  late final _$_boardGameNameAtom =
      Atom(name: '_CreateBoardGameViewModel._boardGameName', context: context);

  @override
  String? get _boardGameName {
    _$_boardGameNameAtom.reportRead();
    return super._boardGameName;
  }

  @override
  set _boardGameName(String? value) {
    _$_boardGameNameAtom.reportWrite(value, super._boardGameName, () {
      super._boardGameName = value;
    });
  }

  late final _$saveBoardGameAsyncAction =
      AsyncAction('_CreateBoardGameViewModel.saveBoardGame', context: context);

  @override
  Future<void> saveBoardGame() {
    return _$saveBoardGameAsyncAction.run(() => super.saveBoardGame());
  }

  late final _$_CreateBoardGameViewModelActionController =
      ActionController(name: '_CreateBoardGameViewModel', context: context);

  @override
  void setBoardGameName(String name) {
    final _$actionInfo = _$_CreateBoardGameViewModelActionController
        .startAction(name: '_CreateBoardGameViewModel.setBoardGameName');
    try {
      return super.setBoardGameName(name);
    } finally {
      _$_CreateBoardGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBoardGameImage(String imageUri) {
    final _$actionInfo = _$_CreateBoardGameViewModelActionController
        .startAction(name: '_CreateBoardGameViewModel.setBoardGameImage');
    try {
      return super.setBoardGameImage(imageUri);
    } finally {
      _$_CreateBoardGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleCollection(CollectionType collectionType) {
    final _$actionInfo = _$_CreateBoardGameViewModelActionController
        .startAction(name: '_CreateBoardGameViewModel.toggleCollection');
    try {
      return super.toggleCollection(collectionType);
    } finally {
      _$_CreateBoardGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
visualState: ${visualState},
boardGame: ${boardGame}
    ''';
  }
}
