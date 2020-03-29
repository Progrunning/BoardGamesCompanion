import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_details_last_played_widget.dart';
import 'package:board_games_companion/widgets/board_games/collection_item/board_game_collection_item_details_last_winner_widget.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsPanel extends StatelessWidget {
  const BoardGameCollectionItemDetailsPanel({
    Key key,
    @required boardGameDetails,
    @required double infoIconSize,
  })  : _infoIconSize = infoIconSize,
        _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;
  final double _infoIconSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.halfStandardSpacing,
          horizontal: Dimensions.standardSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${_boardGameDetails?.name ?? ''} (${_boardGameDetails.yearPublished})',
                    style: TextStyle(
                      fontSize: Dimensions.largeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // MK Imitate info icon, so that title wraps correctly around the icon
                SizedBox(
                  width: _infoIconSize + 2 * Dimensions.halfStandardSpacing,
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.standardSpacing,
            ),
            BoardGameCollectionItemDetailsLastPlayed(
              boardGameDetails: _boardGameDetails,
            ),
            SizedBox(
              height: Dimensions.standardSpacing,
            ),
            BoardGameCollectionItemDetailsLastWinner(
              boardGameDetails: _boardGameDetails,
            ),
          ],
        ),
      ),
    );
  }
}
