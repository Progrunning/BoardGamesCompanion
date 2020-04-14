import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/widgets/common/stack_ripple_effect.dart';
import 'package:board_games_companion/widgets/player/player_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaythroughPlayers extends StatelessWidget {
  const PlaythroughPlayers({
    Key key,
    @required this.playthroughPlayers,
  }) : super(key: key);

  final int _numberOfPlayerColumns = 3;
  final List<PlaythroughPlayer> playthroughPlayers;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _numberOfPlayerColumns,
      children: List.generate(
        playthroughPlayers.length,
        (int index) {
          return Stack(
            children: <Widget>[
              PlayerGridItem(playthroughPlayers[index].player),
              Align(
                alignment: Alignment.topRight,
                child: ChangeNotifierProvider.value(
                  value: playthroughPlayers[index],
                  child: Consumer<PlaythroughPlayer>(
                    builder: (_, store, __) {
                      return Checkbox(
                        value: playthroughPlayers[index].isChecked,
                        onChanged: (checked) {},
                      );
                    },
                  ),
                ),
              ),
              Positioned.fill(
                child: StackRippleEffect(
                  onTap: () {
                    playthroughPlayers[index].isChecked =
                        !playthroughPlayers[index].isChecked;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
