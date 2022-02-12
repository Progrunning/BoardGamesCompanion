import 'package:flutter/material.dart';

class Styles {
  static const double _maxOpacityDecimal = 255;
  static const double _hundredPercent = 100;

  static const double defaultShadowRadius = defaultCornerRadius;
  static const double defaultCornerRadius = 5;
  static const Offset defaultShadowOffset =
      Offset(defaultCornerRadius / 2, defaultCornerRadius / 2);
  static const double defaultBottomSheetCornerRadius = defaultCornerRadius * 6;

  static const double boardGameTileImageCircularRadius = 15;
  static const double boardGameTileImageShadowBlur = 1.5;

  static const Color defaultShadowColor = Colors.blueGrey;

  static const int opacity10Percent = 10 * _maxOpacityDecimal ~/ _hundredPercent;
  static const int opacity20Percent = 20 * _maxOpacityDecimal ~/ _hundredPercent;
  static const int opacity30Percent = 30 * _maxOpacityDecimal ~/ _hundredPercent;
  static const int opacity40Percent = 40 * _maxOpacityDecimal ~/ _hundredPercent;
  static const int opacity50Percent = 50 * _maxOpacityDecimal ~/ _hundredPercent;
  static const int opacity60Percent = 60 * _maxOpacityDecimal ~/ _hundredPercent;
  static const int opacity70Percent = 70 * _maxOpacityDecimal ~/ _hundredPercent;
  static const int opacity80Percent = 80 * _maxOpacityDecimal ~/ _hundredPercent;
  static const int opacity90Percent = 90 * _maxOpacityDecimal ~/ _hundredPercent;

  static const double transparentOpacity = 0.0;
  static const double opaqueOpacity = 1.0;

  static const TextStyle playerScoreTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );
}
