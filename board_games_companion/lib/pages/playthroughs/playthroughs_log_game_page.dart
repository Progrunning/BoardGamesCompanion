import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../extensions/date_time_extensions.dart';
import '../../injectable.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/playthrough_player.dart';
import '../../stores/players_store.dart';
import '../../stores/playthroughs_store.dart';
import '../../utilities/navigator_helper.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import 'playthroughs_log_game_view_model.dart';

class PlaythroughsLogGamePage extends StatefulWidget {
  const PlaythroughsLogGamePage({
    @required this.boardGameDetails,
    @required this.playthroughsLogGameViewModel,
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final PlaythroughsLogGameViewModel playthroughsLogGameViewModel;

  @override
  _PlaythroughsLogGamePageState createState() => _PlaythroughsLogGamePageState();
}

class _PlaythroughsLogGamePageState extends State<PlaythroughsLogGamePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.playthroughsLogGameViewModel,
      child: Consumer<PlayersStore>(
          builder: (_, __, ___) =>
              ConsumerFutureBuilder<List<PlaythroughPlayer>, PlaythroughsLogGameViewModel>(
                future: widget.playthroughsLogGameViewModel.loadPlaythroughPlayers(),
                success: (_, PlaythroughsLogGameViewModel viewModel) {
                  if (viewModel.playthroughPlayers?.isNotEmpty ?? false) {
                    return _LogPlaythroughStepper(
                      viewModel: viewModel,
                      boardGameDetails: widget.boardGameDetails,
                    );
                  }

                  // TODO Think how to deal with a situation when there's no players yet
                  return const _NoPlayers();
                },
              )),
    );
  }
}

class _LogPlaythroughStepper extends StatefulWidget {
  const _LogPlaythroughStepper({
    @required this.viewModel,
    @required this.boardGameDetails,
    Key key,
  }) : super(key: key);

  final PlaythroughsLogGameViewModel viewModel;
  final BoardGameDetails boardGameDetails;

  @override
  _LogPlaythroughStepperState createState() => _LogPlaythroughStepperState();
}

