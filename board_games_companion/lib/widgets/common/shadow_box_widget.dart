import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  final Widget child;

  ShadowBox({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            AppTheme.defaultBoxShadow,
          ],
        ),
        child: child);
  }
}
