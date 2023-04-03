// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsViewModel on _PlaythroughsViewModel, Store {
  Computed<String>? _$boardGameIdComputed;

  @override
  String get boardGameId =>
      (_$boardGameIdComputed ??= Computed<String>(() => super.boardGameId,
              name: '_PlaythroughsViewModel.boardGameId'))
          .value;
  Computed<String>? _$boardGameNameComputed;

  @override
  String get boardGameName =>
      (_$boardGameNameComputed ??= Computed<String>(() => super.boardGameName,
              name: '_PlaythroughsViewModel.boardGameName'))
          .value;
  Computed<bool>? _$isCreatedByUserComputed;

  @override
  bool get isCreatedByUser =>
      (_$isCreatedByUserComputed ??= Computed<bool>(() => super.isCreatedByUser,
              name: '_PlaythroughsViewModel.isCreatedByUser'))
          .value;
  Computed<bool>? _$hasUserComputed;

  @override
  bool get hasUser => (_$hasUserComputed ??= Computed<bool>(() => super.hasUser,
          name: '_PlaythroughsViewModel.hasUser'))
      .value;
  Computed<String?>? _$userNameComputed;

  @override
  String? get userName =>
      (_$userNameComputed ??= Computed<String?>(() => super.userName,
              name: '_PlaythroughsViewModel.userName'))
          .value;
  Computed<bool>? _$canImportGamesComputed;

  @override
  bool get canImportGames =>
      (_$canImportGamesComputed ??= Computed<bool>(() => super.canImportGames,
              name: '_PlaythroughsViewModel.canImportGames'))
          .value;
  Computed<String>? _$gamePlaylistUrlComputed;

  @override
  String get gamePlaylistUrl => (_$gamePlaylistUrlComputed ??= Computed<String>(
          () => super.gamePlaylistUrl,
          name: '_PlaythroughsViewModel.gamePlaylistUrl'))
      .value;
  Computed<GameFamily>? _$gameFamilyComputed;

  @override
  GameFamily get gameFamily =>
      (_$gameFamilyComputed ??= Computed<GameFamily>(() => super.gameFamily,
              name: '_PlaythroughsViewModel.gameFamily'))
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
boardGameId: ${boardGameId},
boardGameName: ${boardGameName},
isCreatedByUser: ${isCreatedByUser},
hasUser: ${hasUser},
userName: ${userName},
canImportGames: ${canImportGames},
gamePlaylistUrl: ${gamePlaylistUrl},
gameFamily: ${gameFamily}
    ''';
  }
}
