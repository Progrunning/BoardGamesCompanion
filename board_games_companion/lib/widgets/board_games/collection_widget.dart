import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/collection_empty_search_result.dart';
import 'package:board_games_companion/widgets/board_games/collection_grid_widget.dart';
import 'package:board_games_companion/widgets/board_games/collection_search_bar_widget.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';

class Collection extends StatelessWidget {
  const Collection({
    Key key,
    @required BoardGamesStore boardGamesStore,
  })  : _boardGamesStore = boardGamesStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;

  @override
  Widget build(BuildContext context) {
    final hasNoSearchResults = _boardGamesStore.boardGames.isEmpty &&
        (_boardGamesStore.searchPhrase?.isNotEmpty ?? false);

    return SafeArea(
      child: PageContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            CollectionSearchBar(
              boardGamesStore: _boardGamesStore,
            ),
            if (hasNoSearchResults)
              CollectionEmptySearchResult(
                boardGamesStore: _boardGamesStore,
              ),
            if (!hasNoSearchResults)
              CollectionGrid(
                boardGamesStore: _boardGamesStore,
              ),
          ],
        ),
      ),
    );
  }
}
