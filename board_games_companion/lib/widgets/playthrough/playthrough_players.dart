import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/stores/start_playthrough_store.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/common/stack_ripple_effect.dart';
import 'package:board_games_companion/widgets/player/player_grid_item.dart';
import 'package:board_games_companion/extensions/page_controller_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaythroughPlayers extends StatelessWidget {
  const PlaythroughPlayers({
    Key key,
    @required this.playthroughPlayers,
    @required this.boardGameDetails,
    @required this.pageController,
  }) : super(key: key);

  final int _numberOfPlayerColumns = 3;
  final List<PlaythroughPlayer> playthroughPlayers;
  final BoardGameDetails boardGameDetails;
  final PageController pageController;

  static const int _playthroughsPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GridView.count(
          padding: EdgeInsets.all(
            Dimensions.standardSpacing,
          ),
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
        ),
        if (playthroughPlayers.isNotEmpty)
          Positioned(
            bottom: Dimensions.standardSpacing,
            right: Dimensions.standardSpacing,
            child: IconAndTextButton(
              title: 'Start New Game',
              icon: Icons.play_arrow,
              onPressed: () => _onStartNewGame(context),
            ),
          ),
      ],
    );
  }

  Future<void> _onStartNewGame(
    BuildContext context,
  ) async {
    final startPlaythroughStore = Provider.of<StartPlaythroughStore>(
      context,
      listen: false,
    );

    final selectedPlaythoughPlayers = startPlaythroughStore.playthroughPlayers
        ?.where((pp) => pp.isChecked)
        ?.toList();

    final scaffold = Scaffold.of(context);
    if (selectedPlaythoughPlayers?.isEmpty ?? true) {
      scaffold.showSnackBar(
        SnackBar(
          content:
              Text('You need to select at least one player to start a game'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              scaffold.hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    final playthroughsStore = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );

    final newPlaythrough = await playthroughsStore.createPlaythrough(
        boardGameDetails.id, selectedPlaythoughPlayers);
    if (newPlaythrough == null) {
      scaffold.showSnackBar(
        SnackBar(
          content: GenericErrorMessage(),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              scaffold.hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    pageController.animateToTab(_playthroughsPageIndex);
  }
}
