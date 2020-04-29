import 'package:board_games_companion/models/board_game_statistics.dart';
import 'package:board_games_companion/extensions/int_extensions.dart';
import 'package:board_games_companion/widgets/board_games/collection_item/board_game_collection_item_details_statistics_item_widget.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsStatistics extends StatelessWidget {
  const BoardGameCollectionItemDetailsStatistics({
    @required this.boardGameStatistics,
    Key key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BoardGameCollectionItemDetailsStatisticsItem(
          value: boardGameStatistics?.numberOfGamesPlayed?.toString() ?? '-',
          icon: Icons.insert_chart,
          iconColor: Theme.of(context).accentColor,
          subtitle: 'Played games',
        ),
        BoardGameCollectionItemDetailsStatisticsItem(
          value: boardGameStatistics?.highscore?.toString() ?? '-',
          icon: Icons.show_chart,
          iconColor: Colors.red,
          subtitle: 'Highscore',
        ),
        BoardGameCollectionItemDetailsStatisticsItem(
          value:
              '${boardGameStatistics?.averagePlaytimeInSeconds?.toAverageDuration('-')}',
          icon: Icons.hourglass_empty,
          iconColor: Colors.blue,
          subtitle: 'Ave. playtime',
        ),
      ],
    );
  }
}
