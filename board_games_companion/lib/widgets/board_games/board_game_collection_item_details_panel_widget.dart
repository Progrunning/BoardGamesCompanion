import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsPanel extends StatelessWidget {
  const BoardGameCollectionItemDetailsPanel({
    Key key,
    @required this.boardGameDetails,
    @required double infoIconSize,
  })  : _infoIconSize = infoIconSize,
        super(key: key);

  final BoardGameDetails boardGameDetails;
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
                    '${boardGameDetails?.name ?? ''} (${boardGameDetails.yearPublished})',
                    style: TextStyle(fontSize: Dimensions.largeFontSize),
                  ),
                ),
                // MK Imitate info icon
                SizedBox(
                  width: _infoIconSize + 2 * Dimensions.halfStandardSpacing,
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.halfStandardSpacing,
            ),
          ],
        ),
      ),
    );
  }
}
