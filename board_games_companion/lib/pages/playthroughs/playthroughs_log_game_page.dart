import 'dart:math' as math;
import 'dart:math';

import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/models/hive/no_score_game_result.dart';
import 'package:board_games_companion/models/navigation/edit_playthrough_page_arguments.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_page.dart';
import 'package:board_games_companion/pages/playthroughs/playthrough_timeline.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_log_game_players.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/common/segmented_buttons/bgc_segmented_button.dart';
import 'package:board_games_companion/widgets/common/segmented_buttons/bgc_segmented_buttons_container.dart';
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
import '../../extensions/date_time_extensions.dart';
import '../../injectable.dart';
import '../../mixins/enter_score_dialog.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_players_selection_result.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/empty_page_information_panel.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/cooperative_game_result_segmented_button.dart';
import '../enter_score/enter_score_view_model.dart';
import '../player/player_page.dart';
import 'playthrough_players_selection_page.dart';
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
                  builder: (_) {
                    return _PlayersSection(
                      playthroughTimeline: viewModel.playthroughTimeline,
                      gameFamily: viewModel.gameFamily,
                      players: viewModel.playersState,
                      onCreatePlayer: () => _handleCreatePlayer(),
                      onSelectPlayers: () => _handleSelectPlayers(),
                      onPlayerScoreUpdated: (playerScore, score) =>
                          _handlePlayerScoreUpdate(playerScore, score),
                    );
                  },
                ),
                Observer(builder: (_) {
                  return _SubmitSection(
                    players: viewModel.playersState,
                    onLogPlaythrough: () => _handleLoggingPlaythrough(),
                  );
                }),
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

// class _LogPlaythroughStepper extends StatefulWidget {
//   const _LogPlaythroughStepper({
//     required this.viewModel,
//     Key? key,
//   }) : super(key: key);

//   final PlaythroughsLogGameViewModel viewModel;

//   @override
//   _LogPlaythroughStepperState createState() => _LogPlaythroughStepperState();
// }

// class _LogPlaythroughStepperState extends State<_LogPlaythroughStepper> {
//   int playingOrPlayedStep = 0;
//   int selectDateStep = 1;
//   int selectPlayersStep = 2;
//   int playersScoreStep = 3;

//   bool selectPlayersStepError = false;
//   bool setCooperativeGameResultStepError = false;

