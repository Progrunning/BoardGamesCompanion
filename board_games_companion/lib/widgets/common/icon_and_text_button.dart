import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../utilities/widget_utilities.dart';

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

  final IconData icon;
  final String title;
  final Color backgroundColor;
  final Color rippleEffectColor;

  final double horizontalPadding;
  final double verticalPadding;

  Widget _buildDivider() => title?.isNotEmpty ?? false
      ? const Divider(
          indent: Dimensions.halfStandardSpacing,
        )
      : null;

  Widget _buildText() => title?.isNotEmpty ?? false
      ? Text(
          title,
          style: const TextStyle(
            color: AppTheme.defaultTextColor,
            fontWeight: FontWeight.bold,
          ),
        )
      : null;

  @override
  Widget build(BuildContext context) {
    final fillColor = backgroundColor ?? Theme.of(context).accentColor;
    final splashColor = rippleEffectColor ??
        fillColor.withAlpha((fillColor.alpha * rippleEffectOpacityFactor).toInt());

    final List<Widget> buttonElements = [
      Icon(
        icon,
        color: AppTheme.defaultTextColor,
        size: Dimensions.defaultButtonIconSize,
      ),
    ];

    addIfNonNull(_buildDivider(), buttonElements);
    addIfNonNull(_buildText(), buttonElements);

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
          children: buttonElements,
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
