import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaythroughItemDetail extends StatelessWidget {
  final String subtitle;
  final String title;

  PlaythroughItemDetail(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title ?? '',
          style: TextStyle(
            fontSize: Dimensions.largeFontSize,
          ),
        ),
        Text(
          subtitle ?? '',
          style: TextStyle(
            fontSize: Dimensions.extraSmallFontSize,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
