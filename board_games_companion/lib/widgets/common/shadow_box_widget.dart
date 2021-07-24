import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  const ShadowBox({
    @required this.child,
  });
  
  final Widget child;

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
