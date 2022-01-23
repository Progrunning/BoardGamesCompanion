import 'package:flutter/material.dart';

import '../../../common/dimensions.dart';

class ItemPropertyValue extends StatelessWidget {
  const ItemPropertyValue(
    this.value, {
    this.fontSize = Dimensions.mediumFontSize,
    Key? key,
  }) : super(key: key);

  final String? value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      value ?? '',
      style: TextStyle(fontSize: fontSize),
    );
  }
}
