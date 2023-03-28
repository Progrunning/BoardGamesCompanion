import 'package:board_games_companion/pages/playthroughs/playthrough_chronology.dart';
import 'package:board_games_companion/widgets/common/segmented_buttons/bgc_segmented_button.dart';
import 'package:board_games_companion/widgets/common/segmented_buttons/bgc_segmented_buttons_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../injectable.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_player.dart';
import '../../widgets/common/bgc_checkbox.dart';
import '../../widgets/common/empty_page_information_panel.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../../widgets/player/player_avatar.dart';
import '../player/player_page.dart';
import 'playthroughs_log_game_view_model.dart';

class PlaythroughsLogGamePage extends StatefulWidget {
  const PlaythroughsLogGamePage({Key? key}) : super(key: key);

  @override
  PlaythroughsLogGamePageState createState() => PlaythroughsLogGamePageState();
}

class PlaythroughsLogGamePageState extends State<PlaythroughsLogGamePage> {
  late PlaythroughsLogGameViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt<PlaythroughsLogGameViewModel>();
    viewModel.loadPlaythroughPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (viewModel.futureLoadPlaythroughPlayers?.status ?? FutureStatus.pending) {
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
                    return _PlayersSection(
                      hasAnyPlayers: viewModel.hasAnyPlayers,
                      playthroughPlayers: viewModel.playthroughPlayers,
                      onPlayerSelectionChanged: (isSelected, playthroughPlayer) =>
                          _togglePlayerSelection(isSelected, playthroughPlayer),
                      onCreatePlayer: () => _handleCreatePlayer(),
                    );
                  },
                ),
              ],
            );
          // return _LogPlaythroughStepper(viewModel: viewModel);
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
    viewModel.loadPlaythroughPlayers();
  }

  void _togglePlayerSelection(bool? isSelected, PlaythroughPlayer player) {
    if (isSelected == null) {
      return;
    }

    if (isSelected) {
      viewModel.selectPlayer(player);
    } else {
      viewModel.deselectPlayer(player);
    }
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
                  const Text(AppText.playthroughsLogGameplayTimelineTitle),
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

class _PlayersSection extends StatelessWidget {
  const _PlayersSection({
    required this.hasAnyPlayers,
    required this.playthroughPlayers,
    required this.onPlayerSelectionChanged,
    required this.onCreatePlayer,
  });

  final bool hasAnyPlayers;
  final List<PlaythroughPlayer> playthroughPlayers;
  final void Function(bool?, PlaythroughPlayer) onPlayerSelectionChanged;
  final VoidCallback onCreatePlayer;

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
          if (hasAnyPlayers)
            _Players(
              playthroughPlayers: playthroughPlayers,
              onPlayerSelectionChanged: (bool? isSelected, PlaythroughPlayer player) =>
                  onPlayerSelectionChanged(isSelected, player),
            ),
          if (!hasAnyPlayers)
            const SliverFillRemaining(
              child: _NoPlayers(),
            ),
        ],
      );
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
//                         onPlayerSelectionChanged: (bool? isSelected, PlaythroughPlayer player) =>
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

//   void _togglePlayerSelection(bool? isSelected, PlaythroughPlayer player) {
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

//   final List<PlaythroughPlayer>? playthroughPlayers;
//   final void Function(bool?, PlaythroughPlayer) onPlayerSelectionChanged;
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
//         onPlayerSelectionChanged: (bool? isSelected, PlaythroughPlayer player) =>
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

// class _SelectDateStep extends StatefulWidget {
//   const _SelectDateStep({
//     required this.playthroughDate,
//     required this.onPlaythroughTimeChanged,
//     Key? key,
//   }) : super(key: key);

//   final DateTime playthroughDate;
//   final Function(DateTime) onPlaythroughTimeChanged;

//   @override
//   _SelectDateStepState createState() => _SelectDateStepState();
// }

// class _SelectDateStepState extends State<_SelectDateStep> {
//   DateTime? _playthroughDate;

