import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/widgets/player_grid_item.dart';
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context)
                          .accentColor
                          .withAlpha(Styles.opacity70Percent),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
