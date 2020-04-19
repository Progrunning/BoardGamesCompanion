import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_widget.dart';
import 'package:board_games_companion/widgets/board_games/collection_empty_widget.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  final BoardGamesStore _boardGamesStore;

  CollectionsPage(
    this._boardGamesStore, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_boardGamesStore.loadDataState == LoadDataState.Loaded) {
      if (_boardGamesStore.boardGames?.isEmpty ?? true) {
        return CollectionEmpty(
          boardGamesStore: _boardGamesStore,
        );
      }

      _boardGamesStore.boardGames.sort((a, b) => a.name?.compareTo(b.name));

      return SafeArea(
        child: PageContainer(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.all(
                  Dimensions.standardSpacing,
                ),
                sliver: SliverGrid.extent(
                  crossAxisSpacing: Dimensions.standardSpacing,
                  mainAxisSpacing: Dimensions.standardSpacing,
                  maxCrossAxisExtent: 150,
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
          // child: ListView.builder(
          //   padding: EdgeInsets.only(
          //     left: Dimensions.standardSpacing,
          //     top: Dimensions.standardSpacing,
          //     right: Dimensions.standardSpacing,
          //     bottom: Dimensions.floatingActionButtonBottomSpacing,
          //   ),
          //   itemCount: _boardGamesStore.boardGames.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return ChangeNotifierProvider<BoardGameDetails>.value(
          //       value: _boardGamesStore.boardGames[index],
          //       child: Consumer<BoardGameDetails>(
          //         builder: (_, store, __) {
          //           return BoardGameCollectionItemWidget(
          //             key: ValueKey(store.id),
          //           );
          //         },
          //       ),
          //     );
          //   },
          // ),
        ),
      );
    } else if (_boardGamesStore.loadDataState == LoadDataState.Error) {
      return Center(
        child: GenericErrorMessage(),
      );
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
