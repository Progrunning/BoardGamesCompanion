import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';

class RankRibbon extends StatelessWidget {
  const RankRibbon(
    num rank, {
    Key key,
  })  : _rank = rank,
        super(key: key);

  final num _rank;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          Icons.bookmark,
          size: 42,
          color: Theme.of(context).accentColor.withAlpha(Styles.opacity70Percent),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '#${_rank.toString()}',
              style: const TextStyle(
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
