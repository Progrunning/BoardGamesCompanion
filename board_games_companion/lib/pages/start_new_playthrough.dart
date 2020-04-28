import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/stores/start_playthrough_store.dart';
import 'package:board_games_companion/widgets/common/cunsumer_future_builder_widget.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_no_players.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_players.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartNewPlaythroughPage extends StatelessWidget {
  const StartNewPlaythroughPage({
    Key key,
    BoardGameDetails boardGameDetails,
    PageController pageController,
  })  : _boardGameDetails = boardGameDetails,
        _pageController = pageController,
        super(key: key);

  final BoardGameDetails _boardGameDetails;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    final _startPlaythroughStore = Provider.of<StartPlaythroughStore>(
      context,
      listen: false,
    );

    return ConsumerFutureBuilder<List<PlaythroughPlayer>,
        StartPlaythroughStore>(
      future: _startPlaythroughStore.loadPlaythroughPlayers(),
      success: (_, StartPlaythroughStore store) {
        if (store.playthroughPlayers?.isNotEmpty ?? false) {
          return PlaythroughPlayers(
            playthroughPlayers: store.playthroughPlayers,
            boardGameDetails: _boardGameDetails,
            pageController: _pageController
          );
        }

        return PlaythroughNoPlayers();
      },
    );
  }
}
