import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/enums/game_family.dart';
import '../../extensions/date_time_extensions.dart';
import '../../injectable.dart';
import '../../mixins/enter_score_dialog.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/edit_playthrough_page_arguments.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_players_selection_result.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/empty_page_information_panel.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/segmented_buttons/bgc_segmented_button.dart';
import '../../widgets/common/segmented_buttons/bgc_segmented_buttons_container.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/cooperative_game_result_segmented_button.dart';
import '../edit_playthrough/edit_playthrough_page.dart';
import '../enter_score/enter_score_view_model.dart';
import '../player/player_page.dart';
import 'playthrough_players_selection_page.dart';
import 'playthrough_timeline.dart';
import 'playthroughs_log_game_players.dart';
import 'playthroughs_log_game_view_model.dart';
import 'playthroughs_page.dart';

class PlaythroughsLogGamePage extends StatefulWidget {
  const PlaythroughsLogGamePage({
    required this.parentPageTabController,
    Key? key,
  }) : super(key: key);

  final TabController parentPageTabController;

  @override
  PlaythroughsLogGamePageState createState() => PlaythroughsLogGamePageState();
}

class PlaythroughsLogGamePageState extends State<PlaythroughsLogGamePage> {
  late PlaythroughsLogGameViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt<PlaythroughsLogGameViewModel>();
    viewModel.loadPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (viewModel.futureLoadPlayers?.status ?? FutureStatus.pending) {
          case FutureStatus.pending:
          case FutureStatus.rejected:
            return const SizedBox.shrink();
          case FutureStatus.fulfilled:
            return CustomScrollView(
              slivers: [
                Observer(
                  builder: (_) {
                    return _TimelineSection(
                      playthroughTimeline: viewModel.playthroughTimeline,
                      onPlaythroughTimelineChanged: (playthroughTimeline) =>
                          viewModel.setPlaythroughTimeline(playthroughTimeline),
                    );
                  },
                ),
                Observer(
                  builder: (_) {
                    return viewModel.playthroughTimeline.maybeWhen(
                      inThePast: () => _DateAndDurationSection(
                        playthroughDate: viewModel.playthroughDate,
                        playthroughDuration: viewModel.playthroughDuration,
                        onPlaythroughTimeChanged: (playthoughDate) =>
                            viewModel.playthroughDate = playthoughDate,
                        onPlaythroughDurationChanged: (playthoughDuration) =>
                            viewModel.playthroughDuration = playthoughDuration,
                      ),
                      orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                    );
                  },
                ),
                Observer(
                  builder: (_) {
                    if (viewModel.gameFamily == GameFamily.Cooperative &&
                        viewModel.playthroughTimeline == const PlaythroughTimeline.inThePast()) {
                      return _CooperativeResultSection(
                        cooperativeGameResult: viewModel.cooperativeGameResult,
                        onCooperativeGameResultChanged: (cooperativeGameResult) =>
                            viewModel.updateCooperativeGameResult(cooperativeGameResult),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
                Observer(
                  builder: (_) => _PlayersSection(
                    playthroughTimeline: viewModel.playthroughTimeline,
                    gameFamily: viewModel.gameFamily,
                    players: viewModel.playersState,
                    onCreatePlayer: () => _handleCreatePlayer(),
                    onSelectPlayers: () => _handleSelectPlayers(),
                    onPlayerScoreUpdated: (playerScore, score) =>
                        _handlePlayerScoreUpdate(playerScore, score),
                  ),
                ),
                Observer(
                  builder: (_) => _SubmitSection(
                    players: viewModel.playersState,
                    onLogPlaythrough: () => _handleLoggingPlaythrough(),
                  ),
                ),
              ],
            );
        }
      },
    );
  }

  Future<void> _handleCreatePlayer() async {
    await Navigator.pushNamed(
      context,
      PlayerPage.pageRoute,
      arguments: const PlayerPageArguments(),
    );

    // MK Reload players after getting back from players page
    viewModel.loadPlayers();
  }

  Future<void> _handleSelectPlayers() async {
    final playersSearchResult = await Navigator.pushNamed<PlaythroughPlayersSelectionResult?>(
      context,
      PlahtyroughPlayersSelectionPage.pageRoute,
    );

    playersSearchResult?.when(
      selectedPlayers: (players) => viewModel.setSelectedPlayers(players),
    );
  }

  void _handlePlayerScoreUpdate(PlayerScore playerScore, int score) {
    viewModel.updatePlayerScore(playerScore, score);
  }

  Future<void> _handleLoggingPlaythrough() async {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    final navigatorState = Navigator.of(context);
    final newPlaythrough = await viewModel.createPlaythrough();
    if (newPlaythrough == null) {
      _showLogGameFailureSnackbar(scaffoldMessengerState);
      return;
    }

    viewModel.playthroughTimeline.maybeWhen(
      now: () async {
        await navigatorState.pushNamed(
          EditPlaythroughPage.pageRoute,
          arguments: EditPlaythroughPageArguments(
            playthroughId: newPlaythrough.id,
            boardGameId: viewModel.boardGameId,
            goBackPageRoute: PlaythroughsPage.pageRoute,
          ),
        );
        widget.parentPageTabController.animateTo(PlaythroughsPage.historyTabIndex);
      },
      inThePast: () => _showLogGameConfirmationSnackbar(scaffoldMessengerState),
      orElse: () {},
    );
  }

  void _showLogGameFailureSnackbar(ScaffoldMessengerState scaffoldMessengerState) {
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        margin: Dimensions.snackbarMargin,
        behavior: SnackBarBehavior.floating,
        content: const Text(AppText.logGameFailureSnackbarText),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: AppText.ok,
          onPressed: () => scaffoldMessengerState.hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void _showLogGameConfirmationSnackbar(ScaffoldMessengerState scaffoldMessengerState) {
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        margin: Dimensions.snackbarMargin,
        behavior: SnackBarBehavior.floating,
        content: const Text(AppText.logGameSuccessConfirmationSnackbarText),
        action: SnackBarAction(
          label: AppText.ok,
          onPressed: () => scaffoldMessengerState.hideCurrentSnackBar(),
        ),
      ),
    );
  }
}

