import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/common/text/item_property_title_widget.dart';
import 'package:board_games_companion/widgets/common/text/item_property_value_widget.dart';
import 'package:board_games_companion/widgets/playthrough/calendar_card.dart';
import 'package:board_games_companion/extensions/date_time_extensions.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsLastPlayed extends StatelessWidget {
  const BoardGameCollectionItemDetailsLastPlayed({
    @required this.boardGameDetails,
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemPropertyTitle('Last played'),
        SizedBox(
          height: Dimensions.halfStandardSpacing,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CalendarCard(
              boardGameDetails.lastPlayed,
            ),
            SizedBox(
              width: Dimensions.halfStandardSpacing,
            ),
            Expanded(
              child: ItemPropertyValue(
                boardGameDetails.lastPlayed.toDaysAgo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
