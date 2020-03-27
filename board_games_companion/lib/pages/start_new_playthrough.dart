import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_no_players.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_players.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartNewPlaythroughPage extends StatelessWidget {
  StartNewPlaythroughPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playersStore = Provider.of<PlayersStore>(
      context,
      listen: false,
    );
    playersStore.loadPlayers();

    return Consumer<PlayersStore>(
      builder: (_, playersStore, __) {
        if (playersStore.loadDataState == LoadDataState.Loaded) {
          if (playersStore.players?.length != 0) {
            final playthroughPlayers = playersStore.players.map((p) {
              return PlaythroughPlayer(p);
            }).toList();
            return Padding(
              padding: const EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              child: PlaythroughPlayers(
                playthroughPlayers: playthroughPlayers,
              ),
            );
          }

          return PlaythroughNoPlayers();
        } else if (playersStore.loadDataState == LoadDataState.Error) {
          return Center(child: Text('Oops, something went wrong'));
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
