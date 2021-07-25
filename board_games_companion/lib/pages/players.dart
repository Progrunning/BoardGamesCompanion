import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/cunsumer_future_builder_widget.dart';
import 'package:board_games_companion/widgets/common/custom_icon_button.dart';
import 'package:board_games_companion/widgets/player/player_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final int _numberOfPlayerColumns = 3;

  PlayersStore playerStore;

  @override
  void initState() {
    super.initState();

    playerStore = Provider.of<PlayersStore>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConsumerFutureBuilder<List<Player>, PlayersStore>(
      future: playerStore.loadPlayers(),
      success: (context, PlayersStore store) {
        if (store.players?.isEmpty ?? true) {
          return const Padding(
            padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
            child: Center(
              child: Text('It looks empty here, try adding a new player'),
            ),
          );
        }

        store.players.sort((a, b) => a.name?.compareTo(b.name));

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              Dimensions.standardSpacing,
            ),
            child: GridView.count(
              crossAxisCount: _numberOfPlayerColumns,
              children: List.generate(
                store.players.length,
                (int index) {
                  final player = store.players[index];
                  return PlayerGridItem(
                    player,
                    topRightCornerActionWidget: _buildTopRightCornerAction(context, player),
                    onTap: () async {
                      await _navigateToCreateOrEditPlayer(context, player);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToCreateOrEditPlayer(BuildContext context, Player player) async {
    await NavigatorHelper.navigateToCreatePlayerPage(
      context,
      player: player,
    );
  }

  // TODO MK Refactor - don't use methods to create UI elements
  Widget _buildTopRightCornerAction(BuildContext context, Player player) => Align(
        alignment: Alignment.topRight,
        child: CustomIconButton(
          const Icon(
            Icons.edit,
            size: Dimensions.defaultButtonIconSize,
            color: AppTheme.defaultTextColor,
          ),
          onTap: () async {
            await _navigateToCreateOrEditPlayer(context, player);
          },
        ),
      );
}
