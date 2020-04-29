import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game_statistics.dart';
import 'package:board_games_companion/widgets/common/text/item_property_title_widget.dart';
import 'package:board_games_companion/widgets/common/text/item_property_value_widget.dart';
import 'package:board_games_companion/widgets/playthrough/calendar_card.dart';
import 'package:board_games_companion/extensions/date_time_extensions.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsLastPlayed extends StatelessWidget {
  const BoardGameCollectionItemDetailsLastPlayed({
    @required this.boardGameStatistics,
    Key key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ItemPropertyTitle('Last played'),
        SizedBox(
          height: Dimensions.halfStandardSpacing,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CalendarCard(
              boardGameStatistics?.lastPlayed,
            ),
            SizedBox(
              width: Dimensions.standardSpacing,
            ),
            Expanded(
              child: ItemPropertyValue(
                boardGameStatistics?.lastPlayed?.toDaysAgo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
