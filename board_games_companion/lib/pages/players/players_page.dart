import 'package:basics/basics.dart';
import 'package:board_games_companion/common/app_styles.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/elevated_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/player/player_image.dart';
import '../player/player_page.dart';
import 'players_view_model.dart';

typedef PlayerTapped = void Function(Player player, bool isChecked);
typedef PlayerSearchResultTapped = void Function(Player player);

class PlayersPage extends StatefulWidget {
  const PlayersPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PlayersViewModel viewModel;

  @override
  PlayersPageState createState() => PlayersPageState();
}

class PlayersPageState extends State<PlayersPage> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.loadPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        switch (widget.viewModel.futureLoadPlayers?.status ?? FutureStatus.pending) {
          case FutureStatus.pending:
          case FutureStatus.rejected:
            return const CustomScrollView(
              slivers: [
                _AppBar(players: []),
                SliverFillRemaining(
                  child: LoadingIndicator(),
                ),
              ],
            );
          case FutureStatus.fulfilled:
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    if (widget.viewModel.players.isNotEmpty) ...[
                      _AppBar(
                        players: widget.viewModel.players,
                        onSearchResultTap: (Player player) =>
                            _navigateToPlayerPage(context, player),
                        onToggleEditModeTap: () => _toggleEditMode(),
                      ),
                      Observer(
                        builder: (_) {
                          return _Players(
                            players: widget.viewModel.players,
                            isEditMode: widget.viewModel.isEditMode,
                            onPlayerTap: (Player player, bool isChecked) =>
                                _playerTapped(widget.viewModel, player, isChecked),
                          );
                        },
                      ),
                    ] else ...[
                      const _AppBar(players: []),
                      const _NoPlayers(),
                    ]
                  ],
                ),
                Positioned(
                  bottom: Dimensions.bottomTabTopHeight,
                  right: Dimensions.standardSpacing,
                  child: widget.viewModel.isEditMode
                      ? ElevatedIconButton(
                          title: AppText.playersPageDeletePlayersButtonText,
                          icon: const DefaultIcon(Icons.delete),
                          color: AppColors.redColor,
                          onPressed: () async {
                            if (await _showDeletePlayersDialog(context) ?? false) {
                              setState(() {});
                            }
                          },
                        )
                      : ElevatedIconButton(
                          title: AppText.playersPageCreatePlayerButtonText,
                          icon: const DefaultIcon(Icons.add),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            PlayerPage.pageRoute,
                            arguments: const PlayerPageArguments(player: null),
                          ),
                        ),
                ),
              ],
            );
        }
      },
    );
  }

  Future<void> _navigateToPlayerPage(BuildContext context, Player player) async {
    await Navigator.pushNamed(
      context,
      PlayerPage.pageRoute,
      arguments: PlayerPageArguments(player: player),
    );
  }

  Future<void> _playerTapped(
      PlayersViewModel playersViewModel, Player player, bool isChecked) async {
    if (!playersViewModel.isEditMode) {
      return _navigateToPlayerPage(context, player);
    }

    if (isChecked) {
      playersViewModel.selectPlayer(player);
    } else {
      playersViewModel.deselectPlayer(player);
    }
  }

  void _toggleEditMode() {
    widget.viewModel.isEditMode = !widget.viewModel.isEditMode;
  }

  Future<bool?> _showDeletePlayersDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppText.playersPageConfirmationTitle),
          content: const Text(AppText.playersPageConfirmationDialogContent),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(AppText.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () async {
                await widget.viewModel.deleteSelectedPlayers();
                if (!mounted) {
                  return;
                }

                Navigator.of(context).pop(true);
              },
              child: const Text(
                AppText.playersPageConfirmationDialogDeletePlayersButtonText,
                style: TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
    required this.players,
    this.onSearchResultTap,
    this.onToggleEditModeTap,
  }) : super(key: key);

  final List<Player> players;
  final PlayerSearchResultTapped? onSearchResultTap;
  final VoidCallback? onToggleEditModeTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      titleSpacing: Dimensions.standardSpacing,
      foregroundColor: AppColors.accentColor,
      title: const Text(AppText.playersPageTitle, style: AppTheme.titleTextStyle),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.edit,
            color: onSearchResultTap == null
                ? AppColors.disabledIconIconColor
                : AppColors.enabledIconIconColor,
          ),
          onPressed: onToggleEditModeTap == null ? null : () => onToggleEditModeTap?.call(),
        ),
        IconButton(
          icon: Icon(
            Icons.search,
            color: onSearchResultTap == null
                ? AppColors.disabledIconIconColor
                : AppColors.enabledIconIconColor,
          ),
          onPressed: onSearchResultTap == null
              ? null
              : () async {
                  await showSearch(
                    context: context,
                    delegate: _PlayersSerach(
                      players: players,
                      onResultTap: (player) => onSearchResultTap?.call(player),
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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
        child: Column(
          children: const <Widget>[
            SizedBox(height: 40),
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
              color: AppColors.primaryColor,
            ),
            SizedBox(height: Dimensions.doubleStandardSpacing),
            Text(
              AppText.playersPageNoPlayersInstructions,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: Dimensions.mediumFontSize),
            ),
          ],
        ),
      ),
    );
  }
}

