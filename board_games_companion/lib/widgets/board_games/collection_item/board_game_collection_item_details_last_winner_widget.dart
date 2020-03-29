import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/common/text/item_property_title_widget.dart';
import 'package:board_games_companion/widgets/player/player_score_widget.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsLastWinner extends StatelessWidget {
  const BoardGameCollectionItemDetailsLastWinner({
    @required this.boardGameDetails,
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ItemPropertyTitle('Last winner'),
        SizedBox(
          height: Dimensions.halfStandardSpacing,
        ),
        PlayerScore(
          boardGameDetails.lastWinner,
        ),
      ],
    );
  }
}
