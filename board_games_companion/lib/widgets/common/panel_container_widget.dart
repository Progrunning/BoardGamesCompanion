import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/material.dart';

class PanelContainer extends StatelessWidget {
  final Widget _child;
  final double _borderRadius;

  const PanelContainer({
    @required child,
    borderRadius = Styles.defaultCornerRadius * 3,
    Key key,
  })  : _child = child,
        _borderRadius = borderRadius,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            AppTheme.startDefaultPageElementBackgroundColorGradient,
            AppTheme.endDefaultPageElementBackgroundColorGradient,
          ],
          tileMode: TileMode.clamp,
        ),
        border: Border.all(
          color: AppTheme.theme.accentColor,
          width: Dimensions.defaultBorderWidth,
        ),
        borderRadius: BorderRadius.circular(
          _borderRadius,
        ),
      ),
      child: _child,
    );
  }
}
