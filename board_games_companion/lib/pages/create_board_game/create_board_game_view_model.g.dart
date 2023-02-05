// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_board_game_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreateBoardGameViewModel on _CreateBoardGameViewModel, Store {
  Computed<String>? _$boardGameNameComputed;

  @override
  String get boardGameName =>
      (_$boardGameNameComputed ??= Computed<String>(() => super.boardGameName,
              name: '_CreateBoardGameViewModel.boardGameName'))
          .value;

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

  late final _$boardGameImageUriAtom = Atom(
      name: '_CreateBoardGameViewModel.boardGameImageUri', context: context);

  @override
  String? get boardGameImageUri {
    _$boardGameImageUriAtom.reportRead();
    return super.boardGameImageUri;
  }

  @override
  set boardGameImageUri(String? value) {
    _$boardGameImageUriAtom.reportWrite(value, super.boardGameImageUri, () {
      super.boardGameImageUri = value;
    });
  }

  late final _$_CreateBoardGameViewModelActionController =
      ActionController(name: '_CreateBoardGameViewModel', context: context);

  @override
  void setBoardGameName(String boardGameName) {
    final _$actionInfo = _$_CreateBoardGameViewModelActionController
        .startAction(name: '_CreateBoardGameViewModel.setBoardGameName');
    try {
      return super.setBoardGameName(boardGameName);
    } finally {
      _$_CreateBoardGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBoardGameImage(String boardGameImageUri) {
    final _$actionInfo = _$_CreateBoardGameViewModelActionController
        .startAction(name: '_CreateBoardGameViewModel.setBoardGameImage');
    try {
      return super.setBoardGameImage(boardGameImageUri);
    } finally {
      _$_CreateBoardGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveBoardGame() {
    final _$actionInfo = _$_CreateBoardGameViewModelActionController
        .startAction(name: '_CreateBoardGameViewModel.saveBoardGame');
    try {
      return super.saveBoardGame();
    } finally {
      _$_CreateBoardGameViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
boardGameImageUri: ${boardGameImageUri},
boardGameName: ${boardGameName}
    ''';
  }
}
