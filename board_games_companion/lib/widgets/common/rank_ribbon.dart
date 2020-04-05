import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankRibbon extends StatelessWidget {
  final num _rank;

  const RankRibbon(
    num rank, {
    Key key,
  })  : _rank = rank,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          Icons.bookmark,
          size: 42,
          color:
              Theme.of(context).accentColor.withAlpha(Styles.opacity70Percent),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '#${_rank.toString()}',
              style: TextStyle(
                color: AppTheme.defaultTextColor,
                fontSize: Dimensions.smallFontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
