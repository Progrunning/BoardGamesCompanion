import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/stores/playthrough_statistics_store.dart';
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
    final playthroughStatisticsStore =
        Provider.of<PlaythroughStatisticsStore>(context);

    return Consumer<BoardGameDetails>(
      builder: (_, boardGameDetails, __) {
        final boardGameStatistics = playthroughStatisticsStore
            .boardGamesStatistics[boardGameDetails.id];
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
                        boardGameStatistics: boardGameStatistics,
                      ),
                      SizedBox(
                        height: Dimensions.standardSpacing,
                      ),
                      BoardGameCollectionItemDetailsLastPlayed(
                        boardGameStatistics: boardGameStatistics,
                      ),
                      SizedBox(
                        height: Dimensions.doubleStandardSpacing,
                      ),
                      BoardGameCollectionItemDetailsStatistics(
                        boardGameStatistics: boardGameStatistics,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}