class _Players extends StatelessWidget {
  const _Players({
    required this.players,
    required this.isEditMode,
    required this.onPlayerTap,
    Key? key,
  }) : super(key: key);

  static const int _numberOfPlayerColumns = 3;

  final List<Player> players;
  final bool isEditMode;
  final PlayerTapped onPlayerTap;

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
            _Player(player: player, onPlayerTap: onPlayerTap, isEditMode: isEditMode),
        ],
      ),
    );
  }
}

class _Player extends StatefulWidget {
  const _Player({
    Key? key,
    required this.player,
    required this.onPlayerTap,
    required this.isEditMode,
  }) : super(key: key);

  final Player player;
  final PlayerTapped onPlayerTap;
  final bool isEditMode;

  @override
  State<_Player> createState() => _PlayerState();
}

class _PlayerState extends State<_Player> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlayerAvatar(widget.player, onTap: () => _onTap()),
        if (widget.isEditMode)
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: 34,
              width: 34,
              child: Checkbox(
                checkColor: AppColors.accentColor,
                activeColor: AppColors.primaryColor.withOpacity(0.7),
                value: isChecked,
                onChanged: (_) => _onTap(),
              ),
            ),
          ),
      ],
    );
  }

  void _onTap() {
    setState(() {
      isChecked = !isChecked;
      widget.onPlayerTap(widget.player, isChecked);
    });
  }
}

class _PlayersSerach extends SearchDelegate<Player?> {
  _PlayersSerach({
    required this.players,
    required this.onResultTap,
  });

  final List<Player> players;
  final PlayerSearchResultTapped onResultTap;

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
      return ListView();
    }

    final filteredPlayers = _filterPlayers(query);
    if (filteredPlayers.isEmpty) {
      return _NoSearchResults(query: query, onClear: () => query = '');
    }

    return _SearchResults(filteredPlayers: filteredPlayers, onResultTap: onResultTap);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView();
    }

    final filteredPlayers = _filterPlayers(query);
    if (filteredPlayers.isEmpty) {
      return ListView();
    }

    return ListView.builder(
      itemCount: filteredPlayers.length,
      itemBuilder: (_, index) {
        final player = filteredPlayers[index];
        return ListTile(
          title: Text(player.name!),
          subtitle: player.bggName != null ? Text(player.bggName!) : const SizedBox.shrink(),
          onTap: () {
            query = player.name!;
            showResults(context);
          },
        );
      },
    );
  }

  List<Player> _filterPlayers(String query) {
    final queryLowercased = query.toLowerCase();
    return players
        .where((Player player) =>
            (player.name?.toLowerCase().contains(queryLowercased) ?? false) ||
            (player.bggName?.toLowerCase().contains(queryLowercased) ?? false))
        .toList();
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
    required this.filteredPlayers,
    required this.onResultTap,
  }) : super(key: key);

  final List<Player> filteredPlayers;
  final PlayerSearchResultTapped onResultTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: filteredPlayers.length,
      separatorBuilder: (_, index) => const SizedBox(height: Dimensions.doubleStandardSpacing),
      itemBuilder: (_, index) {
        final player = filteredPlayers[index];
        // TODO Fix the ripple effect when tapped to show on top of the player image and clip the corners
        return Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? Dimensions.standardSpacing : 0,
            bottom: index == filteredPlayers.length - 1 ? Dimensions.standardSpacing : 0,
            left: Dimensions.standardSpacing,
            right: Dimensions.standardSpacing,
          ),
          child: InkWell(
            onTap: () => onResultTap(player),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppStyles.defaultCornerRadius),
              bottomLeft: Radius.circular(AppStyles.defaultCornerRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dimensions.searchResultsPlayerAvatarSize,
                  width: Dimensions.searchResultsPlayerAvatarSize,
                  child: ElevatedContainer(
                    elevation: AppStyles.defaultElevation,
                    child: Hero(
                      tag: '${AnimationTags.playerImageHeroTag}${player.id}',
                      child: PlayerImage(imageUri: player.avatarImageUri),
                    ),
                  ),
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
          ),
        );
      },
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
