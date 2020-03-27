import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/widgets/common/ripple_effect.dart';
import 'package:board_games_companion/widgets/player/player_grid_item.dart';
import 'package:flutter/material.dart';

class PlaythroughPlayers extends StatefulWidget {
  const PlaythroughPlayers({
    Key key,
    @required this.playthroughPlayers,
  }) : super(key: key);

  final int _numberOfPlayerColumns = 3;
  final List<PlaythroughPlayer> playthroughPlayers;

  @override
  _PlaythroughPlayersState createState() => _PlaythroughPlayersState();
}

class _PlaythroughPlayersState extends State<PlaythroughPlayers> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: widget._numberOfPlayerColumns,
      children: List.generate(
        widget.playthroughPlayers.length,
        (int index) {
          return Stack(
            children: <Widget>[
              PlayerGridItem(widget.playthroughPlayers[index].player),
              Align(
                alignment: Alignment.topRight,
                child: Checkbox(
                  value: widget.playthroughPlayers[index].isChecked,
                  onChanged: (checked) {},
                ),
              ),
              Positioned.fill(
                child: StackRippleEffect(
                  onTap: () {
                    final selectedPlaythroughPlayer =
                        widget.playthroughPlayers[index];
                    setState(() {
                      selectedPlaythroughPlayer.isChecked =
                          !selectedPlaythroughPlayer.isChecked;
                    });
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