//   @override
//   void initState() {
//     _playthroughDate = widget.playthroughDate;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Material(
//           child: InkWell(
//             onTap: () => _pickPlaythroughDate(context, _playthroughDate!),
//             child: CalendarCard(_playthroughDate),
//           ),
//         ),
//         const SizedBox(
//           width: Dimensions.standardSpacing,
//         ),
//         ItemPropertyValue(
//           _playthroughDate.toDaysAgo(),
//         ),
//       ],
//     );
//   }

//   Future<void> _pickPlaythroughDate(BuildContext context, DateTime playthroughDate) async {
//     final DateTime? newPlaythroughDate = await showDatePicker(
//       context: context,
//       initialDate: playthroughDate,
//       firstDate: playthroughDate.add(const Duration(days: -Constants.daysInTenYears)),
//       lastDate: DateTime.now(),
//       currentDate: playthroughDate,
//       helpText: 'Pick a playthrough date',
//       builder: (_, Widget? child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: Theme.of(context).colorScheme.copyWith(
//                   primary: AppColors.accentColor,
//                 ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (newPlaythroughDate == null) {
//       return;
//     }

//     setState(() {
//       _playthroughDate = newPlaythroughDate;
//       widget.onPlaythroughTimeChanged(_playthroughDate!);
//     });
//   }
// }

class _Players extends StatelessWidget {
  const _Players({
    Key? key,
    required this.playthroughPlayers,
    required this.onPlayerSelectionChanged,
  }) : super(key: key);

  int get _numberOfPlayerColumns => 4;
  final List<PlaythroughPlayer>? playthroughPlayers;
  final Function(bool?, PlaythroughPlayer) onPlayerSelectionChanged;

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
          for (var playthroughPlayer in playthroughPlayers!)
            Stack(
              children: <Widget>[
                PlayerAvatar(
                  player: playthroughPlayer.player,
                  avatarImageSize: Size(playerAvatarSize, playerAvatarSize),
                  onTap: () =>
                      onPlayerSelectionChanged(!playthroughPlayer.isChecked, playthroughPlayer),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: BgcCheckbox(
                    isChecked: playthroughPlayer.isChecked,
                    onChanged: (isChecked) =>
                        onPlayerSelectionChanged(isChecked, playthroughPlayer),
                  ),
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

  // @override
  // Widget build(BuildContext context) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: <Widget>[
  //         Text(
  //           AppText.playthroughsLogGamePageCreatePlayerTitle,
  //           style: AppTheme.theme.textTheme.bodyLarge,
  //         ),
  //         const SizedBox(height: Dimensions.halfStandardSpacing),
  //         Align(
  //           alignment: Alignment.topRight,
  //           child: ElevatedIconButton(
  //             title: AppText.playthroughsLogGamePageCreatePlayerButtonText,
  //             icon: const DefaultIcon(Icons.add),
  //             onPressed: () => onCreatePlayer(),
  //           ),
  //         ),
  //       ],
  //     );
}

class _PlayerScore extends StatefulWidget {
  const _PlayerScore({
    Key? key,
    required this.playerScore,
    required this.onTap,
  }) : super(key: key);

  final PlayerScore playerScore;
  final Future<String?> Function(PlayerScore) onTap;

  @override
  State<_PlayerScore> createState() => _PlayerScoreState();
}

class _PlayerScoreState extends State<_PlayerScore> {
  late String? score;

  @override
  void initState() {
    super.initState();

    score = widget.playerScore.score.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final newScore = await widget.onTap(widget.playerScore);
        setState(() {
          score = newScore;
        });
      },
      child: Row(
        children: <Widget>[
          SizedBox(
            height: Dimensions.smallPlayerAvatarSize.height,
            width: Dimensions.smallPlayerAvatarSize.width,
            child: PlayerAvatar(
              player: widget.playerScore.player,
              avatarImageSize: Dimensions.smallPlayerAvatarSize,
            ),
          ),
          const SizedBox(width: Dimensions.doubleStandardSpacing),
          Column(
            children: <Widget>[
              Text(
                score ?? '-',
                style: AppStyles.playerScoreTextStyle,
              ),
              const SizedBox(height: Dimensions.halfStandardSpacing),
              Text('points', style: AppTheme.theme.textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
