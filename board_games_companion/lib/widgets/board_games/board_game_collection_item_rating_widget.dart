import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../models/hive/board_game_details.dart';

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
                  // TODO Migration
                  .accentColor
                  .withAlpha(Styles.opacity90Percent),
              child: Center(
                child: Text(
                  (boardGameDetails.rating ?? 0).toStringAsFixed(
                      Constants.BoardGameRatingNumberOfDecimalPlaces),
                  style: const TextStyle(
                    color: AppTheme.defaultTextColor,
                    fontSize: Dimensions.standardFontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