class _SubmitSection extends StatelessWidget {
  const _SubmitSection({
    required this.players,
    required this.onLogPlaythrough,
  });

  final PlaythroughsLogGamePlayers players;
  final VoidCallback onLogPlaythrough;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            const Spacer(),
            ElevatedIconButton(
              title: AppText.playthroughsLogGameSubmitButtonText,
              icon: const DefaultIcon(Icons.done),
              onPressed: () => onLogPlaythrough(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({
    required this.playthroughTimeline,
    required this.onPlaythroughTimelineChanged,
  });

  final PlaythroughTimeline playthroughTimeline;
  final void Function(PlaythroughTimeline) onPlaythroughTimelineChanged;

  @override
  Widget build(BuildContext context) => MultiSliver(
        children: [
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.title(
              primaryTitle: AppText.playthroughsLogTimelineTitle,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.standardSpacing),
              child: Row(
                children: [
                  const Text(
                    AppText.playthroughsLogGameplayTimelineTitle,
                    style: AppTheme.defaultTextFieldStyle,
                  ),
                  const Spacer(),
                  BgcSegmentedButtonsContainer(
                    // MK An arbitrary number to have the text on segmented buttons fit
                    width: 160,
                    height: Dimensions.defaultSegmentedButtonsContainerHeight,
                    child: Row(
                      children: [
                        _PlaythroughTimelineSegmentedButton.chronology(
                          isSelected: playthroughTimeline == const PlaythroughTimeline.now(),
                          playthroughTimeline: const PlaythroughTimeline.now(),
                          onSelected: (playthroughTimeline) =>
                              onPlaythroughTimelineChanged(playthroughTimeline),
                        ),
                        _PlaythroughTimelineSegmentedButton.chronology(
                          isSelected: playthroughTimeline == const PlaythroughTimeline.inThePast(),
                          playthroughTimeline: const PlaythroughTimeline.inThePast(),
                          onSelected: (playthroughTimeline) =>
                              onPlaythroughTimelineChanged(playthroughTimeline),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class _DateAndDurationSection extends StatelessWidget {
  const _DateAndDurationSection({
    required this.playthroughDate,
    required this.playthroughDuration,
    required this.onPlaythroughTimeChanged,
    required this.onPlaythroughDurationChanged,
  });

  final DateTime playthroughDate;
  final Duration playthroughDuration;
  final Function(DateTime) onPlaythroughTimeChanged;
  final Function(Duration) onPlaythroughDurationChanged;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPersistentHeader(
          delegate: BgcSliverTitleHeaderDelegate.titles(
            primaryTitle: AppText.playthroughsLogDateSectionTitle,
            secondaryTitle: AppText.playthroughsLogDurationSectionTitle,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Row(
              children: [
                _SelectPlaythroughDate(
                  playthroughDate: playthroughDate,
                  onPlaythroughTimeChanged: (playthroughDate) =>
                      onPlaythroughTimeChanged(playthroughDate),
                ),
                const Spacer(),
                _SetPlaythroughDuration(
                  playthroughDuration: playthroughDuration,
                  onDurationChanged: (playthroughDuration) =>
                      onPlaythroughDurationChanged(playthroughDuration),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SetPlaythroughDuration extends StatelessWidget {
  const _SetPlaythroughDuration({
    required this.playthroughDuration,
    required this.onDurationChanged,
  });

  final Duration playthroughDuration;
  final void Function(Duration) onDurationChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          NumberPicker(
            value: playthroughDuration.inHours,
            minValue: 0,
            maxValue: 99,
            onChanged: (num value) => _updateDurationHours(value),
            itemWidth: 46,
            selectedTextStyle: const TextStyle(
              color: AppColors.accentColor,
              fontSize: Dimensions.doubleExtraLargeFontSize,
            ),
          ),
          Text('h', style: AppTheme.theme.textTheme.bodyMedium),
          const SizedBox(width: Dimensions.halfStandardSpacing),
          NumberPicker(
            value: math.min(
              Duration.minutesPerHour - 1,
              playthroughDuration.inMinutes % Duration.minutesPerHour,
            ),
            infiniteLoop: true,
            minValue: 0,
            maxValue: Duration.minutesPerHour - 1,
            onChanged: (num value) => _updateDurationMinutes(value),
            itemWidth: 46,
            selectedTextStyle: const TextStyle(
              color: AppColors.accentColor,
              fontSize: Dimensions.doubleExtraLargeFontSize,
            ),
          ),
          Text('min ', style: AppTheme.theme.textTheme.bodyMedium),
        ],
      );

  void _updateDurationMinutes(num value) =>
      onDurationChanged(Duration(hours: playthroughDuration.inHours, minutes: value.toInt()));

  void _updateDurationHours(num value) => onDurationChanged(
        Duration(
          hours: value.toInt(),
          minutes: playthroughDuration.inMinutes % Duration.minutesPerHour,
        ),
      );
}

class _CooperativeResultSection extends StatelessWidget {
  const _CooperativeResultSection({
    required this.cooperativeGameResult,
    required this.onCooperativeGameResultChanged,
  });

  final CooperativeGameResult? cooperativeGameResult;
  final void Function(CooperativeGameResult) onCooperativeGameResultChanged;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPersistentHeader(
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.playthroughsLogCooperativeResultSectionTitle,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Text(
                  AppText.editPlaythroughNoScoreResultText,
                  style: AppTheme.defaultTextFieldStyle,
                ),
                const Spacer(),
                CooperativeGameResultSegmentedButton(
                  cooperativeGameResult: cooperativeGameResult,
                  onCooperativeGameResultChanged: (cooperativeGameResult) =>
                      onCooperativeGameResultChanged(cooperativeGameResult),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayersSection extends StatelessWidget {
  const _PlayersSection({
    required this.playthroughTimeline,
    required this.gameFamily,
    required this.players,
    required this.onCreatePlayer,
    required this.onSelectPlayers,
    required this.onPlayerScoreUpdated,
  });

  final PlaythroughTimeline playthroughTimeline;
  final GameFamily gameFamily;
  final PlaythroughsLogGamePlayers players;
  final VoidCallback onCreatePlayer;
  final VoidCallback onSelectPlayers;
  final void Function(PlayerScore, int) onPlayerScoreUpdated;

  @override
  Widget build(BuildContext context) => MultiSliver(
        children: [
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.action(
              primaryTitle: AppText.playthroughsLogPlayersSectionTitle,
              action: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => onCreatePlayer(),
              ),
            ),
          ),
          players.when(
            loading: () => const SliverFillRemaining(child: LoadingIndicator()),
            noPlayers: () => const SliverFillRemaining(child: _NoPlayers()),
            noPlayersSelected: () => SliverToBoxAdapter(
              child: _NoPlayersSelected(
                playthroughTimeline: playthroughTimeline,
                onSelectPlayers: onSelectPlayers,
              ),
            ),
            playersSelected: (selectedPlayers, selectedPlayerScores) {
              return _SelectedPlayers(
                selectedPlayers: selectedPlayers,
                selectedPlayerScores: selectedPlayerScores,
                playthroughTimeline: playthroughTimeline,
                onSelectPlayers: onSelectPlayers,
                onPlayerScoreUpdated: onPlayerScoreUpdated,
                gameFamily: gameFamily,
              );
            },
          ),
        ],
      );
}

class _SelectedPlayers extends StatelessWidget {
  const _SelectedPlayers({
    required this.selectedPlayers,
    required this.selectedPlayerScores,
    required this.playthroughTimeline,
    required this.gameFamily,
    required this.onSelectPlayers,
    required this.onPlayerScoreUpdated,
  });

  final List<Player> selectedPlayers;
  final Map<String, PlayerScore> selectedPlayerScores;
  final PlaythroughTimeline playthroughTimeline;
  final GameFamily gameFamily;
  final VoidCallback onSelectPlayers;
  final void Function(PlayerScore playerScore, int score) onPlayerScoreUpdated;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        _SelectPlayersButton(
          text: AppText.playthroughsLogPlayersChangePlayerSelectionButtonText,
          playthroughTimeline: playthroughTimeline,
          onSelectPlayers: () => onSelectPlayers(),
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: Dimensions.standardSpacing,
            left: Dimensions.standardSpacing,
          ),
        ),
        playthroughTimeline.when(
          inThePast: () => _SelectedPlayersList(
            selectedPlayers: selectedPlayers,
            selectedPlayerScores: selectedPlayerScores,
            onPlayerScoreUpdated: (playerScore, score) => onPlayerScoreUpdated(playerScore, score),
            gameFamily: gameFamily,
          ),
          now: () => _SelectedPlayersGrid(selectedPlayers: selectedPlayers),
        ),
      ],
    );
  }
}

class _NoPlayersSelected extends StatelessWidget {
  const _NoPlayersSelected({
    required this.playthroughTimeline,
    required this.onSelectPlayers,
  });

  final PlaythroughTimeline playthroughTimeline;
  final VoidCallback onSelectPlayers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.standardSpacing),
        _SelectPlayersButton(
          text: playthroughTimeline.when(
            now: () => AppText.playthroughsLogPlayersPlayingNowButtonText,
            inThePast: () => AppText.playthroughsLogPlayersPlayedInThePastButtonText,
          ),
          playthroughTimeline: playthroughTimeline,
          onSelectPlayers: () => onSelectPlayers(),
        ),
      ],
    );
  }
}

class _SelectPlayersButton extends StatelessWidget {
  const _SelectPlayersButton({
    required this.text,
    required this.playthroughTimeline,
    required this.onSelectPlayers,
  });

  final String text;
  final PlaythroughTimeline playthroughTimeline;
  final VoidCallback onSelectPlayers;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelectPlayers(),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Row(
            children: [
              Text(
                text,
                style: AppTheme.defaultTextFieldStyle,
              ),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaythroughTimelineSegmentedButton extends BgcSegmentedButton<PlaythroughTimeline> {
  _PlaythroughTimelineSegmentedButton.chronology({
    required bool isSelected,
    required PlaythroughTimeline playthroughTimeline,
    required Function(PlaythroughTimeline) onSelected,
  }) : super(
          value: playthroughTimeline,
          isSelected: isSelected,
          onTapped: (_) => onSelected(playthroughTimeline),
          child: Center(
            child: Text(
              playthroughTimeline.toFormattedText(),
              style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                color: isSelected ? AppColors.defaultTextColor : AppColors.secondaryTextColor,
              ),
            ),
          ),
        );
}

class _SelectPlaythroughDate extends StatefulWidget {
  const _SelectPlaythroughDate({
    required this.playthroughDate,
    required this.onPlaythroughTimeChanged,
    Key? key,
  }) : super(key: key);

  final DateTime playthroughDate;
  final Function(DateTime) onPlaythroughTimeChanged;

  @override
  _SelectPlaythroughDateState createState() => _SelectPlaythroughDateState();
}

class _SelectPlaythroughDateState extends State<_SelectPlaythroughDate> {
  DateTime? _playthroughDate;

  @override
  void initState() {
    _playthroughDate = widget.playthroughDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          child: InkWell(
            onTap: () => _pickPlaythroughDate(context, _playthroughDate!),
            child: CalendarCard(_playthroughDate),
          ),
        ),
        const SizedBox(
          width: Dimensions.standardSpacing,
        ),
        ItemPropertyValue(_playthroughDate.toDaysAgo()),
      ],
    );
  }

  Future<void> _pickPlaythroughDate(BuildContext context, DateTime playthroughDate) async {
    final DateTime? newPlaythroughDate = await showDatePicker(
      context: context,
      initialDate: playthroughDate,
      firstDate: playthroughDate.add(const Duration(days: -Constants.daysInTenYears)),
      lastDate: DateTime.now(),
      currentDate: playthroughDate,
      helpText: 'Pick a playthrough date',
      builder: (_, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.accentColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (newPlaythroughDate == null) {
      return;
    }

    setState(() {
      _playthroughDate = newPlaythroughDate;
      widget.onPlaythroughTimeChanged(_playthroughDate!);
    });
  }
}

class _SelectedPlayersList extends StatelessWidget with EnterScoreDialogMixin {
  const _SelectedPlayersList({
    Key? key,
    required this.selectedPlayers,
    required this.selectedPlayerScores,
    required this.onPlayerScoreUpdated,
    required this.gameFamily,
  }) : super(key: key);

  final List<Player> selectedPlayers;
  final Map<String, PlayerScore> selectedPlayerScores;
  final void Function(PlayerScore, int) onPlayerScoreUpdated;
  final GameFamily gameFamily;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            final int itemIndex = index ~/ 2;
            final player = selectedPlayers[itemIndex];
            if (index.isEven) {
              final playerScore = selectedPlayerScores[player.id]!;
              return _PlayerScore(
                playerScore: playerScore,
                gameFamily: gameFamily,
                onTap: () async {
                  final enterScoreViewModel = EnterScoreViewModel(playerScore);
                  await showEnterScoreDialog(context, enterScoreViewModel);
                  onPlayerScoreUpdated(playerScore, enterScoreViewModel.score);
                },
              );
            }

            return const SizedBox(height: Dimensions.standardSpacing);
          },
          childCount: max(0, selectedPlayers.length * 2 - 1),
        ),
      ),
    );
  }
}

class _SelectedPlayersGrid extends StatelessWidget {
  const _SelectedPlayersGrid({
    Key? key,
    required this.selectedPlayers,
  }) : super(key: key);

  static const int _numberOfPlayerColumns = 3;

  final List<Player> selectedPlayers;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      sliver: SliverGrid.count(
        crossAxisCount: _numberOfPlayerColumns,
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        children: [
          for (final player in selectedPlayers)
            Stack(
              children: <Widget>[
                PlayerAvatar(
                  player: player,
                  avatarImageSize: Dimensions.smallPlayerAvatarSize,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _NoPlayers extends StatelessWidget {
  const _NoPlayers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EmptyPageInformationPanel(
        title: AppText.playthroughsLogGamePageCreatePlayerTitle,
        subtitle: AppText.playthroughsLogGamePageCreatePlayerSubtitle,
        icon: Icon(
          Icons.people,
          size: Dimensions.emptyPageTitleIconSize,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    Key? key,
    required this.playerScore,
    required this.gameFamily,
    required this.onTap,
  }) : super(key: key);

  final PlayerScore playerScore;
  final GameFamily gameFamily;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: Dimensions.smallPlayerAvatarSize.height,
            width: Dimensions.smallPlayerAvatarSize.width,
            child: PlayerAvatar(
              player: playerScore.player,
              avatarImageSize: Dimensions.smallPlayerAvatarSize,
            ),
          ),
          const SizedBox(width: Dimensions.doubleStandardSpacing),
          if (gameFamily == GameFamily.LowestScore || gameFamily == GameFamily.HighestScore)
            _PlayerScoreScoreGameFamily(playerScore: playerScore),
          if (gameFamily == GameFamily.Cooperative)
            _PlayerScoreCooperativeGameFamily(
              noScoreGameResult: playerScore.score.noScoreGameResult,
            ),
        ],
      ),
    );
  }
}

class _PlayerScoreScoreGameFamily extends StatelessWidget {
  const _PlayerScoreScoreGameFamily({
    required this.playerScore,
  });

  final PlayerScore playerScore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          playerScore.score.value ?? '-',
          style: AppStyles.playerScoreTextStyle,
        ),
        const SizedBox(height: Dimensions.halfStandardSpacing),
        Text('points', style: AppTheme.theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _PlayerScoreCooperativeGameFamily extends StatelessWidget {
  const _PlayerScoreCooperativeGameFamily({required this.noScoreGameResult});

  final NoScoreGameResult? noScoreGameResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          noScoreGameResult.toPlayerAvatarDisplayText(),
          style: AppStyles.playerScoreTextStyle,
        ),
      ],
    );
  }
}
