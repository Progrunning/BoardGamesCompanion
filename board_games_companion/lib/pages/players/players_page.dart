import 'package:board_games_companion/common/app_text.dart';
import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/custom_icon_button.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/player/player_avatar.dart';
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
                    const _AppBar(),
                    _Players(playersViewModel: viewModel),
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
}

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      pinned: true,
      floating: true,
      titleSpacing: Dimensions.standardSpacing,
      title: TextField(
        autofocus: false,
        // focusNode: _searchFocusNode,
        // controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        style: AppTheme.defaultTextFieldStyle,
        decoration: InputDecoration(
          hintText: 'Search for a player...',
          // suffixIcon: (widget.boardGamesStore.searchPhrase?.isNotEmpty ?? false)
          //     ? IconButton(
          //         icon: const Icon(
          //           Icons.clear,
          //         ),
          //         color: AppTheme.accentColor,
          //         onPressed: () async {
          //           _searchController.text = '';
          //           await widget.updateSearchResults('');
          //         },
          //       )
          //     : const Icon(
          //         Icons.search,
          //         color: AppTheme.accentColor,
          //       ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColorLight),
          ),
        ),
        // onSubmitted: (searchPhrase) async {
        //   _debounce?.cancel();
        //   if (widget.boardGamesStore.searchPhrase != _searchController.text) {
        //     await widget.updateSearchResults(_searchController.text);
        //   }
        //   _searchFocusNode.unfocus();
        // },
      ),
      // actions: <Widget>[
      //   Consumer<BoardGamesFiltersStore>(
      //     builder: (_, boardGamesFiltersStore, __) {
      //       return IconButton(
      //         icon: boardGamesFiltersStore.anyFiltersApplied
      //             ? const Icon(Icons.filter_alt_rounded, color: AppTheme.accentColor)
      //             : const Icon(Icons.filter_alt_outlined, color: AppTheme.accentColor),
      //         onPressed: widget.boardGamesStore.allboardGames.isNotEmpty
      //             ? () async {
      //                 await _openFiltersPanel(context);
      //                 await widget.analyticsService.logEvent(name: Analytics.FilterCollection);
      //                 await widget.rateAndReviewService.increaseNumberOfSignificantActions();
      //               }
      //             : null,
      //       );
      //     },
      //   ),
      // ],
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
                AppText.playerPageNoPlayersTitle,
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
              AppText.playerPageNoPlayersInstructions,
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
    required this.playersViewModel,
    Key? key,
  }) : super(key: key);

  static const int _numberOfPlayerColumns = 3;

  final PlayersViewModel playersViewModel;

  @override
  Widget build(BuildContext context) {
    playersViewModel.players.sort((a, b) => a.name!.compareTo(b.name!));

    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      sliver: SliverGrid.count(
        crossAxisCount: _numberOfPlayerColumns,
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        children: [
          for (var player in playersViewModel.players)
            PlayerAvatar(
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
            ),
        ],
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
    return ElevatedIconButton(
      title: AppText.playerPageCreatePlayerButtonText,
      icon: const DefaultIcon(Icons.add),
      onPressed: () => onCreatePlayer(),
    );
  }
}
