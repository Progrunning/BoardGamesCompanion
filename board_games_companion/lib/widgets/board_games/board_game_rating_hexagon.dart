import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../common/rating_hexagon.dart';

class BoardGameRatingHexagon extends StatelessWidget {
  const BoardGameRatingHexagon(
      {super.key,
      required double? rating,
      double width = Dimensions.boardGameDetailsHexagonSize,
      double height = Dimensions.boardGameDetailsHexagonSize,
      double fontSize = Dimensions.boardGameDetailsHexagonFontSize,
      Color fontColor = AppColors.defaultTextColor,
      Color hexColor = AppColors.accentColor,
      int hexColorOpacity = AppStyles.opacity90Percent})
      : _rating = rating,
        _width = width,
        _height = height,
        _fontSize = fontSize,
        _fontColor = fontColor,
        _hexColor = hexColor,
        _hexColorOpacity = hexColorOpacity;

  final double? _rating;
  final double _width;
  final double _height;
  final double _fontSize;
  final Color _fontColor;
  final Color _hexColor;
  final int _hexColorOpacity;

  @override
  Widget build(BuildContext context) {
    return RatingHexagon(
      width: _width,
      height: _height,
      hexColor: _hexColor,
      hexColorOpacity: _hexColorOpacity,
      child: Text(
        _rating == null
            ? '?'
            : _rating!.toStringAsFixed(Constants.boardGameRatingNumberOfDecimalPlaces),
        style: TextStyle(color: _fontColor, fontSize: _fontSize),
      ),
    );
  }
}
