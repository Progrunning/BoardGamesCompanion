import 'package:basics/basics.dart';
import 'package:flutter/material.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/shadow_box.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/player/player_image.dart';
import 'player_page.dart';
import 'players_view_model.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({
    required this.playersViewModel,
    Key? key,
  }) : super(key: key);

  final PlayersViewModel playersViewModel;

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConsumerFutureBuilder<List<Player>, PlayersViewModel>(
        future: widget.playersViewModel.loadPlayers(),
        success: (context, PlayersViewModel viewModel) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  if (viewModel.players.isNotEmpty) ...[
                    _AppBar(
                      players: viewModel.players,
                      onSearchResultTap: (Player player) => _navigateToPlayerPage(context, player),
                    ),
                    _Players(
                      players: viewModel.players,
                      onPlayerSelected: (Player player) => _navigateToPlayerPage(context, player),
                    ),
                  ] else
                    const _NoPlayers(),
                ],
              ),
              Positioned(
                bottom: Dimensions.bottomTabTopHeight,
                right: Dimensions.standardSpacing,
                child: _CreatePlayerButton(
                  onCreatePlayer: () => Navigator.pushNamed(
                    context,
                    PlayerPage.pageRoute,
                    arguments: const PlayerPageArguments(),
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

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
    required this.players,
    required this.onSearchResultTap,
  }) : super(key: key);

  final List<Player> players;
  final Function(Player) onSearchResultTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      titleSpacing: Dimensions.standardSpacing,
      title: const Text('Players'),

      // TODO Add ability to edit/select multiple players at once
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search, color: AppTheme.accentColor),
          onPressed: () async {
            await showSearch(
              context: context,
              delegate: _PlayersSerach(
                players: players,
                onResultTap: onSearchResultTap,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NoPlayers extends StatelessWidget {
  const _NoPlayers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
        child: Column(
          children: const <Widget>[
            SizedBox(height: 60),
            Center(
              child: Text(
                AppText.playersPageNoPlayersTitle,
                style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
              ),
            ),
            SizedBox(height: Dimensions.doubleStandardSpacing),
            Icon(
              Icons.sentiment_dissatisfied_sharp,
              size: 80,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: Dimensions.doubleStandardSpacing),
            Text(
              AppText.playersPageNoPlayersInstructions,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: Dimensions.mediumFontSize),
            ),
            SizedBox(height: Dimensions.doubleStandardSpacing),
          ],
        ),
      ),
    );
  }
}

class _Players extends StatelessWidget {
  const _Players({
    required this.players,
    required this.onPlayerSelected,
    Key? key,
  }) : super(key: key);

  static const int _numberOfPlayerColumns = 3;

  final List<Player> players;
  final Function(Player) onPlayerSelected;

  @override
  Widget build(BuildContext context) {
    players.sort((a, b) => a.name!.compareTo(b.name!));

    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      sliver: SliverGrid.count(
        crossAxisCount: _numberOfPlayerColumns,
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        children: [
          for (var player in players)
            PlayerAvatar(
              player,
              onTap: () async => onPlayerSelected(player),
            ),
        ],
      ),
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
    return ElevatedIconButton(
      title: AppText.playersPageCreatePlayerButtonText,
      icon: const DefaultIcon(Icons.add),
      onPressed: () => onCreatePlayer(),
    );
  }
}

class _PlayersSerach extends SearchDelegate<Player?> {
  _PlayersSerach({
    required this.players,
    required this.onResultTap,
  });

  final List<Player> players;
  final Function(Player) onResultTap;

  @override
  ThemeData appBarTheme(BuildContext context) => AppTheme.theme.copyWith(
        textTheme: const TextTheme(headline6: AppTheme.defaultTextFieldStyle),
      );

  @override
  String? get searchFieldLabel => AppText.playerPageSearchHintText;

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) {
      return [const SizedBox()];
    }

    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox();
    }

    final queryLowercased = query.toLowerCase();
    final filterPlayers = players
        .where((player) =>
            (player.name?.toLowerCase().contains(queryLowercased) ?? false) ||
            (player.bggName?.toLowerCase().contains(queryLowercased) ?? false))
        .toList();

    if (filterPlayers.isEmpty) {
      return _NoSearchResults(query: query, onClear: () => query = '');
    }

    return _SearchResults(filterPlayers: filterPlayers, onResultTap: onResultTap);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
    required this.filterPlayers,
    required this.onResultTap,
  }) : super(key: key);

  final List<Player> filterPlayers;
  final Function(Player player) onResultTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: ListView.separated(
        itemCount: filterPlayers.length,
        separatorBuilder: (_, index) {
          return const SizedBox(height: Dimensions.doubleStandardSpacing);
        },
        itemBuilder: (_, index) {
          final player = filterPlayers[index];
          // TODO Fix the splash to show on top of the player image and clip the corners
          return InkWell(
            onTap: () => onResultTap(player),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dimensions.searchResultsPlayerAvatarSize,
                  width: Dimensions.searchResultsPlayerAvatarSize,
                  child: Ink(child: ShadowBox(child: PlayerImage(imageUri: player.avatarImageUri))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ItemPropertyTitle(AppText.playerPagePlayerNameTitle),
                      Text(
                        player.name ?? '',
                        style: AppTheme.theme.textTheme.headline4
                            ?.copyWith(fontWeight: FontWeight.normal),
                      ),
                      if (player.bggName?.isNotBlank ?? false) ...[
                        const SizedBox(height: Dimensions.doubleStandardSpacing),
                        const ItemPropertyTitle(AppText.playerPagePlayerBggNameTitle),
                        Text(
                          player.bggName!,
                          style: AppTheme.theme.textTheme.headline4
                              ?.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({
    Key? key,
    required this.query,
    required this.onClear,
  }) : super(key: key);

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: AppText.playerPageSearchNoSearchResults),
              TextSpan(
                text: query,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        Center(
          child: ElevatedIconButton(
            title: AppText.playerPageSearchClearSaerch,
            icon: const DefaultIcon(Icons.clear),
            onPressed: onClear,
          ),
        ),
      ],
    );
  }
}
