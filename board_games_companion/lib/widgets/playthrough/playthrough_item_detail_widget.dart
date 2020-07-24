import 'package:board_games_companion/widgets/common/text/item_property_title_widget.dart';
import 'package:board_games_companion/widgets/common/text/item_property_value_widget.dart';
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
        ItemPropertyValue(title),
        ItemPropertyTitle(subtitle),
      ],
    );
  }
}
