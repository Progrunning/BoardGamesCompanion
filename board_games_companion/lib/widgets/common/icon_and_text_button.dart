import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class IconAndTextButton extends StatelessWidget {
  const IconAndTextButton({
    required this.icon,
    this.title,
    this.color,
    this.splashColor,
    this.horizontalPadding,
    this.verticalPadding,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  static const double rippleEffectOpacityFactor = 0.7;

  final GestureTapCallback? onPressed;

  final Widget icon;
  final String? title;
  final Color? color;
  final Color? splashColor;

  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    final fillColor = color ?? Theme.of(context).accentColor;

    return RawMaterialButton(
      constraints: const BoxConstraints(),
      fillColor: fillColor,
      splashColor: splashColor ??
          fillColor.withAlpha((fillColor.alpha * rippleEffectOpacityFactor).toInt()),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? Dimensions.doubleStandardSpacing,
          vertical: verticalPadding ?? Dimensions.standardSpacing,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            if (title?.isNotEmpty ?? false) ...[
              const SizedBox(
                width: Dimensions.halfStandardSpacing,
              ),
              Text(
                title!,
                style: const TextStyle(
                  color: AppTheme.defaultTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
