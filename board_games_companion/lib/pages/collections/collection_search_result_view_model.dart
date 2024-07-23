// ignore_for_file: library_private_types_in_public_api

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/hive/board_game_details.dart';
import '../../stores/board_games_store.dart';

part 'collection_search_result_view_model.g.dart';

@injectable
class CollectionSearchResultViewModel = _CollectionSearchResultViewModel
    with _$CollectionSearchResultViewModel;

abstract class _CollectionSearchResultViewModel with Store {
  _CollectionSearchResultViewModel(this._boardGamesStore);
  final BoardGamesStore _boardGamesStore;

  String? _boardGameId;

  @computed
  BoardGameDetails? get boardGame => _boardGamesStore.allBoardGamesInCollectionsMap[_boardGameId];

  @computed
  bool get isExpansion => boardGame?.isExpansion ?? false;

  @computed
  bool get isBaseGame => boardGame?.isBaseGame ?? false;

  @computed
  List<BoardGameDetails> get expansions {
    if (!isBaseGame) {
      return [];
    }

    final boardGameExpensions = <BoardGameDetails>[];
    for (final boardGameId in boardGame?.expansions.map((e) => e.id).toList() ?? <String>[]) {
      if (_boardGamesStore.allBoardGamesInCollectionsMap.containsKey(boardGameId)) {
        boardGameExpensions.add(_boardGamesStore.allBoardGamesMap[boardGameId]!);
      }
    }

    return boardGameExpensions;
  }

  @action
  Future<void> refreshBoardGameDetails() async =>
      _boardGamesStore.refreshBoardGameDetails(_boardGameId!);

  @action
  void setBoardGameId(String boardGameId) => _boardGameId = boardGameId;
}
