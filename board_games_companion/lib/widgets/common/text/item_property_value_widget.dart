import 'package:flutter/material.dart';

import '../../../common/dimensions.dart';

class ItemPropertyValue extends StatelessWidget {
  const ItemPropertyValue(
    this.value, {
    Key? key,
  }) : super(key: key);

  final String? value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value ?? '',
      style: const TextStyle(
        fontSize: Dimensions.mediumFontSize,
      ),
    );
  }
}
