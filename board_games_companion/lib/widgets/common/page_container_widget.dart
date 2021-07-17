import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    @required this.child,
    Key key,
  }) : super(key: key);

  final Widget child;

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
      child: child,
    );
  }
}
