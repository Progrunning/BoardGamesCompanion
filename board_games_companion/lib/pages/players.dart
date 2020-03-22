import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/widgets/player_grid_item.dart';
import 'package:board_games_companion/widgets/ripple_effect.dart';
import 'package:flutter/material.dart';

class PlayersPage extends StatefulWidget {
  PlayersPage({Key key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final int _numberOfPlayerColumns = 2;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _numberOfPlayerColumns,
      children: List.generate(
        3,
        (int index) {
          return Stack(
            children: <Widget>[
              PlayerGridItem(Player()),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(
                    Dimensions.halfStandardSpacing,
                  ),
                  child: Icon(
                    Icons.edit,
                  ),
                ),
              ),
              Positioned.fill(child: StackRippleEffect(
                onTap: () async {
                  await Navigator.pushNamed(context, Routes.createEditPlayer);
                },
              )),
            ],
          );
        },
      ),
    );
  }
}
