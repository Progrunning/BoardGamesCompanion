import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

class ItemPropertyValue extends StatelessWidget {
  final String value;

  const ItemPropertyValue(
    this.value, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value ?? '',
      style: TextStyle(
        fontSize: Dimensions.mediumFontSize,
      ),
    );
  }
}
