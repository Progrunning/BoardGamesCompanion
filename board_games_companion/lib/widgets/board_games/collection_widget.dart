import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_widget.dart';
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
            SliverAppBar(
              titleSpacing: Dimensions.standardSpacing,
              title: TextField(
                // TODO IMPLEMET
                // controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: AppTheme.defaultTextFieldInputDecoration.copyWith(
                  hintText: 'Search...',
                  // suffixIcon: retrieveSearchBarSuffixIcon(
                  //   store,
                  //   searchBoardGamesStore,
                  // ),
                ),
                onChanged: (searchPhrase) {
                  // store.searchPhrase = searchPhrase;
                },
                onSubmitted: (searchPhrase) {
                  // searchBoardGamesStore.updateSearchResults();
                },
              ),
              actions: <Widget>[
                Icon(
                  Icons.filter_list,
                )
              ],
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
