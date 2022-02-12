import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

import '../common/styles.dart';
import 'common/ripple_effect.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    Key? key,
    required this.child,
    this.addShadow = false,
    this.onTap,
    this.backgroundColor = AppTheme.accentColor,
    this.splashColor,
    this.width,
    this.height,
  }) : super(key: key);

  final Widget child;
  final bool addShadow;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color? splashColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
        boxShadow: addShadow ? const <BoxShadow>[AppTheme.defaultBoxShadow] : [],
      ),
      child: onTap == null
          ? child
          : RippleEffect(
              onTap: onTap,
              child: child,
              splashColor: splashColor ?? AppTheme.alternativeSplashColor,
              borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
            ),
    );
  }
}
