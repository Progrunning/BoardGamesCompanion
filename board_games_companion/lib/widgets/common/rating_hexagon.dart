import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/dimensions.dart';

class RatingHexagon extends StatelessWidget {
  const RatingHexagon({
    Widget? child,
    double width = Dimensions.boardGameDetailsHexagonSize,
    double height = Dimensions.boardGameDetailsHexagonSize,
    Color hexColor = AppColors.accentColor,
    int hexColorOpacity = AppStyles.opacity90Percent,
    Key? key,
  })  : _child = child,
        _width = width,
        _height = height,
        _hexColor = hexColor,
        _hexColorOpacity = hexColorOpacity,
        super(key: key);

  final Widget? _child;
  final double _width;
  final double _height;
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
          child: _child,
        ),
      ),
    );
  }
}
