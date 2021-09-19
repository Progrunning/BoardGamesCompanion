import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../stores/players_store.dart';
import '../../utilities/navigator_helper.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/custom_icon_button.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/player/player_avatar.dart';

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
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(Dimensions.standardSpacing),
                  crossAxisSpacing: Dimensions.standardSpacing,
                  mainAxisSpacing: Dimensions.standardSpacing,
                  crossAxisCount: _numberOfPlayerColumns,
                  children: List.generate(
                    store.players.length,
                    (int index) {
                      final player = store.players[index];
                      return PlayerAvatar(
                        player,
                        topRightCornerActionWidget: CustomIconButton(
                          const Icon(
                            Icons.edit,
                            size: Dimensions.defaultButtonIconSize,
                            color: AppTheme.defaultTextColor,
                          ),
                          onTap: () async => _navigateToCreateOrEditPlayer(context, player),
                        ),
                        onTap: () async => _navigateToCreateOrEditPlayer(context, player),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.standardSpacing),
                  child: IconAndTextButton(
                    title: 'Add Player',
                    icon: const DefaultIcon(
                      Icons.add,
                    ),
                    onPressed: () => NavigatorHelper.navigateToCreatePlayerPage(context),
                  ),
                ),
              ),
            ],
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
}
