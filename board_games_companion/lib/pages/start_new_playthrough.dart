import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/widgets/player_grid_item.dart';
import 'package:board_games_companion/widgets/ripple_effect.dart';
import 'package:flutter/material.dart';

class StartNewPlaythroughPage extends StatefulWidget {
  StartNewPlaythroughPage({Key key}) : super(key: key);

  @override
  _StartNewPlaythroughPageState createState() =>
      _StartNewPlaythroughPageState();
}

class _StartNewPlaythroughPageState extends State<StartNewPlaythroughPage> {
  final int _numberOfPlayerColumns = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      child: GridView.count(
        crossAxisCount: _numberOfPlayerColumns,
        children: List.generate(
          3,
          (int index) {
            return Stack(
              children: <Widget>[
                PlayerGridItem(Player()),
                Align(
                  alignment: Alignment.topRight,
                  child: Checkbox(
                    value: false,
                    onChanged: (checked) {},
                  ),
                ),
                Positioned.fill(
                    child: StackRippleEffect(
                  onTap: () {},
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}
