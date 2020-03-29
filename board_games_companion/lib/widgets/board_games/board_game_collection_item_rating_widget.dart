import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class BoardGameCollectionItemRating extends StatelessWidget {
  const BoardGameCollectionItemRating({
    Key key,
    @required this.boardGameDetails,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          height: Dimensions.boardGameHexagonSize,
          width: Dimensions.boardGameHexagonSize,
          child: ClipPolygon(
            sides: Dimensions.edgeNumberOfHexagon,
            child: Container(
              color: Theme.of(context)
                  .accentColor
                  .withAlpha(Styles.opacity90Percent),
              child: Center(
                child: Text(
                  (boardGameDetails.rating ?? 0).toStringAsFixed(
                      Constants.BoardGameRatingNumberOfDecimalPlaces),
                  style: TextStyle(
                      color: Colors.white, fontSize: Dimensions.smallFontSize),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
