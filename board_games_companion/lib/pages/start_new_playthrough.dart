import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/start_playthrough_store.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_no_players.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_players.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartNewPlaythroughPage extends StatelessWidget {
  StartNewPlaythroughPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _startPlaythroughStore = Provider.of<StartPlaythroughStore>(
      context,
      listen: false,
    );
    _startPlaythroughStore.loadPlaythroughPlayers();

    return Consumer<StartPlaythroughStore>(
      builder: (_, store, __) {
        if (store.playthroughPlayers?.isNotEmpty ?? false) {
          return Padding(
            padding: const EdgeInsets.all(
              Dimensions.standardSpacing,
            ),
            child: PlaythroughPlayers(
              playthroughPlayers: store.playthroughPlayers,
            ),
          );
        }

        return PlaythroughNoPlayers();
      },
    );
  }
}
