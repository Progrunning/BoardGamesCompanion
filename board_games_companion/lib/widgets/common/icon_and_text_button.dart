import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class IconAndTextButton extends StatelessWidget {
  const IconAndTextButton({
    this.icon,
    this.title,
    this.backgroundColor,
    this.rippleEffectColor,
    this.horizontalPadding,
    this.verticalPadding,
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  static const double rippleEffectOpacityFactor = 0.7;

  final GestureTapCallback onPressed;

  final Widget icon;
  final String title;
  final Color backgroundColor;
  final Color rippleEffectColor;

  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final fillColor = backgroundColor ?? Theme.of(context).accentColor;
    final splashColor = rippleEffectColor ??
        fillColor.withAlpha((fillColor.alpha * rippleEffectOpacityFactor).toInt());

    return RawMaterialButton(
      constraints: const BoxConstraints(),
      fillColor: fillColor,
      splashColor: splashColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? Dimensions.doubleStandardSpacing,
          vertical: verticalPadding ?? Dimensions.standardSpacing,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            if (title?.isNotEmpty ?? false)
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.defaultTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (title?.isNotEmpty ?? false)
              const Divider(
                indent: Dimensions.halfStandardSpacing,
              ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
