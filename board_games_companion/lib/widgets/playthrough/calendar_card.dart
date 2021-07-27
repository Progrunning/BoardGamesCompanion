import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../extensions/date_time_extensions.dart';
import '../painters/divider_painter.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard(
    this._date, {
    Key key,
  }) : super(key: key);

  final DateTime _date;
  double get _width => 64;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      decoration: const BoxDecoration(
        color: AppTheme.defaultTextColor,
        borderRadius: BorderRadius.all(
          Radius.circular(Styles.boardGameTileImageCircularRadius),
        ),
        boxShadow: [
          AppTheme.defaultBoxShadow,
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Styles.boardGameTileImageCircularRadius),
                  topRight: Radius.circular(Styles.boardGameTileImageCircularRadius)),
              boxShadow: const [BoxShadow(blurRadius: Styles.boardGameTileImageShadowBlur)],
            ),
            child: Center(
              child: Text(
                _date.toShortMonth('-'),
                style: const TextStyle(
                  color: AppTheme.defaultTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.halfStandardSpacing),
            child: Center(
              child: Text(
                _date?.day?.toString() ?? '-',
                style: const TextStyle(
                    color: AppTheme.inverterTextColor,
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
              size: const Size.fromHeight(1),
              painter: DividerPainter(),
            ),
          ),
          Text(
            _date.toShortWeek('-'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.inverterTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
