import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget _child;

  const PageContainer({
    @required child,
    Key key,
  })  : _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            AppTheme.startDefaultPageBackgroundColorGradient,
            AppTheme.endDefaultPageBackgroundColorGradient,
          ],
          tileMode: TileMode.clamp,
        ),
      ),
      child: _child,
    );
  }
}
