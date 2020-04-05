import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Offset shadowOffset;
  final Color shadowColor;

  ShadowBox({
    @required this.child,
    this.backgroundColor = AppTheme.defaultTextColor,
    this.shadowColor = Styles.defaultShadowColor,
    this.shadowOffset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                offset: shadowOffset,
                blurRadius: Styles.defaultShadowRadius),
          ],
        ),
        child: child);
  }
}
