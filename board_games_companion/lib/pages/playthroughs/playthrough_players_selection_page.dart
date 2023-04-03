import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_players_selection_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../widgets/common/bgc_checkbox.dart';
import '../../widgets/player/player_avatar.dart';
import 'playthrough_players_selection_view_model.dart';

class PlahtyroughPlayersSelectionPage extends StatefulWidget {
  const PlahtyroughPlayersSelectionPage({
    required this.viewModel,
    super.key,
  });

  final PlaythroughPlayersSelectionViewModel viewModel;

  static const String pageRoute = '/playthroughPlayersSelection';

  @override
  State<PlahtyroughPlayersSelectionPage> createState() => _PlahtyroughPlayersSelectionPageState();
}

class _PlahtyroughPlayersSelectionPageState extends State<PlahtyroughPlayersSelectionPage> {
  int get _numberOfPlayerColumns => 4;

  @override
  void initState() {
    super.initState();

    widget.viewModel.loadPlayers();
  }

  @override
  Widget build(BuildContext context) {
    final playerAvatarSize = MediaQuery.of(context).size.width / _numberOfPlayerColumns;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppText.playthroughPlayersSelectionPageTitle,
            style: AppTheme.titleTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Observer(
            builder: (_) {
              switch (widget.viewModel.futureLoadPlayers?.status ?? FutureStatus.pending) {
                case FutureStatus.pending:
                case FutureStatus.rejected:
                  return const SizedBox.shrink();
                case FutureStatus.fulfilled:
                  return _Players(
                    players: widget.viewModel.players,
                    selectedPlayersMap: widget.viewModel.selectedPlayersMap,
                    numberOfPlayerColumns: _numberOfPlayerColumns,
                    playerAvatarSize: playerAvatarSize,
                    togglePlayerSelection: (player) =>
                        widget.viewModel.togglePlayerSelection(player),
                  );
              }
            },
          ),
        ),
        floatingActionButton: Observer(
          builder: (_) {
            return FloatingActionButton(
              onPressed: widget.viewModel.hasSelectedPlayers ? () async => _navigateBack() : null,
              backgroundColor: widget.viewModel.hasSelectedPlayers
                  ? AppColors.accentColor
                  : AppColors.disabledFloatinActionButtonColor,
              child: const Icon(Icons.check),
            );
          },
        ),
      ),
    );
  }

  void _navigateBack() {
    Navigator.pop(
      context,
      PlaythroughPlayersSelectionResult.selectedPlayers(
        players: widget.viewModel.selectedPlayersMap.values.toList(),
      ),
    );
  }
}

class _Players extends StatelessWidget {
  const _Players({
    required this.players,
    required this.selectedPlayersMap,
    required this.numberOfPlayerColumns,
    required this.playerAvatarSize,
    required this.togglePlayerSelection,
  });

  final List<Player> players;
  final Map<String, Player> selectedPlayersMap;
  final int numberOfPlayerColumns;
  final double playerAvatarSize;
  final void Function(Player) togglePlayerSelection;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: numberOfPlayerColumns,
      crossAxisSpacing: Dimensions.standardSpacing,
      mainAxisSpacing: Dimensions.standardSpacing,
      children: [
        for (final player in players)
          Stack(
            children: <Widget>[
              PlayerAvatar(
                player: player,
                avatarImageSize: Size(playerAvatarSize, playerAvatarSize),
                onTap: () => togglePlayerSelection(player),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Observer(
                  builder: (_) {
                    return BgcCheckbox(
                      isChecked: selectedPlayersMap.containsKey(player.id),
                      onChanged: (isChecked) => togglePlayerSelection(player),
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}
