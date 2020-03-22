import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/widgets/player_avatar.dart';
import 'package:flutter/material.dart';

class StartNewPlaythrough extends StatefulWidget {
  StartNewPlaythrough({Key key}) : super(key: key);

  @override
  _StartNewPlaythroughState createState() => _StartNewPlaythroughState();
}

class _StartNewPlaythroughState extends State<StartNewPlaythrough> {
  final int _numberOfPlayerColumns = 2;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _numberOfPlayerColumns,
      children: List.generate(
        3,
        (int index) {
          return PlayerAvatar();
        },
      ),
    );
  }
}
