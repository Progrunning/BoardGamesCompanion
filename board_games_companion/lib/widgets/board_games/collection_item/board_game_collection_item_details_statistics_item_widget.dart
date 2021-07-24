import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/widgets/common/text/item_property_title_widget.dart';
import 'package:board_games_companion/widgets/common/text/item_property_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BoardGameCollectionItemDetailsStatisticsItem extends StatelessWidget {
  const BoardGameCollectionItemDetailsStatisticsItem({
    Key key,
    @required this.icon,
    @required this.value,
    @required this.subtitle,
    this.iconColor,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: iconColor ?? IconTheme.of(context).color,
            ),
            const SizedBox(
              width: Dimensions.halfStandardSpacing,
            ),
            ItemPropertyValue(value ?? ''),
          ],
        ),
        ItemPropertyTitle(subtitle ?? '')
      ],
    );
  }
}
