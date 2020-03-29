import 'dart:async';

import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/board_game_playthroughs.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_details_icon_button_widget.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_details_panel_widget.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_image_widget.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_rating_widget.dart';
import 'package:board_games_companion/widgets/common/ripple_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGameCollectionItemWidget extends StatelessWidget {
  BoardGameCollectionItemWidget({Key key}) : super(key: key);

  static const double _infoIconSize = 32;

  @override
  Widget build(BuildContext context) {
    final boardGamesStore = Provider.of<BoardGamesStore>(context);
    final boardGameDetails = Provider.of<BoardGameDetails>(context);

    return Dismissible(
      key: Key(boardGameDetails.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: Dimensions.doubleStandardSpacing),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: Dimensions.boardGameRemoveIconSize,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => _handleRemoveBoardGameFromCollection(
          context, boardGamesStore, boardGameDetails),
      child: Card(
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: Dimensions.boardGameItemCollectionImageHeight,
                  width: Dimensions.boardGameItemCollectionImageWidth,
                  child: Stack(
                    children: <Widget>[
                      BoardGameCollectionItemImage(
                        boardGameDetails: boardGameDetails,
                      ),
                      BoardGameCollectionItemRating(
                        boardGameDetails: boardGameDetails,
                      ),
                    ],
                  ),
                ),
                BoardGameCollectionItemDetailsPanel(
                  boardGameDetails: boardGameDetails,
                  infoIconSize: _infoIconSize,
                ),
              ],
            ),
            Positioned.fill(
              child: StackRippleEffect(
                onTap: () =>
                    _navigateToGamePlaythroughsPage(context, boardGameDetails),
              ),
            ),
            BoardGameCollectionItemDetailsIconButton(
              boardGameDetails: boardGameDetails,
              infoIconSize: _infoIconSize,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _navigateToGamePlaythroughsPage(
  BuildContext context,
  BoardGameDetails boardGameDetails,
) async {
  await Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return BoardGamePlaythroughsPage(boardGameDetails);
      },
    ),
  );
}

Future<void> _handleRemoveBoardGameFromCollection(
  BuildContext context,
  BoardGamesStore boardGamesStore,
  BoardGameDetails boardGameDetails,
) async {
  await boardGamesStore.removeBoardGame(boardGameDetails.id);

  Scaffold.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 10),
      content: Text(
          '${boardGameDetails.name} has been removed from your collection'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          await boardGamesStore.addOrUpdateBoardGame(boardGameDetails);
        },
      ),
    ),
  );
}
