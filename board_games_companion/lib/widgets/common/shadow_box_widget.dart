import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;

  ShadowBox(this.content, [this.backgroundColor = Colors.white]);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
                color: Styles.defaultShadowColor,
                blurRadius: Styles.defaultShadowRadius),
          ],
        ),
        child: content);
  }
}
