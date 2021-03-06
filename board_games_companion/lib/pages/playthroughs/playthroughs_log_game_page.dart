import 'dart:math' as math;

import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../extensions/date_time_extensions.dart';
import '../../mixins/enter_score_dialog.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../models/player_score.dart';
import '../../models/playthrough_player.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../enter_score/enter_score_view_model.dart';
import '../players/player_page.dart';
import '../players/players_view_model.dart';
import 'playthroughs_view_model.dart';

class PlaythroughsLogGamePage extends StatefulWidget {
  const PlaythroughsLogGamePage({
    required this.boardGameDetails,
    required this.playthroughsLogGameViewModel,
    Key? key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final PlaythroughsViewModel playthroughsLogGameViewModel;

  @override
  _PlaythroughsLogGamePageState createState() => _PlaythroughsLogGamePageState();
}

class _PlaythroughsLogGamePageState extends State<PlaythroughsLogGamePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.playthroughsLogGameViewModel,
      child: Consumer<PlayersViewModel>(
        builder: (_, __, ___) =>
            ConsumerFutureBuilder<List<PlaythroughPlayer>, PlaythroughsViewModel>(
          future: widget.playthroughsLogGameViewModel.loadPlaythroughPlayers(),
          success: (_, PlaythroughsViewModel viewModel) {
            return _LogPlaythroughStepper(
              viewModel: viewModel,
              boardGameDetails: widget.boardGameDetails,
            );
          },
        ),
      ),
    );
  }
}

class _LogPlaythroughStepper extends StatefulWidget {
  const _LogPlaythroughStepper({
    required this.viewModel,
    required this.boardGameDetails,
    Key? key,
  }) : super(key: key);

