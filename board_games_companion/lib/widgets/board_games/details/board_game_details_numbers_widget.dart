import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/board_games/board_game_rating_hexagon_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_numbers_item_widget.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsNumbers extends StatelessWidget {
  const BoardGameDetailsNumbers({
    Key key,
    @required BoardGameDetails boardGameDetails,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BoardGameRatingHexagon(
            boardGameDetails: _boardGameDetails,
          ),
          SizedBox(
            width: Dimensions.standardSpacing,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BoardGameDetailsNumbersItem(
                  title: 'Rank',
                  detail: _boardGameDetails?.rankFormatted,
                ),
                BoardGameDetailsNumbersItem(
                  title: 'Ratings',
                  detail: '${_boardGameDetails?.votes}',
                  format: true,
                ),
                BoardGameDetailsNumbersItem(
                  title: 'Comments',
                  detail: '${_boardGameDetails?.commentsNumber}',
                  format: true,
                ),
                BoardGameDetailsNumbersItem(
                  title: 'Published',
                  detail: '${_boardGameDetails?.yearPublished}',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