class _LogPlaythroughStepperState extends State<_LogPlaythroughStepper> {
  int whenStep = 0;
  int whoStep = 1;
  int howLongStep = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Text(
            'Log a game',
            style: AppTheme.theme.textTheme.headline2,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Theme(
              data: AppTheme.theme.copyWith(
                colorScheme: AppTheme.theme.colorScheme.copyWith(
                  primary: AppTheme.accentColor,
                ),
              ),
              child: Stepper(
                currentStep: widget.viewModel.logGameStep,
                steps: [
                  Step(
                    title: const Text('When?'),
                    content: _StepperWhenStep(
                      onPlaythroughTimeChanged: (DateTime playthoughDate) {
                        widget.viewModel.playthroughDate = playthoughDate;
                      },
                    ),
                  ),
                  Step(
                    title: const Text('Who?'),
                    content: _StepperWhoStep(
                      playthroughPlayers: widget.viewModel.playthroughPlayers,
                      boardGameDetails: widget.boardGameDetails,
                    ),
                  ),
                  Step(
                    title: const Text('How long?'),
                    content: _StepperDurationStep(viewModel: widget.viewModel),
                  ),
                ],
                onStepCancel: () => _stepCancel(),
                onStepContinue: () => _stepContinue(context),
                onStepTapped: (int index) => _stepTapped(context, index),
                controlsBuilder: (_, {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                    _stepActionButtons(onStepContinue, onStepCancel),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepActionButtons(VoidCallback onStepContinue, VoidCallback onStepCancel) {
    Widget step;
    if (widget.viewModel.logGameStep == whenStep) {
      step = Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: () => onStepContinue(),
          child: const Text('Next'),
        ),
      );
    }

    if (widget.viewModel.logGameStep == whoStep || widget.viewModel.logGameStep == howLongStep) {
      step = Row(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => onStepContinue(),
            child: widget.viewModel.logGameStep == 1 ? const Text('Next') : const Text('Done'),
          ),
          const SizedBox(width: Dimensions.doubleStandardSpacing),
          TextButton(
            onPressed: () => onStepCancel(),
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
    if (widget.viewModel.logGameStep == whoStep && !widget.viewModel.anyPlayerSelected) {
      _showSelectPlayerError(context);
    } else {
      setState(() {
        widget.viewModel.logGameStep = step;
      });
    }
  }

  Future<void> _stepContinue(BuildContext context) async {
    if (widget.viewModel.logGameStep == whoStep && !widget.viewModel.anyPlayerSelected) {
      _showSelectPlayerError(context);
    } else {
      if (widget.viewModel.logGameStep <= howLongStep) {
        setState(() {
          widget.viewModel.logGameStep += 1;
        });
      }
    }
  }

  void _stepCancel() {
    if (widget.viewModel.logGameStep > 0) {
      setState(() {
        widget.viewModel.logGameStep -= 1;
      });
    }
  }

  Future<void> _startNewGame(
    BuildContext context,
  ) async {
    final startPlaythroughStore = Provider.of<PlaythroughsLogGameViewModel>(
      context,
      listen: false,
    );

    final selectedPlaythoughPlayers =
        startPlaythroughStore.playthroughPlayers?.where((pp) => pp.isChecked)?.toList();

    final scaffold = Scaffold.of(context);
    if (selectedPlaythoughPlayers?.isEmpty ?? true) {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('You need to select at least one player to start a game'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              scaffold.hideCurrentSnackBar();
            },
          ),
        ),
      );

      return;
    }

    final playthroughsStore = getIt<PlaythroughsStore>();
    final newPlaythrough = await playthroughsStore.createPlaythrough(
      widget.boardGameDetails.id,
      selectedPlaythoughPlayers,
    );

    if (newPlaythrough == null) {
      scaffold.showSnackBar(
        SnackBar(
          content: const GenericErrorMessage(),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              scaffold.hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }
  }

  void _showSelectPlayerError(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: const Text('You need to select at least one player'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () async {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

class _StepperDurationStep extends StatefulWidget {
  const _StepperDurationStep({
    @required this.viewModel,
    Key key,
  }) : super(key: key);

  final PlaythroughsLogGameViewModel viewModel;

  @override
  _StepperDurationStepState createState() => _StepperDurationStepState();
}

class _StepperDurationStepState extends State<_StepperDurationStep> {
  int hoursPlayed;
  int minutesPlyed;

  @override
  void initState() {
    super.initState();

    hoursPlayed = widget.viewModel.playthroughDuration.inHours;
    minutesPlyed = widget.viewModel.playthroughDuration.inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                widget.viewModel.playthroughStartTime = PlaythroughStartTime.now;
              });
            },
            child: Row(
              children: [
                Radio<PlaythroughStartTime>(
                  value: PlaythroughStartTime.now,
                  groupValue: widget.viewModel.playthroughStartTime,
                  activeColor: AppTheme.accentColor,
                  onChanged: (PlaythroughStartTime value) {
                    setState(() {
                      widget.viewModel.playthroughStartTime = value;
                    });
                  },
                ),
                Text(
                  'Start the timer now!',
                  style: AppTheme.theme.textTheme.bodyText1,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.viewModel.playthroughStartTime = PlaythroughStartTime.inThePast;
              });
            },
            child: Row(
              children: [
                Radio<PlaythroughStartTime>(
                  value: PlaythroughStartTime.inThePast,
                  groupValue: widget.viewModel.playthroughStartTime,
                  activeColor: AppTheme.accentColor,
                  onChanged: (PlaythroughStartTime value) {
                    setState(() {
                      widget.viewModel.playthroughStartTime = value;
                    });
                  },
                ),
                Text(
                  'The game took us...',
                  style: AppTheme.theme.textTheme.bodyText1,
                ),
              ],
            ),
          ),
          if (widget.viewModel.playthroughStartTime == PlaythroughStartTime.inThePast)
            Row(
              children: <Widget>[
                NumberPicker.integer(
                  initialValue: hoursPlayed,
                  minValue: 0,
                  maxValue: 99,
                  onChanged: (num value) => _updateDurationHours(value),
                  listViewWidth: 46,
                ),
                Text(
                  'h',
                  style: AppTheme.theme.textTheme.bodyText2,
                ),
                const SizedBox(width: Dimensions.halfStandardSpacing),
                NumberPicker.integer(
                  initialValue: minutesPlyed,
                  minValue: 0,
                  maxValue: 59,
                  onChanged: (num value) => _updateDurationMinutes(value),
                  listViewWidth: 46,
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

class _StepperWhoStep extends StatelessWidget {
  const _StepperWhoStep({
    Key key,
    @required this.playthroughPlayers,
    @required this.boardGameDetails,
  }) : super(key: key);

  final List<PlaythroughPlayer> playthroughPlayers;
  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: _Players(
        playthroughPlayers: playthroughPlayers,
        boardGameDetails: boardGameDetails,
      ),
    );
  }
}

class _StepperWhenStep extends StatefulWidget {
  const _StepperWhenStep({
    @required this.onPlaythroughTimeChanged,
    Key key,
  }) : super(key: key);

  final Function(DateTime) onPlaythroughTimeChanged;

  @override
  _StepperWhenStepState createState() => _StepperWhenStepState();
}

class _StepperWhenStepState extends State<_StepperWhenStep> {
  DateTime _playthroughDate;

  @override
  void initState() {
    _playthroughDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          child: InkWell(
            onTap: () => _pickPlaythroughDate(context, _playthroughDate),
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
    final DateTime newPlaythroughDate = await showDatePicker(
      context: context,
      initialDate: playthroughDate,
      firstDate: playthroughDate.add(const Duration(days: -Constants.DaysInTenYears)),
      lastDate: DateTime.now(),
      currentDate: playthroughDate,
      helpText: 'Pick a playthrough date',
      builder: (_, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.accentColor,
                ),
          ),
          child: child,
        );
      },
    );

    if (newPlaythroughDate == null) {
      return;
    }

    setState(() {
      _playthroughDate = newPlaythroughDate;
    });
  }
}

class _Players extends StatelessWidget {
  const _Players({
    Key key,
    @required this.playthroughPlayers,
    @required this.boardGameDetails,
  }) : super(key: key);

  int get _numberOfPlayerColumns => 3;
  final List<PlaythroughPlayer> playthroughPlayers;
  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _numberOfPlayerColumns,
      padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
      crossAxisSpacing: Dimensions.standardSpacing,
      mainAxisSpacing: Dimensions.standardSpacing,
      children: List.generate(
        playthroughPlayers.length,
        (int index) {
          return Stack(
            children: <Widget>[
              PlayerAvatar(
                playthroughPlayers[index].player,
                onTap: () =>
                    playthroughPlayers[index].isChecked = !playthroughPlayers[index].isChecked,
              ),
              Align(
                alignment: Alignment.topRight,
                child: ChangeNotifierProvider.value(
                  value: playthroughPlayers[index],
                  child: Consumer<PlaythroughPlayer>(
                    builder: (_, store, __) {
                      return Checkbox(
                        checkColor: AppTheme.accentColor,
                        activeColor: AppTheme.primaryColor.withOpacity(0.7),
                        value: playthroughPlayers[index].isChecked,
                        onChanged: (checked) {
                          playthroughPlayers[index].isChecked =
                              !playthroughPlayers[index].isChecked;
                        },
                      );
                    },
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

class _NoPlayers extends StatelessWidget {
  const _NoPlayers({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Center(
              child: Column(
                children: <Widget>[
                  const Text('To start a new game, you need to create players first'),
                  const Divider(
                    height: Dimensions.halfStandardSpacing,
                  ),
                  IconAndTextButton(
                    title: 'Add Player',
                    icon: const DefaultIcon(Icons.add),
                    onPressed: () async {
                      await NavigatorHelper.navigateToCreatePlayerPage(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
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
