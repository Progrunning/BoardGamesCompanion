// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsViewModel on _PlaythroughsViewModel, Store {
  Computed<BoardGameDetails>? _$boardGameComputed;

  @override
  BoardGameDetails get boardGame =>
      (_$boardGameComputed ??= Computed<BoardGameDetails>(() => super.boardGame,
              name: '_PlaythroughsViewModel.boardGame'))
          .value;

  late final _$_PlaythroughsViewModelActionController =
      ActionController(name: '_PlaythroughsViewModel', context: context);

  @override
  void setBoardGame(BoardGameDetails boardGame) {
    final _$actionInfo = _$_PlaythroughsViewModelActionController.startAction(
        name: '_PlaythroughsViewModel.setBoardGame');
    try {
      return super.setBoardGame(boardGame);
    } finally {
      _$_PlaythroughsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
boardGame: ${boardGame}
    ''';
  }
}
