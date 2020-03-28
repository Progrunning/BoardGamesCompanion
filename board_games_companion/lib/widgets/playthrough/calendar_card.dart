import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/widgets/painters/divider_painter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarCard extends StatelessWidget {
  final DateTime _date;

  const CalendarCard(
    this._date, {
    Key key,
  }) : super(key: key);

  final double _width = 64;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Styles.boardGameTileImageCircularRadius),
        ),
        boxShadow: [
          BoxShadow(blurRadius: 0.5),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(Styles.boardGameTileImageCircularRadius),
                  topRight:
                      Radius.circular(Styles.boardGameTileImageCircularRadius)),
              boxShadow: [
                BoxShadow(blurRadius: Styles.boardGameTileImageShadowBlur)
              ],
            ),
            child: Center(
              child: Text(
                DateFormat(Constants.ShortMonthDateFormat).format(_date),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.halfStandardSpacing),
            child: Center(
              child: Text(
                _date.day.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.doubleExtraLargeFontSize),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: Dimensions.standardSpacing,
              right: Dimensions.standardSpacing,
              bottom: Dimensions.halfStandardSpacing,
            ),
            child: CustomPaint(
              size: Size.fromHeight(1),
              painter: DividerPainter(),
            ),
          ),
          Text(
            DateFormat(Constants.ShortWeekDayDateFormat).format(_date),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
