import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

const double _kOffset = 22.0; // distance to bottom of banner, at a 45 degree angle inwards
const double _kHeight = 10.0; // height of banner
const double _kBottomOffset = _kOffset + 0.707 * _kHeight; // offset plus sqrt(2)/2 * banner height
const Rect _kRect = Rect.fromLTWH(-_kOffset, _kOffset - _kHeight, _kOffset * 2.0, _kHeight);

/// Paints a [Banner].
class ExpanionsBannerPainter extends CustomPainter {
  /// Creates a banner painter.
  ///
  /// The [message] and [location]
  /// arguments must not be null.
  ExpanionsBannerPainter({
    @required this.message,
    @required this.location,
    this.color = AppTheme.accentColor,
  })  : assert(message != null),
        assert(location != null),
        assert(color != null),
        super(repaint: PaintingBinding.instance.systemFonts);

  /// The message to show in the banner.
  final String message;

  /// Where to show the banner (e.g., the upper right corner).
  final BannerLocation location;

  /// The color to paint behind the [message].
  ///
  /// Defaults to a dark red.
  final Color color;

  static const BoxShadow _shadow = AppTheme.defaultBoxShadow;

  bool _prepared = false;
  TextPainter _textPainter;
  Paint _paintShadow;
  Paint _paintBanner;

  void _prepare() {
    _paintShadow = _shadow.toPaint();
    _paintBanner = Paint()..color = color;
    _textPainter = TextPainter(
      text: TextSpan(
          style: AppTheme.subTitleTextStyle.copyWith(
            color: AppTheme.defaultTextColor,
            fontSize: Dimensions.extraSmallFontSize,
          ),
          text: message),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    _prepared = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!_prepared) {
      _prepare();
    }

    canvas
      ..translate(_translationX(size.width), _translationY(size.height))
      ..rotate(_rotation)
      ..drawRect(_kRect, _paintShadow)
      ..drawRect(_kRect, _paintBanner);
    const double width = _kOffset * 2.0;
    _textPainter.layout(minWidth: width, maxWidth: width);
    _textPainter.paint(
        canvas, _kRect.topLeft + Offset(0.0, (_kRect.height - _textPainter.height) / 2.0));
  }

  @override
  bool shouldRepaint(ExpanionsBannerPainter oldDelegate) {
    return message != oldDelegate.message ||
        location != oldDelegate.location ||
        color != oldDelegate.color;
  }

  @override
  bool hitTest(Offset position) => false;

  double _translationX(double width) {
    assert(location != null);
    switch (location) {
      case BannerLocation.bottomEnd:
        return width - _kBottomOffset;
      case BannerLocation.topEnd:
        return width;
      case BannerLocation.bottomStart:
        return _kBottomOffset;
      case BannerLocation.topStart:
        return 0.0;
    }
    return null;
  }

  double _translationY(double height) {
    assert(location != null);
    switch (location) {
      case BannerLocation.bottomStart:
      case BannerLocation.bottomEnd:
        return height - _kBottomOffset;
      case BannerLocation.topStart:
      case BannerLocation.topEnd:
        return 0.0;
    }
    return null;
  }

  double get _rotation {
    assert(location != null);
    switch (location) {
      case BannerLocation.bottomStart:
      case BannerLocation.topEnd:
        return math.pi / 4.0;
      case BannerLocation.bottomEnd:
      case BannerLocation.topStart:
        return -math.pi / 4.0;
    }
    return null;
  }
}
