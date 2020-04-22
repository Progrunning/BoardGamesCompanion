import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_widget.dart';
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
    return SafeArea(
      child: PageContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            CollectionSearchBar(
              boardGamesStore: _boardGamesStore,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(
                  Dimensions.standardSpacing,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('sort by'),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              sliver: SliverGrid.extent(
                crossAxisSpacing: Dimensions.standardSpacing,
                mainAxisSpacing: Dimensions.standardSpacing,
                maxCrossAxisExtent:
                    Dimensions.boardGameItemCollectionImageWidth,
                children: List.generate(
                  _boardGamesStore.boardGames.length,
                  (int index) {
                    return BoardGameCollectionItem(
                      boardGame: _boardGamesStore.boardGames[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
