import 'package:flutter/material.dart';

import '../../common/enums/enums.dart';

class Medal extends StatelessWidget {
  const Medal(this.medal, {Key? key}) : super(key: key);

  final MedalEnum medal;

  @override
  Widget build(BuildContext context) {
    Color? _medalColor;
    switch (medal) {
      case MedalEnum.gold:
        _medalColor = Colors.yellow;
        break;
      case MedalEnum.silver:
        _medalColor = Colors.grey;
        break;
      case MedalEnum.bronze:
        _medalColor = Colors.brown;
        break;
      default:
    }

    return Icon(
      Icons.star,
      size: 32,
      color: _medalColor,
    );
  }
}
