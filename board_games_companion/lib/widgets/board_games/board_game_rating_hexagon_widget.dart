import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class BoardGameRatingHexagon extends StatelessWidget {
  const BoardGameRatingHexagon({
    Key key,
    @required BoardGameDetails boardGameDetails,
    double width = Dimensions.boardGameDetailsHexagonSize,
    double height = Dimensions.boardGameDetailsHexagonSize,
  })  : _boardGameDetails = boardGameDetails,
        _width = width,
        _height = height,
        super(key: key);

  final BoardGameDetails _boardGameDetails;
  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: _width,
      child: ClipPolygon(
        sides: Dimensions.edgeNumberOfHexagon,
        child: Container(
          color:
              Theme.of(context).accentColor.withAlpha(Styles.opacity90Percent),
          child: Center(
            child: Text(
              (_boardGameDetails?.rating ?? 0).toStringAsFixed(
                  Constants.BoardGameRatingNumberOfDecimalPlaces),
              style: TextStyle(
                color: AppTheme.defaultTextColor,
                fontSize: Dimensions.doubleExtraLargeFontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
