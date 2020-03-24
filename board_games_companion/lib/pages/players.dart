import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/widgets/player_grid_item.dart';
import 'package:flutter/material.dart';

class PlayersPage extends StatefulWidget {
  PlayersPage({Key key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final PlayerService _playerService = PlayerService();
  final int _numberOfPlayerColumns = 3;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _playerService.retrievePlayers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var players = (snapshot.data as List<Player>);
          if (players?.isEmpty ?? true) {
            return Padding(
              padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Center(
                child: Text('It looks empty here, try adding a new player'),
              ),
            );
          }

          players.sort((a, b) => a.name?.compareTo(b.name));

          return SafeArea(
            child: GridView.count(
              crossAxisCount: _numberOfPlayerColumns,
              children: List.generate(
                players.length,
                (int index) {
                  return PlayerGridItem(players[index]);
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                ' Oops, we ran into issue with retrieving your data. Please contact support at feedback@progrunning.net'),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    _playerService.closeBox(HiveBoxes.Players);
    super.dispose();
  }
}
