import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_widget.dart';
import 'package:board_games_companion/widgets/board_games/collection_empty_widget.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionsPage extends StatelessWidget {
  final BoardGamesStore _boardGamesStore;

  CollectionsPage(
    this._boardGamesStore, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final bgg = Provider.of<BoardGamesGeekService>(context, listen: false);
    // bgg.syncCollection('Ale_lipa');

    if (_boardGamesStore.loadDataState == LoadDataState.Loaded) {
      if (_boardGamesStore.boardGames?.isEmpty ?? true) {
        return CollectionEmpty();
      }

      _boardGamesStore.boardGames.sort((a, b) => a.name?.compareTo(b.name));

      return SafeArea(
        child: PageContainer(
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: Dimensions.standardSpacing,
              top: Dimensions.standardSpacing,
              right: Dimensions.standardSpacing,
              bottom: Dimensions.floatingActionButtonBottomSpacing,
            ),
            itemCount: _boardGamesStore.boardGames.length,
            itemBuilder: (BuildContext context, int index) {
              return ChangeNotifierProvider<BoardGameDetails>.value(
                value: _boardGamesStore.boardGames[index],
                child: Consumer<BoardGameDetails>(
                  builder: (_, store, __) {
                    return BoardGameCollectionItemWidget(
                      key: ValueKey(store.id),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    } else if (_boardGamesStore.loadDataState == LoadDataState.Error) {
      return Center(
        child: GenericErrorMessage(),
      );
    }

    return Center(child: CircularProgressIndicator());
  }
}
