import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/utilities/widget_utilities.dart';
import 'package:flutter/material.dart';

class IconAndTextButton extends StatelessWidget {
  static const double rippleEffectOpacityFactor = 0.7;

  final GestureTapCallback onPressed;

  final IconData icon;
  final String title;
  final Color backgroundColor;
  final Color rippleEffectColor;

  final double horizontalPadding;
  final double verticalPadding;

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

  Widget _buildDivider() => title?.isNotEmpty ?? false
      ? Divider(
          indent: Dimensions.halfStandardSpacing,
        )
      : null;

  Widget _buildText() => title?.isNotEmpty ?? false
      ? Text(
          title,
          style: TextStyle(color: Colors.white),
        )
      : null;

  @override
  Widget build(BuildContext context) {
    var fillColor = backgroundColor ?? Theme.of(context).accentColor;
    var splashColor = rippleEffectColor ??
        fillColor
            .withAlpha((fillColor.alpha * rippleEffectOpacityFactor).toInt());

    final List<Widget> buttonElements = [
      Icon(
        icon,
        color: Colors.white,
        size: Dimensions.defaultButtonIconSize,
      ),
    ];

    addIfNonNull(_buildDivider(), buttonElements);
    addIfNonNull(_buildText(), buttonElements);

    return RawMaterialButton(
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
