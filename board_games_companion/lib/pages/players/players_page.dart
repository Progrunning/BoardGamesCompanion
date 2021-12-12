import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../stores/players_store.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/custom_icon_button.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/player/player_avatar.dart';
import 'player_page.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final int _numberOfPlayerColumns = 3;

  late PlayersStore playerStore;

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
    return SafeArea(
      child: ConsumerFutureBuilder<List<Player>, PlayersStore>(
        future: playerStore.loadPlayers(),
        success: (context, PlayersStore store) {
          if (store.players?.isEmpty ?? true) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  Dimensions.doubleStandardSpacing,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 60,
                    ),
                    const Center(
                      child: Text(
                        "You don't have any players",
                        style: TextStyle(
                          fontSize: Dimensions.extraLargeFontSize,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.doubleStandardSpacing,
                    ),
                    const Icon(
                      Icons.sentiment_dissatisfied_sharp,
                      size: 80,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(
                      height: Dimensions.doubleStandardSpacing,
                    ),
                    const Text(
                      'Create players to log games you played with your family or friends',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: Dimensions.mediumFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.doubleStandardSpacing,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: _CreatePlayerButton(
                        onCreatePlayer: () => Navigator.pushNamed(
                          context,
                          PlayerPage.pageRoute,
                          arguments: const PlayerPageArguments(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          store.players!.sort((a, b) => a.name!.compareTo(b.name!));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                child: Text(
                  'Players',
                  style: AppTheme.theme.textTheme.headline2,
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(Dimensions.standardSpacing),
                  crossAxisSpacing: Dimensions.standardSpacing,
                  mainAxisSpacing: Dimensions.standardSpacing,
                  crossAxisCount: _numberOfPlayerColumns,
                  children: List.generate(
                    store.players!.length,
                    (int index) {
                      final player = store.players![index];
                      return PlayerAvatar(
                        player,
                        topRightCornerActionWidget: CustomIconButton(
                          const Icon(
                            Icons.edit,
                            size: Dimensions.defaultButtonIconSize,
                            color: AppTheme.defaultTextColor,
                          ),
                          onTap: () async => _navigateToPlayerPage(context, player),
                        ),
                        onTap: () async => _navigateToPlayerPage(context, player),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.standardSpacing),
                  child: _CreatePlayerButton(
                    onCreatePlayer: () => Navigator.pushNamed(
                      context,
                      PlayerPage.pageRoute,
                      arguments: const PlayerPageArguments(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _navigateToPlayerPage(BuildContext context, Player player) async {
    await Navigator.pushNamed(
      context,
      PlayerPage.pageRoute,
      arguments: PlayerPageArguments(player: player),
    );
  }
}

class _CreatePlayerButton extends StatelessWidget {
  const _CreatePlayerButton({
    required this.onCreatePlayer,
    Key? key,
  }) : super(key: key);

  final VoidCallback onCreatePlayer;

  @override
  Widget build(BuildContext context) {
    return IconAndTextButton(
      title: 'Create Player',
      icon: const DefaultIcon(
        Icons.add,
      ),
      onPressed: () => onCreatePlayer(),
    );
  }
}
