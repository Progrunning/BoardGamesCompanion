import 'package:board_games_companion/common/app_colors.dart';
import 'package:flutter/material.dart';

import '../common/styles.dart';

class ElevatedContainer extends StatelessWidget {
  const ElevatedContainer({
    required this.child,
    this.boarderRadius = const BorderRadius.all(
      Radius.circular(Styles.defaultCornerRadius),
    ),
    this.backgroundColor,
    this.splashColor = AppColors.accentColor,
    this.elevation = 0,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double elevation;
  final BorderRadius? boarderRadius;
  final Color? backgroundColor;
  final Color? splashColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: backgroundColor,
      borderRadius: boarderRadius,
      child: InkWell(
        borderRadius: boarderRadius,
        splashColor: splashColor,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