  final PlaythroughsViewModel viewModel;
  final BoardGameDetails boardGameDetails;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Text('Log a game', style: AppTheme.theme.textTheme.headline2),
        ),
        Expanded(
          child: Theme(
            data: AppTheme.theme.copyWith(
              colorScheme: AppTheme.theme.colorScheme.copyWith(primary: AppTheme.accentColor),
            ),
            child: Stepper(
              currentStep: widget.viewModel.logGameStep,
              steps: [
                Step(
                  title: const Text('Playing or played'),
                  state:
                      completedSteps > playingOrPlayedStep ? StepState.complete : StepState.indexed,
                  content: _PlayingOrPlayedStep(
                    viewModel: widget.viewModel,
                    onSelectionChanged: (PlaythroughStartTime playthroughStartTime) =>
                        setState(() {}),
                  ),
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
                  content: _SelectPlayersStep(
                    playthroughPlayers: widget.viewModel.playthroughPlayers,
                    boardGameDetails: widget.boardGameDetails,
                    onPlayerSelectionChanged: (bool? isSelected, PlaythroughPlayer player) =>
                        _togglePlayerSelection(isSelected, player, widget.boardGameDetails.id),
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
      final Playthrough? newPlaythrough =
          await widget.viewModel.createPlaythrough(widget.boardGameDetails.id);
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
        behavior: SnackBarBehavior.floating,
        content: Text('You need to select at least one player'),
      ),
    );
  }

  void _togglePlayerSelection(bool? isSelected, PlaythroughPlayer player, String boardGameId) {
    if (isSelected == null) {
      return;
    }

    if (isSelected) {
      widget.viewModel.selectPlayer(player, boardGameId);
    } else {
      widget.viewModel.deselectPlayer(player);
    }
  }

  void _showConfirmationSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(AppText.logGameSuccessConfirmationSnackbarText),
      ),
    );
  }

  void _showFailureSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
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

  final PlaythroughsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var playerScore in viewModel.playerScores.values) ...[
              _PlayerScore(
                playerScore: playerScore,
                onTap: (PlayerScore playerScore) async {
                  await showEnterScoreDialog(context, EnterScoreViewModel(playerScore));
                },
              ),
              const SizedBox(height: Dimensions.standardSpacing),
            ]
          ],
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

  final PlaythroughsViewModel viewModel;
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
                  activeColor: AppTheme.accentColor,
                  onChanged: (PlaythroughStartTime? value) {
                    if (value != null) {
                      _updatePlaythroughStartTimeSelection(value);
                    }
                  },
                ),
                Text(
                  'Playing now',
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
                  activeColor: AppTheme.accentColor,
                  onChanged: (PlaythroughStartTime? value) {
                    if (value == null) {
                      return;
                    }

                    _updatePlaythroughStartTimeSelection(value);
                  },
                ),
                Text(
                  'Played some time ago',
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
                    color: AppTheme.accentColor,
                    fontSize: Dimensions.doubleExtraLargeFontSize,
                  ),
                ),
                Text(
                  'h',
                  style: AppTheme.theme.textTheme.bodyText2,
                ),
                const SizedBox(width: Dimensions.halfStandardSpacing),
                NumberPicker(
                  value: math.min(Duration.minutesPerHour - 1, minutesPlyed),
                  infiniteLoop: true,
                  minValue: 0,
                  maxValue: Duration.minutesPerHour - 1,
                  onChanged: (num value) => _updateDurationMinutes(value),
                  itemWidth: 46,
                  selectedTextStyle: const TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: Dimensions.doubleExtraLargeFontSize,
                  ),
                ),
                Text(
                  'min ',
                  style: AppTheme.theme.textTheme.bodyText2,
                ),
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
    required this.boardGameDetails,
    required this.onPlayerSelectionChanged,
  }) : super(key: key);

  final List<PlaythroughPlayer>? playthroughPlayers;
  final BoardGameDetails boardGameDetails;
  final Function(bool?, PlaythroughPlayer) onPlayerSelectionChanged;

  @override
  Widget build(BuildContext context) {
    if (playthroughPlayers?.isEmpty ?? true) {
      return const _NoPlayers();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Builder(
        builder: (_) {
          return _Players(
            playthroughPlayers: playthroughPlayers,
            boardGameDetails: boardGameDetails,
            onPlayerSelectionChanged: (bool? isSelected, PlaythroughPlayer player) =>
                onPlayerSelectionChanged(isSelected, player),
          );
        },
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
      firstDate: playthroughDate.add(const Duration(days: -Constants.DaysInTenYears)),
      lastDate: DateTime.now(),
      currentDate: playthroughDate,
      helpText: 'Pick a playthrough date',
      builder: (_, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.accentColor,
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
    required this.boardGameDetails,
    required this.onPlayerSelectionChanged,
  }) : super(key: key);

  int get _numberOfPlayerColumns => 3;
  final List<PlaythroughPlayer>? playthroughPlayers;
  final BoardGameDetails boardGameDetails;
  final Function(bool?, PlaythroughPlayer) onPlayerSelectionChanged;

  @override
  Widget build(BuildContext context) {
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
                playthroughPlayer.player,
                onTap: () =>
                    onPlayerSelectionChanged(!playthroughPlayer.isChecked, playthroughPlayer),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ChangeNotifierProvider.value(
                  value: playthroughPlayer,
                  child: Consumer<PlaythroughPlayer>(
                    builder: (_, store, __) {
                      return SizedBox(
                        height: 34,
                        width: 34,
                        child: Checkbox(
                          checkColor: AppTheme.accentColor,
                          activeColor: AppTheme.primaryColor.withOpacity(0.7),
                          value: playthroughPlayer.isChecked,
                          onChanged: (bool? isChecked) =>
                              onPlayerSelectionChanged(isChecked, playthroughPlayer),
                        ),
                      );
                    },
                  ),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'To log a game, you need to create players first',
          style: AppTheme.theme.textTheme.bodyText1,
        ),
        const SizedBox(
          height: Dimensions.halfStandardSpacing,
        ),
        Align(
          alignment: Alignment.topRight,
          child: ElevatedIconButton(
            title: 'Create Player',
            icon: const DefaultIcon(Icons.add),
            onPressed: () => Navigator.pushNamed(
              context,
              PlayerPage.pageRoute,
              arguments: const PlayerPageArguments(),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    Key? key,
    required this.playerScore,
    required this.onTap,
  }) : super(key: key);

  final PlayerScore playerScore;
  final void Function(PlayerScore) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(playerScore),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: Dimensions.smallPlayerAvatarSize,
            width: Dimensions.smallPlayerAvatarSize,
            child: PlayerAvatar(playerScore.player),
          ),
          const SizedBox(width: Dimensions.doubleStandardSpacing),
          Column(
            children: <Widget>[
              ChangeNotifierProvider<PlayerScore>.value(
                value: playerScore,
                child: Consumer<PlayerScore>(
                  builder: (_, PlayerScore playerScore, __) {
                    return Text(
                      '${playerScore.score.valueInt}',
                      style: Styles.playerScoreTextStyle,
                    );
                  },
                ),
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
