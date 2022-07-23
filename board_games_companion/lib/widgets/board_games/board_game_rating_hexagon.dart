import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

import '../../common/app_colors.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';

class BoardGameRatingHexagon extends StatelessWidget {
  const BoardGameRatingHexagon(
      {Key? key,
      required double? rating,
      double width = Dimensions.boardGameDetailsHexagonSize,
      double height = Dimensions.boardGameDetailsHexagonSize,
      double fontSize = Dimensions.boardGameDetailsHexagonFontSize,
      Color fontColor = AppColors.defaultTextColor,
      Color hexColor = AppColors.accentColor,
      int hexColorOpacity = Styles.opacity90Percent})
      : _rating = rating,
        _width = width,
        _height = height,
        _fontSize = fontSize,
        _fontColor = fontColor,
        _hexColor = hexColor,
        _hexColorOpacity = hexColorOpacity,
        super(key: key);

  final double? _rating;
  final double _width;
  final double _height;
  final double _fontSize;
  final Color _fontColor;
  final Color _hexColor;
  final int _hexColorOpacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: _width,
      child: ClipPolygon(
        sides: Dimensions.edgeNumberOfHexagon,
        child: Container(
          color: _hexColor.withAlpha(_hexColorOpacity),
          child: Center(
            child: Text(
              _rating == null
                  ? '?'
                  : _rating!.toStringAsFixed(Constants.boardGameRatingNumberOfDecimalPlaces),
              style: TextStyle(color: _fontColor, fontSize: _fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
