import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/dimensions.dart';
import '../../extensions/page_controller_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/playthrough_player.dart';
import '../../stores/playthroughs_store.dart';
import '../../stores/start_playthrough_store.dart';
import '../common/default_icon.dart';
import '../common/generic_error_message_widget.dart';
import '../common/icon_and_text_button.dart';
import '../common/stack_ripple_effect.dart';
import '../player/player_avatar.dart';

class PlaythroughPlayers extends StatelessWidget {
  const PlaythroughPlayers({
    Key key,
    @required this.playthroughPlayers,
    @required this.boardGameDetails,
    @required this.pageController,
  }) : super(key: key);

  int get _numberOfPlayerColumns => 3;
  final List<PlaythroughPlayer> playthroughPlayers;
  final BoardGameDetails boardGameDetails;
  final PageController pageController;

  static const int _playthroughsPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GridView.count(
          padding: const EdgeInsets.all(
            Dimensions.standardSpacing,
          ),
          crossAxisCount: _numberOfPlayerColumns,
          children: List.generate(
            playthroughPlayers.length,
            (int index) {
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
                    child: PlayerAvatar(playthroughPlayers[index].player),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ChangeNotifierProvider.value(
                      value: playthroughPlayers[index],
                      child: Consumer<PlaythroughPlayer>(
                        builder: (_, store, __) {
                          return Checkbox(
                            checkColor: AppTheme.accentColor,
                            activeColor: AppTheme.primaryColor.withOpacity(0.7),
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
                        playthroughPlayers[index].isChecked = !playthroughPlayers[index].isChecked;
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (playthroughPlayers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              bottom: Dimensions.standardSpacing,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconAndTextButton(
                icon: const DefaultIcon(Icons.play_arrow),
                onPressed: () => _onStartNewGame(context),
              ),
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

    final selectedPlaythoughPlayers =
        startPlaythroughStore.playthroughPlayers?.where((pp) => pp.isChecked)?.toList();

    final scaffold = Scaffold.of(context);
    if (selectedPlaythoughPlayers?.isEmpty ?? true) {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('You need to select at least one player to start a game'),
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
      boardGameDetails.id,
      selectedPlaythoughPlayers,
    );

    if (newPlaythrough == null) {
      scaffold.showSnackBar(
        SnackBar(
          content: const GenericErrorMessage(),
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
