import 'package:board_games_companion/common/enums.dart';
import 'package:flutter/material.dart';

class Medal extends StatelessWidget {
  final MedalEnum medal;

  const Medal(this.medal, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _medalColor;
    switch (medal) {
      case MedalEnum.Gold:
        _medalColor = Colors.yellow;
        break;
      case MedalEnum.Silver:
        _medalColor = Colors.grey;
        break;
      case MedalEnum.Bronze:
        _medalColor = Colors.brown;
        break;
      default:
    }

    return Icon(
      Icons.star,
      size: 28,
      color: _medalColor,
    );
  }
}