//   int get lastStep => widget.viewModel.playthroughStartTime == PlaythroughStartTime.now
//       ? selectPlayersStep
//       : playersScoreStep;

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverPersistentHeader(
//           delegate: BgcSliverHeaderDelegate(
//             primaryTitle: AppText.playthroughsLogGamePageHeader,
//           ),
//         ),
//         SliverFillRemaining(
//           child: Theme(
//             data: AppTheme.theme.copyWith(
//               colorScheme: AppTheme.theme.colorScheme.copyWith(primary: AppColors.accentColor),
//             ),
//             child: Stepper(
//               currentStep: widget.viewModel.logGameStep,
//               steps: [
//                 Step(
//                   title: const Text(AppText.playthroughsLogGamePlayingPlayedHeaderTitle),
//                   state: widget.viewModel.logGameStep > playingOrPlayedStep
//                       ? StepState.complete
//                       : StepState.indexed,
//                   content: _PlayingOrPlayedStep(
//                       viewModel: widget.viewModel,
//                       onSelectionChanged: (PlaythroughStartTime playthroughStartTime) =>
//                           setState(() {})),
//                 ),
//                 Step(
//                   title: const Text('Select date'),
//                   isActive: widget.viewModel.playthroughStartTime == PlaythroughStartTime.inThePast,
//                   state: widget.viewModel.playthroughStartTime == PlaythroughStartTime.now
//                       ? StepState.disabled
//                       : widget.viewModel.logGameStep > selectDateStep
//                           ? StepState.complete
//                           : StepState.indexed,
//                   content: _SelectDateStep(
//                     playthroughDate: widget.viewModel.playthroughDate,
//                     onPlaythroughTimeChanged: (DateTime playthoughDate) {
//                       widget.viewModel.playthroughDate = playthoughDate;
//                     },
//                   ),
//                 ),
//                 Step(
//                   title: const Text('Select players'),
//                   state: selectPlayersStepError
//                       ? StepState.error
//                       : widget.viewModel.logGameStep > selectPlayersStep
//                           ? StepState.complete
//                           : StepState.indexed,
//                   content: Observer(
//                     builder: (_) {
//                       return _SelectPlayersStep(
//                         playthroughPlayers: widget.viewModel.playthroughPlayers.toList(),
//                         onPlayerSelectionChanged: (bool? isSelected, Player player) =>
//                             _togglePlayerSelection(isSelected, player),
//                         onCreatePlayer: () async => _handleCreatePlayer(),
//                       );
//                     },
//                   ),
//                 ),
//                 // TODO Fix stepper?
//                 if (widget.viewModel.gameClassification == GameClassification.Score)
//                   Step(
//                     title: const Text(AppText.playthroughsLogGamePagePlayerScoresStepTitle),
//                     isActive:
//                         widget.viewModel.playthroughStartTime == PlaythroughStartTime.inThePast,
//                     state: widget.viewModel.playthroughStartTime == PlaythroughStartTime.now
//                         ? StepState.disabled
//                         : widget.viewModel.logGameStep > playersScoreStep
//                             ? StepState.complete
//                             : StepState.indexed,
//                     content: _PlayerScoresStep(viewModel: widget.viewModel),
//                   ),
//                 if (widget.viewModel.gameClassification == GameClassification.NoScore)
//                   Step(
//                     title: const Text(AppText.playthroughsLogGamePageNoScoreResultStepTitle),
//                     isActive:
//                         widget.viewModel.playthroughStartTime == PlaythroughStartTime.inThePast,
//                     state: widget.viewModel.playthroughStartTime == PlaythroughStartTime.now
//                         ? StepState.disabled
//                         : widget.viewModel.logGameStep > playersScoreStep
//                             ? StepState.complete
//                             : StepState.indexed,
//                     content: Observer(
//                       builder: (_) {
//                         return _CooperativeGameResultStep(
//                           cooperativeGameResult: widget.viewModel.cooperativeGameResult,
//                           onResultChanged: (cooperativeGameResult) =>
//                               widget.viewModel.updateCooperativeGameResult(cooperativeGameResult),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//               onStepCancel: () => _stepCancel(),
//               onStepContinue: () => _stepContinue(context),
//               onStepTapped: (int index) => _stepTapped(context, index),
//               controlsBuilder: (BuildContext _, ControlsDetails details) =>
//                   _stepActionButtons(details.onStepContinue, details.onStepCancel),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _stepActionButtons(VoidCallback? onStepContinue, VoidCallback? onStepCancel) {
//     Widget? step;
//     if (widget.viewModel.logGameStep == playingOrPlayedStep) {
//       step = Align(
//         alignment: Alignment.centerLeft,
//         child: ElevatedButton(
//           onPressed: () => onStepContinue!(),
//           child: const Text('Next'),
//         ),
//       );
//     }

//     if (widget.viewModel.logGameStep == selectPlayersStep ||
//         widget.viewModel.logGameStep == selectDateStep ||
//         widget.viewModel.logGameStep == playersScoreStep) {
//       step = Row(
//         children: <Widget>[
//           ElevatedButton(
//             onPressed: () => onStepContinue!(),
//             child:
//                 widget.viewModel.logGameStep == lastStep ? const Text('Done') : const Text('Next'),
//           ),
//           const SizedBox(width: Dimensions.doubleStandardSpacing),
//           TextButton(
//             onPressed: () => onStepCancel!(),
//             child: const Text(AppText.goBack),
//           ),
//         ],
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.only(top: Dimensions.doubleStandardSpacing),
//       child: step,
//     );
//   }

//   void _stepTapped(BuildContext context, int step) {
//     if (step > selectPlayersStep && !widget.viewModel.anyPlayerSelected) {
//       _showSelectPlayerError(context);
//       setState(() {
//         widget.viewModel.logGameStep = selectPlayersStep;
//       });
//     } else {
//       setState(() {
//         widget.viewModel.logGameStep = step;
//       });
//     }
//   }

//   Future<void> _stepContinue(BuildContext context) async {
//     if (widget.viewModel.logGameStep == selectPlayersStep && !widget.viewModel.anyPlayerSelected) {
//       _showSelectPlayerError(context);
//       return;
//     }

//     if (widget.viewModel.gameClassification == GameClassification.NoScore &&
//         widget.viewModel.logGameStep == playersScoreStep &&
//         widget.viewModel.cooperativeGameResult == null) {
//       _showSelectPlayerError(context);
//       return;
//     }

//     if (widget.viewModel.logGameStep >= selectPlayersStep && selectPlayersStepError) {
//       setState(() {
//         selectPlayersStepError = false;
//       });
//     }

//     if (widget.viewModel.logGameStep < lastStep) {
//       int stepIncrement = 1;
//       if (widget.viewModel.playthroughStartTime == PlaythroughStartTime.now &&
//           widget.viewModel.logGameStep == playingOrPlayedStep) {
//         stepIncrement = 2;
//       }

//       setState(() {
//         widget.viewModel.logGameStep += stepIncrement;
//       });
//     } else {
//       final PlaythroughDetails? newPlaythrough =
//           await widget.viewModel.createPlaythrough(widget.viewModel.boardGameId);
//       if (!mounted) {
//         return;
//       }

//       if (newPlaythrough == null) {
//         _showFailureSnackbar(context);
//       } else {
//         _showConfirmationSnackbar(context);
//       }
//       setState(() {});
//     }
//   }

//   void _stepCancel() {
//     if (widget.viewModel.logGameStep > 0) {
//       int stepIncrement = 1;
//       if (widget.viewModel.playthroughStartTime == PlaythroughStartTime.now &&
//           widget.viewModel.logGameStep == selectPlayersStep) {
//         stepIncrement = 2;
//       }
//       setState(() {
//         widget.viewModel.logGameStep -= stepIncrement;
//       });
//     }
//   }

//   void _showSelectPlayerError(BuildContext context) {
//     setState(() {
//       selectPlayersStepError = true;
//     });

//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         margin: Dimensions.snackbarMargin,
//         behavior: SnackBarBehavior.floating,
//         content: Text('You need to select at least one player'),
//       ),
//     );
//   }

//   void _showSelectCooperativeGameResultError(BuildContext context) {
//     setState(() {
//       selectPlayersStepError = true;
//     });

//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         margin: Dimensions.snackbarMargin,
//         behavior: SnackBarBehavior.floating,
//         content: Text('You need to select Please select Win or Loss result'),
//       ),
//     );
//   }

//   Future<void> _handleCreatePlayer() async {
//     await Navigator.pushNamed(
//       context,
//       PlayerPage.pageRoute,
//       arguments: const PlayerPageArguments(),
//     );
//     // MK Reload players after getting back from players page
//     widget.viewModel.loadPlaythroughPlayers();
//   }

//   void _togglePlayerSelection(bool? isSelected, Player player) {
//     if (isSelected == null) {
//       return;
//     }

//     if (isSelected) {
//       widget.viewModel.selectPlayer(player);
//     } else {
//       widget.viewModel.deselectPlayer(player);
//     }
//   }

//   void _showConfirmationSnackbar(BuildContext context) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         margin: Dimensions.snackbarMargin,
//         behavior: SnackBarBehavior.floating,
//         content: Text(AppText.logGameSuccessConfirmationSnackbarText),
//       ),
//     );
//   }

//   void _showFailureSnackbar(BuildContext context) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         margin: Dimensions.snackbarMargin,
//         behavior: SnackBarBehavior.floating,
//         content: Text(AppText.logGameFailureConfirmationSnackbarText),
//       ),
//     );
//   }
// }

// class _PlayerScoresStep extends StatelessWidget with EnterScoreDialogMixin {
//   const _PlayerScoresStep({
//     required this.viewModel,
//     Key? key,
//   }) : super(key: key);

//   final PlaythroughsLogGameViewModel viewModel;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 3,
//       child: SingleChildScrollView(
//         child: Observer(
//           builder: (_) {
//             return Column(
//               children: [
//                 for (var playerScore in viewModel.playerScores.values) ...[
//                   _PlayerScore(
//                     playerScore: playerScore,
//                     onTap: (PlayerScore playerScore) async {
//                       final enterScoreViewModel = EnterScoreViewModel(playerScore);
//                       await showEnterScoreDialog(context, enterScoreViewModel);
//                       viewModel.updatePlayerScore(playerScore, enterScoreViewModel.score);
//                       return enterScoreViewModel.score.toString();
//                     },
//                   ),
//                   const SizedBox(height: Dimensions.standardSpacing),
//                 ]
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class _PlayingOrPlayedStep extends StatefulWidget {
//   const _PlayingOrPlayedStep({
//     required this.viewModel,
//     required this.onSelectionChanged,
//     Key? key,
//   }) : super(key: key);

//   final PlaythroughsLogGameViewModel viewModel;
//   final Function(PlaythroughStartTime) onSelectionChanged;

//   @override
//   _PlayingOrPlayedStepState createState() => _PlayingOrPlayedStepState();
// }

// class _PlayingOrPlayedStepState extends State<_PlayingOrPlayedStep> {
//   late int hoursPlayed;
//   late int minutesPlyed;

//   @override
//   void initState() {
//     super.initState();

//     hoursPlayed = widget.viewModel.playthroughDuration.inHours;
//     minutesPlyed = widget.viewModel.playthroughDuration.inMinutes % Duration.minutesPerHour;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           InkWell(
//             onTap: () => _updatePlaythroughStartTimeSelection(PlaythroughStartTime.now),
//             child: Row(
//               children: [
//                 Radio<PlaythroughStartTime>(
//                   value: PlaythroughStartTime.now,
//                   groupValue: widget.viewModel.playthroughStartTime,
//                   activeColor: AppColors.accentColor,
//                   onChanged: (PlaythroughStartTime? value) {
//                     if (value != null) {
//                       _updatePlaythroughStartTimeSelection(value);
//                     }
//                   },
//                 ),
//                 Text(
//                   AppText.playthroughsLogGamePlayingNowOption,
//                   style: AppTheme.theme.textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () => _updatePlaythroughStartTimeSelection(PlaythroughStartTime.inThePast),
//             child: Row(
//               children: [
//                 Radio<PlaythroughStartTime>(
//                   value: PlaythroughStartTime.inThePast,
//                   groupValue: widget.viewModel.playthroughStartTime,
//                   activeColor: AppColors.accentColor,
//                   onChanged: (PlaythroughStartTime? value) {
//                     if (value == null) {
//                       return;
//                     }

//                     _updatePlaythroughStartTimeSelection(value);
//                   },
//                 ),
//                 Text(
//                   AppText.playthroughsLogGamePlayedOption,
//                   style: AppTheme.theme.textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//           ),
//           if (widget.viewModel.playthroughStartTime == PlaythroughStartTime.inThePast)
//             Row(
//               children: <Widget>[
//                 Text(
//                   'The game took: ',
//                   style: AppTheme.theme.textTheme.bodyLarge,
//                 ),
//                 NumberPicker(
//                   value: hoursPlayed,
//                   minValue: 0,
//                   maxValue: 99,
//                   onChanged: (num value) => _updateDurationHours(value),
//                   itemWidth: 46,
//                   selectedTextStyle: const TextStyle(
//                     color: AppColors.accentColor,
//                     fontSize: Dimensions.doubleExtraLargeFontSize,
//                   ),
//                 ),
//                 Text('h', style: AppTheme.theme.textTheme.bodyMedium),
//                 const SizedBox(width: Dimensions.halfStandardSpacing),
//                 NumberPicker(
//                   value: math.min(Duration.minutesPerHour - 1, minutesPlyed),
//                   infiniteLoop: true,
//                   minValue: 0,
//                   maxValue: Duration.minutesPerHour - 1,
//                   onChanged: (num value) => _updateDurationMinutes(value),
//                   itemWidth: 46,
//                   selectedTextStyle: const TextStyle(
//                     color: AppColors.accentColor,
//                     fontSize: Dimensions.doubleExtraLargeFontSize,
//                   ),
//                 ),
//                 Text('min ', style: AppTheme.theme.textTheme.bodyMedium),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   void _updatePlaythroughStartTimeSelection(PlaythroughStartTime playthroughStartTime) {
//     setState(() {
//       widget.viewModel.playthroughStartTime = playthroughStartTime;
//     });
//     widget.onSelectionChanged(playthroughStartTime);
//   }

//   void _updateDurationHours(num value) {
//     setState(() {
//       hoursPlayed = value.toInt();
//       widget.viewModel.playthroughDuration = Duration(hours: hoursPlayed, minutes: minutesPlyed);
//     });
//   }

//   void _updateDurationMinutes(num value) {
//     setState(() {
//       minutesPlyed = value.toInt();
//       widget.viewModel.playthroughDuration = Duration(hours: hoursPlayed, minutes: minutesPlyed);
//     });
//   }
// }

// class _SelectPlayersStep extends StatelessWidget {
//   const _SelectPlayersStep({
//     Key? key,
//     required this.playthroughPlayers,
//     required this.onPlayerSelectionChanged,
//     required this.onCreatePlayer,
//   }) : super(key: key);

//   final List<Player>? playthroughPlayers;
//   final void Function(bool?, Player) onPlayerSelectionChanged;
//   final VoidCallback onCreatePlayer;

//   @override
//   Widget build(BuildContext context) {
//     if (playthroughPlayers?.isEmpty ?? true) {
//       return _NoPlayers(onCreatePlayer: () => onCreatePlayer());
//     }

//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 3,
//       child: _Players(
//         playthroughPlayers: playthroughPlayers,
//         onPlayerSelectionChanged: (bool? isSelected, Player player) =>
//             onPlayerSelectionChanged(isSelected, player),
//       ),
//     );
//   }
// }

// class _CooperativeGameResultStep extends StatelessWidget {
//   const _CooperativeGameResultStep({
//     required this.cooperativeGameResult,
//     required this.onResultChanged,
//     Key? key,
//   }) : super(key: key);

//   final CooperativeGameResult? cooperativeGameResult;
//   final void Function(CooperativeGameResult) onResultChanged;

//   @override
//   Widget build(BuildContext context) => Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: Dimensions.defaultSegmentedButtonsContainerHeight,
//             child: CooperativeGameResultSegmentedButton(
//               cooperativeGameResult: cooperativeGameResult,
//               onCooperativeGameResultChanged: (cooperativeGameResult) =>
//                   onResultChanged(cooperativeGameResult),
//             ),
//           ),
//         ],
//       );
// }

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
