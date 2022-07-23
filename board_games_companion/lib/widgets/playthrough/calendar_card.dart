import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../extensions/date_time_extensions.dart';
import '../common/ripple_effect.dart';
import '../painters/divider_painter.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard(
    this._date, {
    this.onTap,
    Key? key,
  }) : super(key: key);

  final DateTime? _date;
  final VoidCallback? onTap;
  double get _width => 64;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(Styles.boardGameTileImageCircularRadius),
        ),
        boxShadow: [
          AppTheme.defaultBoxShadow,
        ],
      ),
      child: RippleEffect(
        backgroundColor: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(Styles.boardGameTileImageCircularRadius),
        ),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Styles.boardGameTileImageCircularRadius),
                  topRight: Radius.circular(Styles.boardGameTileImageCircularRadius),
                ),
                boxShadow: [BoxShadow(blurRadius: Styles.boardGameTileImageShadowBlur)],
              ),
              child: Center(
                child: Text(
                  _date.toShortMonth('-'),
                  style: const TextStyle(
                    color: AppColors.defaultTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.halfStandardSpacing),
              child: Center(
                child: Text(
                  _date?.day.toString() ?? '-',
                  style: const TextStyle(
                      color: AppColors.invertedTextColor,
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
                color: AppColors.invertedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
