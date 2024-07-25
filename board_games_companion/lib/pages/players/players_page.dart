import 'package:basics/basics.dart';
import 'package:board_games_companion/pages/players/players_visual_state.dart';
import 'package:board_games_companion/widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/elevated_container.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/player/player_image.dart';
import '../player/player_page.dart';
import 'players_view_model.dart';

typedef PlayerTapped = void Function(Player player, bool isChecked);
typedef PlayerLongPressed = void Function(Player player);
typedef PlayerSearchResultTapped = void Function(Player player);

class PlayersPage extends StatefulWidget {
  const PlayersPage({
    required this.viewModel,
    super.key,
  });

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
  Widget build(BuildContext context) => Stack(
        children: [
          Observer(
            builder: (context) {
              return switch (widget.viewModel.visualState) {
                LoadingPlayers() => CustomScrollView(
                    slivers: [
                      _AppBar(
                        onToggleShowDeletedPlayers: () =>
                            widget.viewModel.toggleShowDeletedPlayers(),
                      ),
                      const SliverFillRemaining(child: LoadingIndicator()),
                    ],
                  ),
                LoadingFailed() => const CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
                          child: Center(child: GenericErrorMessage()),
                        ),
                      ),
                    ],
                  ),
                NoPlayers() => CustomScrollView(
                    slivers: [
                      _AppBar(
                        onToggleShowDeletedPlayers: () =>
                            widget.viewModel.toggleShowDeletedPlayers(),
                      ),
                      const _NoPlayers(),
                    ],
                  ),
                NoActivePlayers() => CustomScrollView(
                    slivers: [
                      _AppBar(
                        onToggleShowDeletedPlayers: () =>
                            widget.viewModel.toggleShowDeletedPlayers(),
                      ),
                      const _NoPlayers(),
                    ],
                  ),
                _ => CustomScrollView(
                    slivers: [
                      _AppBar(
                        onToggleShowDeletedPlayers: () =>
                            widget.viewModel.toggleShowDeletedPlayers(),
                      ),
                      Observer(
                        builder: (_) {
                          return widget.viewModel.visualState.maybeWhen(
                            activePlayers: (activePlayers) => _Players(
                              players: activePlayers,
                              isDeletePlayersMode: false,
                              onPlayerTap: (player, isChecked) =>
                                  _playerTapped(widget.viewModel, player, isChecked),
                              onPlayerLongPress: (player) =>
                                  widget.viewModel.toggleDeletePlayersMode(),
                            ),
                            deletePlayers: (activePlayers) => _Players(
                              players: activePlayers,
                              isDeletePlayersMode: true,
                              onPlayerTap: (player, isChecked) =>
                                  _playerTapped(widget.viewModel, player, isChecked),
                              onPlayerLongPress: (player) =>
                                  widget.viewModel.toggleDeletePlayersMode(),
                            ),
                            allPlayersPlayers: (activePlayers, deletedPlayers) => _AllPlayers(
                              activePlayers: activePlayers,
                              deletedPlayers: deletedPlayers,
                              onPlayerTap: (player, isChecked) =>
                                  _playerTapped(widget.viewModel, player, isChecked),
                            ),
                            orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                          );
                        },
                      ),
                    ],
                  )
              };
            },
          ),
          Observer(
            builder: (context) => _FloatingActionButton(
              isDeletePlayersMode: widget.viewModel.visualState.isDeletePlayersMode,
              confirmDeletePlayersCallback: () async =>
                  await _showDeletePlayersDialog(context) ?? false,
              hasAnyActivePlayers: widget.viewModel.hasAnyActivePlayers,
              activePlayers: widget.viewModel.activePlayers,
              onSearchResultTapped: (player) => _navigateToPlayerPage(context, player),
            ),
          ),
        ],
      );

  Future<void> _navigateToPlayerPage(BuildContext context, Player player) async {
    await Navigator.pushNamed(
      context,
      PlayerPage.pageRoute,
      arguments: PlayerPageArguments(player: player),
    );
  }

  Future<void> _playerTapped(
    PlayersViewModel playersViewModel,
    Player player,
    bool isChecked,
  ) async {
    if (!playersViewModel.visualState.isDeletePlayersMode) {
      return _navigateToPlayerPage(context, player);
    }

    if (isChecked) {
      playersViewModel.selectPlayer(player);
    } else {
      playersViewModel.deselectPlayer(player);
    }
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
                if (!context.mounted) {
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
    required this.onToggleShowDeletedPlayers,
  });

  final VoidCallback onToggleShowDeletedPlayers;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      forceElevated: true,
      elevation: Dimensions.defaultElevation,
      titleSpacing: Dimensions.standardSpacing,
      foregroundColor: AppColors.accentColor,
      centerTitle: false,
      title: const Text(AppText.playersPageTitle, style: AppTheme.titleTextStyle),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep, color: AppColors.enabledIconIconColor),
          onPressed: onToggleShowDeletedPlayers,
        ),
      ],
    );
  }
}

