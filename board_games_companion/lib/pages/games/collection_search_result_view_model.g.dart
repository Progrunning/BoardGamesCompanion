// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_search_result_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CollectionSearchResultViewModel
    on _CollectionSearchResultViewModel, Store {
  Computed<BoardGameDetails?>? _$boardGameComputed;

  @override
  BoardGameDetails? get boardGame => (_$boardGameComputed ??=
          Computed<BoardGameDetails?>(() => super.boardGame,
              name: '_CollectionSearchResultViewModel.boardGame'))
      .value;
  Computed<bool>? _$isExpansionComputed;

  @override
  bool get isExpansion =>
      (_$isExpansionComputed ??= Computed<bool>(() => super.isExpansion,
              name: '_CollectionSearchResultViewModel.isExpansion'))
          .value;
  Computed<bool>? _$isMainGameComputed;

  @override
  bool get isMainGame =>
      (_$isMainGameComputed ??= Computed<bool>(() => super.isMainGame,
              name: '_CollectionSearchResultViewModel.isMainGame'))
          .value;
  Computed<List<BoardGameDetails>>? _$expansionsComputed;

  @override
  List<BoardGameDetails> get expansions => (_$expansionsComputed ??=
          Computed<List<BoardGameDetails>>(() => super.expansions,
              name: '_CollectionSearchResultViewModel.expansions'))
      .value;

  late final _$refreshBoardGameDetailsAsyncAction = AsyncAction(
      '_CollectionSearchResultViewModel.refreshBoardGameDetails',
      context: context);

  @override
  Future<void> refreshBoardGameDetails() {
    return _$refreshBoardGameDetailsAsyncAction
        .run(() => super.refreshBoardGameDetails());
  }

  late final _$_CollectionSearchResultViewModelActionController =
      ActionController(
          name: '_CollectionSearchResultViewModel', context: context);

  @override
  void setBoardGameId(String boardGameId) {
    final _$actionInfo = _$_CollectionSearchResultViewModelActionController
        .startAction(name: '_CollectionSearchResultViewModel.setBoardGameId');
    try {
      return super.setBoardGameId(boardGameId);
    } finally {
      _$_CollectionSearchResultViewModelActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
boardGame: ${boardGame},
isExpansion: ${isExpansion},
isMainGame: ${isMainGame},
expansions: ${expansions}
    ''';
  }
}
