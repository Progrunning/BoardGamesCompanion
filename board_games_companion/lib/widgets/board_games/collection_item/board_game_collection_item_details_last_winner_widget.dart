import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game_statistics.dart';
import 'package:board_games_companion/widgets/common/text/item_property_title_widget.dart';
import 'package:board_games_companion/widgets/player/scores/player_score_widget.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsLastWinner extends StatelessWidget {
  const BoardGameCollectionItemDetailsLastWinner({
    @required this.boardGameStatistics,
    Key key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

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
          boardGameStatistics?.lastWinner,
        ),
      ],
    );
  }
}