class _NoPlayers extends StatelessWidget {
  const _NoPlayers();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
        child: Column(
          children: <Widget>[
            SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
            Center(
              child: Text(
                AppText.playersPageNoPlayersTitle,
                style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
              ),
            ),
            SizedBox(height: Dimensions.doubleStandardSpacing),
            Icon(
              Icons.people,
              size: Dimensions.emptyPageTitleIconSize,
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

class _NoDeletedPlayers extends StatelessWidget {
  const _NoDeletedPlayers();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                AppText.playersPageNoDeletedPlayersTitle,
                style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
              ),
            ),
            SizedBox(height: Dimensions.doubleStandardSpacing),
            Icon(
              Icons.delete_sweep,
              size: Dimensions.emptyPageTitleIconSize,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _AllPlayers extends StatelessWidget {
  const _AllPlayers({
    required this.activePlayers,
    required this.deletedPlayers,
    required this.onPlayerTap,
  });

  final List<Player> activePlayers;
  final List<Player> deletedPlayers;
  final PlayerTapped onPlayerTap;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPersistentHeader(
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.playersPageDeletedPlayersSectionTitle,
          ),
        ),
        if (deletedPlayers.isEmpty)
          const _NoDeletedPlayers()
        else
          _Players(
            players: deletedPlayers,
            onPlayerTap: onPlayerTap,
          ),
        SliverPersistentHeader(
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.playersPageActivePlayersSectionTitle,
          ),
        ),
        if (activePlayers.isEmpty)
          const _NoPlayers()
        else
          _Players(
            players: activePlayers,
            onPlayerTap: onPlayerTap,
          )
      ],
    );
  }
}

class _Players extends StatelessWidget {
  const _Players({
    required this.players,
    required this.onPlayerTap,
    this.onPlayerLongPress,
    this.isDeletePlayersMode = false,
  });

  static const int _numberOfPlayerColumns = 3;

  final List<Player> players;
  final bool isDeletePlayersMode;
  final PlayerTapped onPlayerTap;
  final PlayerLongPressed? onPlayerLongPress;

  @override
  Widget build(BuildContext context) {
    final playerAvatarSize = MediaQuery.of(context).size.width / _numberOfPlayerColumns;

    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      sliver: SliverGrid.count(
        crossAxisCount: _numberOfPlayerColumns,
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        children: [
          for (final player in players)
            _Player(
              player: player,
              onPlayerTap: onPlayerTap,
              onPlayerLongPress: onPlayerLongPress,
              isDeletePlayersMode: isDeletePlayersMode,
              avatarImageSize: Size(playerAvatarSize, playerAvatarSize),
            ),
        ],
      ),
    );
  }
}

class _Player extends StatefulWidget {
  const _Player({
    required this.player,
    required this.onPlayerTap,
    required this.onPlayerLongPress,
    required this.isDeletePlayersMode,
    required this.avatarImageSize,
  });

