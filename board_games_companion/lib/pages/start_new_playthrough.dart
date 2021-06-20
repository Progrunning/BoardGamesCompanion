import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hive/board_game_details.dart';
import '../models/playthrough_player.dart';
import '../stores/start_playthrough_store.dart';
import '../widgets/common/cunsumer_future_builder_widget.dart';
import '../widgets/playthrough/playthrough_no_players.dart';
import '../widgets/playthrough/playthrough_players.dart';

class StartNewPlaythroughPage extends StatefulWidget {
  final BoardGameDetails boardGameDetails;
  final PageController pageController;

  const StartNewPlaythroughPage(
    this.boardGameDetails,
    this.pageController, {
    Key key,
  }) : super(key: key);

  @override
  _StartNewPlaythroughPageState createState() =>
      _StartNewPlaythroughPageState();
}

class _StartNewPlaythroughPageState
    extends State<StartNewPlaythroughPage> {
  StartPlaythroughStore startPlaythroughStore;

  @override
  void initState() {
    super.initState();

    startPlaythroughStore = Provider.of<StartPlaythroughStore>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConsumerFutureBuilder<List<PlaythroughPlayer>,
        StartPlaythroughStore>(
      future: startPlaythroughStore.loadPlaythroughPlayers(),
      success: (_, StartPlaythroughStore store) {
        if (store.playthroughPlayers?.isNotEmpty ?? false) {
          return PlaythroughPlayers(
              playthroughPlayers: store.playthroughPlayers,
              boardGameDetails: widget.boardGameDetails,
              pageController: widget.pageController);
        }

        return PlaythroughNoPlayers();
      },
    );
  }
}
