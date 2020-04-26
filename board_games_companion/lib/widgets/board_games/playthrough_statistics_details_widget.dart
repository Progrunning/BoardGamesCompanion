import 'dart:async';

import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_details_last_played_widget.dart';
import 'package:board_games_companion/widgets/board_games/collection_item/board_game_collection_item_details_last_winner_widget.dart';
import 'package:board_games_companion/widgets/board_games/collection_item/board_game_collection_item_details_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaythroughStatisticsDetails extends StatelessWidget {
  PlaythroughStatisticsDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardGameDetails = Provider.of<BoardGameDetails>(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.standardSpacing,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  BoardGameCollectionItemDetailsLastWinner(
                    boardGameDetails: boardGameDetails,
                  ),
                  SizedBox(
                    height: Dimensions.standardSpacing,
                  ),
                  BoardGameCollectionItemDetailsLastPlayed(
                    boardGameDetails: boardGameDetails,
                  ),
                  SizedBox(
                    height: Dimensions.doubleStandardSpacing,
                  ),
                  BoardGameCollectionItemDetailsStatistics(
                    boardGameDetails: boardGameDetails,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// TODO Work out where this should be called from
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
