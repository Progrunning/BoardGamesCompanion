import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/text/item_property_title_widget.dart';
import '../common/text/item_property_value_widget.dart';

class PlaythroughItemDetail extends StatelessWidget {
  const PlaythroughItemDetail(
    this.title,
    this.subtitle, {
    Key key,
  }) : super(key: key);

  final String subtitle;
  final String title;

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
