import 'dart:async';

import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/board_game_playthroughs.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/utilities/navigator_transitions.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_details_icon_button_widget.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_details_panel_widget.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_image_widget.dart';
import 'package:board_games_companion/widgets/common/panel_container_widget.dart';
import 'package:board_games_companion/widgets/common/stack_ripple_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGameCollectionItemWidget extends StatelessWidget {
  BoardGameCollectionItemWidget({
    Key key,
  }) : super(key: key);

  static const double _infoIconSize = 32;

  @override
  Widget build(BuildContext context) {
    final boardGamesStore = Provider.of<BoardGamesStore>(context);
    final boardGameDetails = Provider.of<BoardGameDetails>(context);

    return Dismissible(
      key: Key(boardGameDetails.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: Dimensions.doubleStandardSpacing,
        ),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: Dimensions.boardGameRemoveIconSize,
          color: AppTheme.defaultTextColor,
        ),
      ),
      onDismissed: (direction) => _handleRemoveBoardGameFromCollection(
          context, boardGamesStore, boardGameDetails),
      child: Column(
        children: <Widget>[
          PanelContainer(
            child: Padding(
              padding: const EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
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
                            // BoardGameCollectionItemRating(
                            //   boardGameDetails: boardGameDetails,
                            // ),
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
                      onTap: () => _navigateToGamePlaythroughsPage(
                          context, boardGameDetails),
                    ),
                  ),
                  BoardGameCollectionItemDetailsIconButton(
                    boardGameDetails: boardGameDetails,
                    infoIconSize: _infoIconSize,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.doubleStandardSpacing,
          ),
        ],
      ),
    );
  }
}

Future<void> _navigateToGamePlaythroughsPage(
  BuildContext context,
  BoardGameDetails boardGameDetails,
) async {
  Navigator.push(
    context,
    NavigatorTransitions.fadeThrough((_, __, ___) {
      return BoardGamePlaythroughsPage(boardGameDetails);
    }),
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
