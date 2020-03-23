import 'package:async/async.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/widgets/playthrough_players.dart';
import 'package:flutter/material.dart';

class StartNewPlaythroughPage extends StatefulWidget {
  StartNewPlaythroughPage({Key key}) : super(key: key);

  @override
  _StartNewPlaythroughPageState createState() =>
      _StartNewPlaythroughPageState();
}

class _StartNewPlaythroughPageState extends State<StartNewPlaythroughPage> {
  final PlayerService _playerService = PlayerService();
  final int _numberOfPlayerColumns = 2;

  AsyncMemoizer _memoizer;

  @override
  void initState() {
    super.initState();

    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _memoizer.runOnce(() async {
        return _playerService.retrievePlayers();
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final players = snapshot.data as List<Player>;
          if (players != null) {
            final playthroughPlayers = players.map((p) {
              return PlaythroughPlayer(p);
            }).toList();
            return Padding(
              padding: const EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              child: PlaythroughPlayers(
                  numberOfPlayerColumns: _numberOfPlayerColumns,
                  playthroughPlayers: playthroughPlayers),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(Dimensions.standardSpacing),
                  child: Center(
                    child:
                        Text('It looks empty here, try adding a new players'),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Oops, something went wrong'));
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