  final Player player;
  final PlayerTapped onPlayerTap;
  final PlayerLongPressed? onPlayerLongPress;
  final bool isDeletePlayersMode;

  final Size avatarImageSize;

  @override
  State<_Player> createState() => _PlayerState();
}

class _PlayerState extends State<_Player> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlayerAvatar(
          player: widget.player,
          avatarImageSize: widget.avatarImageSize,
          onTap: () => _onTap(),
          onLongPress: () => widget.onPlayerLongPress?.call(widget.player),
        ),
        if (widget.isDeletePlayersMode)
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
        textTheme: const TextTheme(titleLarge: AppTheme.defaultTextFieldStyle),
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
          titleAlignment: ListTileTitleAlignment.center,
          subtitle: player.bggName != null ? Text(player.bggName!) : const SizedBox.shrink(),
          trailing: (player.isDeleted ?? false)
              ? const Icon(
                  Icons.delete_outline_sharp,
                  color: AppColors.redColor,
                )
              : null,
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
    required this.filteredPlayers,
    required this.onResultTap,
  });

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
                        style: AppTheme.theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.normal),
                      ),
                      if (player.bggName?.isNotBlank ?? false) ...[
                        const SizedBox(height: Dimensions.doubleStandardSpacing),
                        const ItemPropertyTitle(AppText.playerPagePlayerBggNameTitle),
                        Text(
                          player.bggName!,
                          style: AppTheme.theme.textTheme.headlineMedium
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
    required this.query,
    required this.onClear,
  });

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

class _FloatingActionButton extends StatefulWidget {
  const _FloatingActionButton({
    required this.isDeletePlayersMode,
    required this.hasAnyActivePlayers,
    required this.activePlayers,
    required this.confirmDeletePlayersCallback,
    required this.onSearchResultTapped,
  });

  final bool isDeletePlayersMode;
  final bool hasAnyActivePlayers;
  final List<Player> activePlayers;
  final Future<bool> Function() confirmDeletePlayersCallback;
  final void Function(Player) onSearchResultTapped;

  @override
  State<_FloatingActionButton> createState() => _FloatingActionButtonState();
}

class _FloatingActionButtonState extends State<_FloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Dimensions.bottomTabTopHeight,
      right: Dimensions.standardSpacing,
      child: widget.isDeletePlayersMode
          ? ElevatedIconButton(
              title: AppText.playersPageDeletePlayersButtonText,
              icon: const DefaultIcon(Icons.delete),
              color: AppColors.redColor,
              onPressed: () async {
                final deleteConfirmed = await widget.confirmDeletePlayersCallback();
                if (deleteConfirmed) {
                  setState(() {});
                }
              },
            )
          : SpeedDial(
              icon: Icons.menu,
              backgroundColor: AppColors.accentColor,
              activeBackgroundColor: AppColors.redColor,
              overlayColor: AppColors.dialogBackgroundColor,
              activeIcon: Icons.close,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.create),
                  backgroundColor: AppColors.accentColor,
                  foregroundColor: Colors.white,
                  label: AppText.playersPageCreatePlayerButtonText,
                  labelBackgroundColor: AppColors.accentColor,
                  shape: const CircleBorder(),
                  onTap: () async => Navigator.pushNamed(
                    context,
                    PlayerPage.pageRoute,
                    arguments: const PlayerPageArguments(player: null),
                  ),
                ),
                if (widget.hasAnyActivePlayers)
                  SpeedDialChild(
                    child: const Icon(Icons.search),
                    backgroundColor: AppColors.greenColor,
                    foregroundColor: Colors.white,
                    label: AppText.playersPageSearchPlayerButtonText,
                    labelBackgroundColor: AppColors.greenColor,
                    shape: const CircleBorder(),
                    onTap: () async => showSearch<Player?>(
                      context: context,
                      delegate: _PlayersSerach(
                        players: widget.activePlayers,
                        onResultTap: (player) => widget.onSearchResultTapped(player),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
