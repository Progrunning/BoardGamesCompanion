import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../extensions/date_time_extensions.dart';
import '../../injectable.dart';
import '../../mixins/enter_score_dialog.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_details.dart';
import '../../models/playthroughs/playthrough_player.dart';
import '../../widgets/common/bgc_checkbox.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/slivers/bgc_sliver_header_delegate.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../enter_score/enter_score_view_model.dart';
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
            return _LogPlaythroughStepper(viewModel: viewModel);
        }
      },
    );
  }
}

class _LogPlaythroughStepper extends StatefulWidget {
  const _LogPlaythroughStepper({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PlaythroughsLogGameViewModel viewModel;

  @override
  _LogPlaythroughStepperState createState() => _LogPlaythroughStepperState();
}

class _LogPlaythroughStepperState extends State<_LogPlaythroughStepper> {
  int playingOrPlayedStep = 0;
  int selectDateStep = 1;
  int selectPlayersStep = 2;
  int playersScoreStep = 3;

  bool selectPlayersStepError = false;
  int completedSteps = 0;

  int get lastStep => widget.viewModel.playthroughStartTime == PlaythroughStartTime.now
      ? selectPlayersStep
      : playersScoreStep;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: BgcSliverHeaderDelegate(
            primaryTitle: AppText.playthroughsLogGamePageHeader,
          ),
        ),
        SliverFillRemaining(
          child: Theme(
            data: AppTheme.theme.copyWith(
              colorScheme: AppTheme.theme.colorScheme.copyWith(primary: AppColors.accentColor),
            ),
            child: Stepper(
              currentStep: widget.viewModel.logGameStep,
              steps: [
                Step(
                  title: const Text(AppText.playthroughsLogGamePlayingPlayedHeaderTitle),
                  state:
                      completedSteps > playingOrPlayedStep ? StepState.complete : StepState.indexed,
                  content: _PlayingOrPlayedStep(
                      viewModel: widget.viewModel,
                      onSelectionChanged: (PlaythroughStartTime playthroughStartTime) =>
                          setState(() {})),
                ),
                Step(
                  title: const Text('Select date'),
                  isActive: widget.viewModel.playthroughStartTime == PlaythroughStartTime.inThePast,
                  state: widget.viewModel.playthroughStartTime == PlaythroughStartTime.now
                      ? StepState.disabled
                      : completedSteps > selectDateStep
                          ? StepState.complete
                          : StepState.indexed,
                  content: _SelectDateStep(
                    playthroughDate: widget.viewModel.playthroughDate,
                    onPlaythroughTimeChanged: (DateTime playthoughDate) {
                      widget.viewModel.playthroughDate = playthoughDate;
                    },
                  ),
                ),
                Step(
                  title: const Text('Select players'),
                  state: selectPlayersStepError
                      ? StepState.error
                      : completedSteps > selectPlayersStep
                          ? StepState.complete
                          : StepState.indexed,
                  content: Observer(
                    builder: (_) {
                      return _SelectPlayersStep(
                        playthroughPlayers: widget.viewModel.playthroughPlayers.toList(),
                        onPlayerSelectionChanged: (bool? isSelected, PlaythroughPlayer player) =>
                            _togglePlayerSelection(isSelected, player),
                        onCreatePlayer: () async => _handleCreatePlayer(),
                      );
                    },
                  ),
                ),
                Step(
                  title: const Text(AppText.playthroughsLogGamePagePlayerScoresStepTitle),
                  isActive: widget.viewModel.playthroughStartTime == PlaythroughStartTime.inThePast,
                  state: widget.viewModel.playthroughStartTime == PlaythroughStartTime.now
                      ? StepState.disabled
                      : completedSteps > playersScoreStep
                          ? StepState.complete
                          : StepState.indexed,
                  content: _PlayerScoresStep(viewModel: widget.viewModel),
                ),
              ],
              onStepCancel: () => _stepCancel(),
              onStepContinue: () => _stepContinue(context),
              onStepTapped: (int index) => _stepTapped(context, index),
              controlsBuilder: (BuildContext _, ControlsDetails details) =>
                  _stepActionButtons(details.onStepContinue, details.onStepCancel),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepActionButtons(VoidCallback? onStepContinue, VoidCallback? onStepCancel) {
    Widget? step;
    if (widget.viewModel.logGameStep == playingOrPlayedStep) {
      step = Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: () => onStepContinue!(),
          child: const Text('Next'),
        ),
      );
    }

    if (widget.viewModel.logGameStep == selectPlayersStep ||
        widget.viewModel.logGameStep == selectDateStep ||
        widget.viewModel.logGameStep == playersScoreStep) {
      step = Row(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => onStepContinue!(),
            child:
                widget.viewModel.logGameStep == lastStep ? const Text('Done') : const Text('Next'),
          ),
          const SizedBox(width: Dimensions.doubleStandardSpacing),
          TextButton(
            onPressed: () => onStepCancel!(),
            child: const Text('Go Back'),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.doubleStandardSpacing),
      child: step,
    );
  }

  void _stepTapped(BuildContext context, int step) {
    if (step > selectPlayersStep && !widget.viewModel.anyPlayerSelected) {
      _showSelectPlayerError(context);
      setState(() {
        widget.viewModel.logGameStep = selectPlayersStep;
      });
    } else {
      setState(() {
        widget.viewModel.logGameStep = step;
      });
    }
  }

  Future<void> _stepContinue(BuildContext context) async {
    if (widget.viewModel.logGameStep == selectPlayersStep && !widget.viewModel.anyPlayerSelected) {
      _showSelectPlayerError(context);
      return;
    }

    if (widget.viewModel.logGameStep >= selectPlayersStep && selectPlayersStepError) {
      setState(() {
        selectPlayersStepError = false;
      });
    }

    if (widget.viewModel.logGameStep < lastStep) {
      int stepIncrement = 1;
      if (widget.viewModel.playthroughStartTime == PlaythroughStartTime.now &&
          widget.viewModel.logGameStep == playingOrPlayedStep) {
        stepIncrement = 2;
      }

      setState(() {
        widget.viewModel.logGameStep += stepIncrement;
        completedSteps = widget.viewModel.logGameStep;
      });
    } else {
      final PlaythroughDetails? newPlaythrough =
          await widget.viewModel.createPlaythrough(widget.viewModel.boardGameId);
      if (!mounted) {
        return;
      }

      if (newPlaythrough == null) {
        _showFailureSnackbar(context);
      } else {
        _showConfirmationSnackbar(context);
      }
      setState(() {});
    }
  }

  void _stepCancel() {
    if (widget.viewModel.logGameStep > 0) {
      int stepIncrement = 1;
      if (widget.viewModel.playthroughStartTime == PlaythroughStartTime.now &&
          widget.viewModel.logGameStep == selectPlayersStep) {
        stepIncrement = 2;
      }
      setState(() {
        widget.viewModel.logGameStep -= stepIncrement;
      });
    }
  }

  void _showSelectPlayerError(BuildContext context) {
    setState(() {
      selectPlayersStepError = true;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        margin: Dimensions.snackbarMargin,
        behavior: SnackBarBehavior.floating,
        content: Text('You need to select at least one player'),
      ),
    );
  }

  Future<void> _handleCreatePlayer() async {
    await Navigator.pushNamed(
      context,
      PlayerPage.pageRoute,
      arguments: const PlayerPageArguments(),
    );
    // MK Reload players after getting back from players page
    widget.viewModel.loadPlaythroughPlayers();
  }

  void _togglePlayerSelection(bool? isSelected, PlaythroughPlayer player) {
    if (isSelected == null) {
      return;
    }

    if (isSelected) {
      widget.viewModel.selectPlayer(player);
    } else {
      widget.viewModel.deselectPlayer(player);
    }
  }

  void _showConfirmationSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        margin: Dimensions.snackbarMargin,
        behavior: SnackBarBehavior.floating,
        content: Text(AppText.logGameSuccessConfirmationSnackbarText),
      ),
    );
  }

  void _showFailureSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        margin: Dimensions.snackbarMargin,
        behavior: SnackBarBehavior.floating,
        content: Text(AppText.logGameFailureConfirmationSnackbarText),
      ),
    );
  }
}

