import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/board_games/collection_item/board_game_collection_item_details_statistics_item_widget.dart';
import 'package:board_games_companion/extensions/int_extensions.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsStatistics extends StatelessWidget {
  final BoardGameDetails boardGameDetails;

  const BoardGameCollectionItemDetailsStatistics({
    @required this.boardGameDetails,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BoardGameCollectionItemDetailsStatisticsItem(
          boardGameDetails: boardGameDetails,
          value: (boardGameDetails.numberOfGamesPlayed ?? 0).toString(),
          icon: Icons.insert_chart,
          iconColor: Theme.of(context).accentColor,
          subtitle: 'Played games',
        ),
        BoardGameCollectionItemDetailsStatisticsItem(
          boardGameDetails: boardGameDetails,
          value: (boardGameDetails.highscore ?? 0).toString(),
          icon: Icons.show_chart,
          iconColor: Colors.red,
          subtitle: 'Highscore',
        ),
        BoardGameCollectionItemDetailsStatisticsItem(
          boardGameDetails: boardGameDetails,
          value: '~${boardGameDetails.averagePlaytimeInSeconds.toAverageDuration('-')}',
          icon: Icons.hourglass_empty,
          iconColor: Colors.blue,
          subtitle: 'Ave. playtime',
        ),
      ],
    );
  }
}
