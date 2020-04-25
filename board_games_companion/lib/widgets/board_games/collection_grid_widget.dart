import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_widget.dart';
import 'package:flutter/material.dart';

class CollectionGrid extends StatelessWidget {
  const CollectionGrid({
    Key key,
    @required BoardGamesStore boardGamesStore,
  })  : _boardGamesStore = boardGamesStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      sliver: SliverGrid.extent(
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
        children: List.generate(
          _boardGamesStore.boardGames.length,
          (int index) {
            return BoardGameCollectionItem(
              boardGame: _boardGamesStore.boardGames[index],
            );
          },
        ),
      ),
    );
  }
}