class _PlayerScoresStep extends StatelessWidget with EnterScoreDialogMixin {
  const _PlayerScoresStep({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PlaythroughsLogGameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: SingleChildScrollView(
        child: Observer(
          builder: (_) {
            return Column(
              children: [
                for (var playerScore in viewModel.playerScores.values) ...[
                  _PlayerScore(
                    playerScore: playerScore,
                    onTap: (PlayerScore playerScore) async {
                      final enterScoreViewModel = EnterScoreViewModel(playerScore);
                      await showEnterScoreDialog(context, enterScoreViewModel);
                      viewModel.updatePlayerScore(playerScore, enterScoreViewModel.score);
                      return enterScoreViewModel.score.toString();
                    },
                  ),
                  const SizedBox(height: Dimensions.standardSpacing),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlayingOrPlayedStep extends StatefulWidget {
  const _PlayingOrPlayedStep({
    required this.viewModel,
    required this.onSelectionChanged,
    Key? key,
  }) : super(key: key);

  final PlaythroughsLogGameViewModel viewModel;
  final Function(PlaythroughStartTime) onSelectionChanged;

  @override
  _PlayingOrPlayedStepState createState() => _PlayingOrPlayedStepState();
}

class _PlayingOrPlayedStepState extends State<_PlayingOrPlayedStep> {
  late int hoursPlayed;
  late int minutesPlyed;

  @override
  void initState() {
    super.initState();

    hoursPlayed = widget.viewModel.playthroughDuration.inHours;
    minutesPlyed = widget.viewModel.playthroughDuration.inMinutes % Duration.minutesPerHour;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          InkWell(
            onTap: () => _updatePlaythroughStartTimeSelection(PlaythroughStartTime.now),
            child: Row(
              children: [
                Radio<PlaythroughStartTime>(
                  value: PlaythroughStartTime.now,
                  groupValue: widget.viewModel.playthroughStartTime,
                  activeColor: AppColors.accentColor,
                  onChanged: (PlaythroughStartTime? value) {
                    if (value != null) {
                      _updatePlaythroughStartTimeSelection(value);
                    }
                  },
                ),
                Text(
                  AppText.playthroughsLogGamePlayingNowOption,
                  style: AppTheme.theme.textTheme.bodyText1,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _updatePlaythroughStartTimeSelection(PlaythroughStartTime.inThePast),
            child: Row(
              children: [
                Radio<PlaythroughStartTime>(
                  value: PlaythroughStartTime.inThePast,
                  groupValue: widget.viewModel.playthroughStartTime,
                  activeColor: AppColors.accentColor,
                  onChanged: (PlaythroughStartTime? value) {
                    if (value == null) {
                      return;
                    }

                    _updatePlaythroughStartTimeSelection(value);
                  },
                ),
                Text(
                  AppText.playthroughsLogGamePlayedOption,
                  style: AppTheme.theme.textTheme.bodyText1,
                ),
              ],
            ),
          ),
          if (widget.viewModel.playthroughStartTime == PlaythroughStartTime.inThePast)
            Row(
              children: <Widget>[
                Text(
                  'The game took: ',
                  style: AppTheme.theme.textTheme.bodyText1,
                ),
                NumberPicker(
                  value: hoursPlayed,
                  minValue: 0,
                  maxValue: 99,
                  onChanged: (num value) => _updateDurationHours(value),
                  itemWidth: 46,
                  selectedTextStyle: const TextStyle(
                    color: AppColors.accentColor,
                    fontSize: Dimensions.doubleExtraLargeFontSize,
                  ),
                ),
                Text('h', style: AppTheme.theme.textTheme.bodyText2),
                const SizedBox(width: Dimensions.halfStandardSpacing),
                NumberPicker(
                  value: math.min(Duration.minutesPerHour - 1, minutesPlyed),
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
                Text('min ', style: AppTheme.theme.textTheme.bodyText2),
              ],
            ),
        ],
      ),
    );
  }

  void _updatePlaythroughStartTimeSelection(PlaythroughStartTime playthroughStartTime) {
    setState(() {
      widget.viewModel.playthroughStartTime = playthroughStartTime;
    });
    widget.onSelectionChanged(playthroughStartTime);
  }

  void _updateDurationHours(num value) {
    setState(() {
      hoursPlayed = value.toInt();
      widget.viewModel.playthroughDuration = Duration(hours: hoursPlayed, minutes: minutesPlyed);
    });
  }

  void _updateDurationMinutes(num value) {
    setState(() {
      minutesPlyed = value.toInt();
      widget.viewModel.playthroughDuration = Duration(hours: hoursPlayed, minutes: minutesPlyed);
    });
  }
}

class _SelectPlayersStep extends StatelessWidget {
  const _SelectPlayersStep({
    Key? key,
    required this.playthroughPlayers,
    required this.onPlayerSelectionChanged,
    required this.onCreatePlayer,
  }) : super(key: key);

  final List<PlaythroughPlayer>? playthroughPlayers;
  final void Function(bool?, PlaythroughPlayer) onPlayerSelectionChanged;
  final VoidCallback onCreatePlayer;

  @override
  Widget build(BuildContext context) {
    if (playthroughPlayers?.isEmpty ?? true) {
      return _NoPlayers(onCreatePlayer: () => onCreatePlayer());
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: _Players(
        playthroughPlayers: playthroughPlayers,
        onPlayerSelectionChanged: (bool? isSelected, PlaythroughPlayer player) =>
            onPlayerSelectionChanged(isSelected, player),
      ),
    );
  }
}

class _SelectDateStep extends StatefulWidget {
  const _SelectDateStep({
    required this.playthroughDate,
    required this.onPlaythroughTimeChanged,
    Key? key,
  }) : super(key: key);

  final DateTime playthroughDate;
  final Function(DateTime) onPlaythroughTimeChanged;

  @override
  _SelectDateStepState createState() => _SelectDateStepState();
}

class _SelectDateStepState extends State<_SelectDateStep> {
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
        ItemPropertyValue(
          _playthroughDate.toDaysAgo(),
        ),
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

class _Players extends StatelessWidget {
  const _Players({
    Key? key,
    required this.playthroughPlayers,
    required this.onPlayerSelectionChanged,
  }) : super(key: key);

  int get _numberOfPlayerColumns => 3;
  final List<PlaythroughPlayer>? playthroughPlayers;
  final Function(bool?, PlaythroughPlayer) onPlayerSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final playerAvatarSize = MediaQuery.of(context).size.width / _numberOfPlayerColumns;

    return GridView.count(
      crossAxisCount: _numberOfPlayerColumns,
      padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
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
                  onChanged: (isChecked) => onPlayerSelectionChanged(isChecked, playthroughPlayer),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _NoPlayers extends StatelessWidget {
  const _NoPlayers({
    required this.onCreatePlayer,
    Key? key,
  }) : super(key: key);

  final VoidCallback onCreatePlayer;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            AppText.playthroughsLogGamePageCreatePlayerTitle,
            style: AppTheme.theme.textTheme.bodyText1,
          ),
          const SizedBox(height: Dimensions.halfStandardSpacing),
          Align(
            alignment: Alignment.topRight,
            child: ElevatedIconButton(
              title: AppText.playthroughsLogGamePageCreatePlayerButtonText,
              icon: const DefaultIcon(Icons.add),
              onPressed: () => onCreatePlayer(),
            ),
          ),
        ],
      );
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
              Text('points', style: AppTheme.theme.textTheme.bodyText2),
            ],
          ),
        ],
      ),
    );
  }
}

enum PlaythroughStartTime {
  now,
  inThePast,
}
