import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/material.dart';

class ColletionFilterRatingValueContainerWidget extends StatelessWidget {
  const ColletionFilterRatingValueContainerWidget({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Center child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(
          Styles.defaultCornerRadius,
        ),
        boxShadow: [AppTheme.defaultBoxShadow],
      ),
      child: child,
    );
  }
}
