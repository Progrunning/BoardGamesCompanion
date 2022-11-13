// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_details_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BoardGameDetailsViewModel on _BoardGameDetailsViewModel, Store {
  Computed<BoardGameDetails>? _$boardGameComputed;

  @override
  BoardGameDetails get boardGame =>
      (_$boardGameComputed ??= Computed<BoardGameDetails>(() => super.boardGame,
              name: '_BoardGameDetailsViewModel.boardGame'))
          .value;
  Computed<String?>? _$boardGameImageUrlComputed;

  @override
  String? get boardGameImageUrl => (_$boardGameImageUrlComputed ??=
          Computed<String?>(() => super.boardGameImageUrl,
              name: '_BoardGameDetailsViewModel.boardGameImageUrl'))
      .value;
  Computed<bool>? _$isMainGameComputed;

  @override
  bool get isMainGame =>
      (_$isMainGameComputed ??= Computed<bool>(() => super.isMainGame,
              name: '_BoardGameDetailsViewModel.isMainGame'))
          .value;
  Computed<bool>? _$isExpansionComputed;

  @override
  bool get isExpansion =>
      (_$isExpansionComputed ??= Computed<bool>(() => super.isExpansion,
              name: '_BoardGameDetailsViewModel.isExpansion'))
          .value;
  Computed<List<BoardGameExpansion>>? _$expansionsComputed;

  @override
  List<BoardGameExpansion> get expansions => (_$expansionsComputed ??=
          Computed<List<BoardGameExpansion>>(() => super.expansions,
              name: '_BoardGameDetailsViewModel.expansions'))
      .value;
  Computed<bool>? _$hasExpansionsComputed;

  @override
  bool get hasExpansions =>
      (_$hasExpansionsComputed ??= Computed<bool>(() => super.hasExpansions,
              name: '_BoardGameDetailsViewModel.hasExpansions'))
          .value;
  Computed<int>? _$totalExpansionsOwnedComputed;

  @override
  int get totalExpansionsOwned => (_$totalExpansionsOwnedComputed ??=
          Computed<int>(() => super.totalExpansionsOwned,
              name: '_BoardGameDetailsViewModel.totalExpansionsOwned'))
      .value;
  Computed<String>? _$unescapedDescriptionComputed;

  @override
  String get unescapedDescription => (_$unescapedDescriptionComputed ??=
          Computed<String>(() => super.unescapedDescription,
              name: '_BoardGameDetailsViewModel.unescapedDescription'))
      .value;

  late final _$futureLoadBoardGameDetailsAtom = Atom(
      name: '_BoardGameDetailsViewModel.futureLoadBoardGameDetails',
      context: context);

  @override
  ObservableFuture<void>? get futureLoadBoardGameDetails {
    _$futureLoadBoardGameDetailsAtom.reportRead();
    return super.futureLoadBoardGameDetails;
  }

  @override
  set futureLoadBoardGameDetails(ObservableFuture<void>? value) {
    _$futureLoadBoardGameDetailsAtom
        .reportWrite(value, super.futureLoadBoardGameDetails, () {
      super.futureLoadBoardGameDetails = value;
    });
  }

  late final _$toggleCollectionAsyncAction = AsyncAction(
      '_BoardGameDetailsViewModel.toggleCollection',
      context: context);

  @override
  Future<void> toggleCollection(CollectionType collectionType) {
    return _$toggleCollectionAsyncAction
        .run(() => super.toggleCollection(collectionType));
  }

  late final _$_BoardGameDetailsViewModelActionController =
      ActionController(name: '_BoardGameDetailsViewModel', context: context);

  @override
  void loadBoardGameDetails() {
    final _$actionInfo = _$_BoardGameDetailsViewModelActionController
        .startAction(name: '_BoardGameDetailsViewModel.loadBoardGameDetails');
    try {
      return super.loadBoardGameDetails();
    } finally {
      _$_BoardGameDetailsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
futureLoadBoardGameDetails: ${futureLoadBoardGameDetails},
boardGame: ${boardGame},
boardGameImageUrl: ${boardGameImageUrl},
isMainGame: ${isMainGame},
isExpansion: ${isExpansion},
expansions: ${expansions},
hasExpansions: ${hasExpansions},
totalExpansionsOwned: ${totalExpansionsOwned},
unescapedDescription: ${unescapedDescription}
    ''';
  }
}
