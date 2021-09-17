import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/page_controller_extensions.dart';
import '../../injectable.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/playthrough_player.dart';
import '../../stores/board_game_playthroughs_store.dart';
import '../../stores/players_store.dart';
import '../../stores/playthroughs_store.dart';
import '../../stores/start_playthrough_store.dart';
import '../../utilities/navigator_helper.dart';
import '../../widgets/common/bottom_tabs/custom_bottom_navigation_bar_item_widget.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/common/ripple_effect.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../base_page_state.dart';
import 'playthroughs_history_page.dart';
import 'playthroughs_statistics_page.dart';

class PlaythroughsPage extends StatefulWidget {
  const PlaythroughsPage(
    this.boardGameDetails,
    this.collectionType, {
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final CollectionType collectionType;

  @override
  _PlaythroughsPageState createState() => _PlaythroughsPageState();
}

class _PlaythroughsPageState extends BasePageState<PlaythroughsPage> {
  BoardGamePlaythroughsStore boardGamePlaythoughsStore;
  PageController pageController;
  PlaythroughsStore playthroughsStore;

  @override
  void initState() {
    super.initState();

    boardGamePlaythoughsStore = Provider.of<BoardGamePlaythroughsStore>(
      context,
      listen: false,
    );
    pageController = PageController(
      initialPage: boardGamePlaythoughsStore.boardGamePlaythroughPageIndex,
    );
    playthroughsStore = getIt<PlaythroughsStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.boardGameDetails.name ?? ''),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info,
              color: AppTheme.accentColor,
            ),
            onPressed: () async {
              await _goToBoardGameDetails(context, widget.boardGameDetails);
            },
          )
        ],
      ),
      body: SafeArea(
        child: PageContainer(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) => _onTabPageChanged(index, boardGamePlaythoughsStore),
            children: <Widget>[
              PlaythroughStatistcsPage(
                boardGameDetails: widget.boardGameDetails,
                collectionType: widget.collectionType,
              ),
              PlaythroughsHistoryPage(
                widget.boardGameDetails,
                playthroughsStore,
              ),
              Consumer<PlayersStore>(
                builder: (_, __, ___) {
                  return _NewPlaythrough(
                    widget.boardGameDetails,
                    pageController,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<BoardGamePlaythroughsStore>(
        builder: (_, store, __) {
          return BottomNavigationBar(
            backgroundColor: AppTheme.bottomTabBackgroundColor,
            items: <BottomNavigationBarItem>[
              CustomBottomNavigationBarItem('Stats', Icons.multiline_chart),
              CustomBottomNavigationBarItem('History', Icons.history),
              CustomBottomNavigationBarItem('Log Game', Icons.casino),
            ],
            onTap: (index) async {
              await _onTabChanged(index, pageController);
            },
            currentIndex: store.boardGamePlaythroughPageIndex,
          );
        },
      ),
    );
  }

  Future<void> _onTabChanged(int index, PageController pageController) async {
    await pageController.animateToTab(index);
  }

  void _onTabPageChanged(int pageIndex, BoardGamePlaythroughsStore boardGamePlaythroughsStore) {
    boardGamePlaythroughsStore.boardGamePlaythroughPageIndex = pageIndex;
  }

  Future<void> _goToBoardGameDetails(
    BuildContext context,
    BoardGameDetails boardGameDetails,
  ) async {
    await NavigatorHelper.navigateToBoardGameDetails(
      context,
      boardGameDetails?.id,
      boardGameDetails?.name,
      PlaythroughsPage,
    );
  }
}

class _NewPlaythrough extends StatefulWidget {
  const _NewPlaythrough(
    this.boardGameDetails,
    this.pageController, {
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final PageController pageController;

  @override
  _NewPlaythroughState createState() => _NewPlaythroughState();
}

class _NewPlaythroughState extends State<_NewPlaythrough> {
  StartPlaythroughStore startPlaythroughStore;

  @override
  void initState() {
    super.initState();

    startPlaythroughStore = Provider.of<StartPlaythroughStore>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConsumerFutureBuilder<List<PlaythroughPlayer>, StartPlaythroughStore>(
      future: startPlaythroughStore.loadPlaythroughPlayers(),
      success: (_, StartPlaythroughStore store) {
        if (store.playthroughPlayers?.isNotEmpty ?? false) {
          return _LogPlaythroughStepper(
            startPlaythroughStore: store,
            boardGameDetails: widget.boardGameDetails,
          );
        }

        // TODO Think how to deal with a situation when there's no players yet
        return const _NoPlayers();
      },
    );
  }
}

class _LogPlaythroughStepper extends StatefulWidget {
  const _LogPlaythroughStepper({
    @required this.startPlaythroughStore,
    @required this.boardGameDetails,
    Key key,
  }) : super(key: key);

  final StartPlaythroughStore startPlaythroughStore;
  final BoardGameDetails boardGameDetails;

  @override
  _LogPlaythroughStepperState createState() => _LogPlaythroughStepperState();
}

class _LogPlaythroughStepperState extends State<_LogPlaythroughStepper> {
  int _step = 2;

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
        SingleChildScrollView(
          child: Theme(
            data: AppTheme.theme.copyWith(
              colorScheme: AppTheme.theme.colorScheme.copyWith(
                primary: AppTheme.accentColor,
              ),
            ),
            child: Stepper(
              currentStep: _step,
              steps: [
                Step(
                  title: const Text('When?'),
                  content: _StepperTimeStep(
                    onPlaythroughTimeChanged: (DateTime playthoughDate) {},
                  ),
                ),
                Step(
                  title: const Text('Who?'),
                  content: _StepperPlayersStep(
                    playthroughPlayers: widget.startPlaythroughStore.playthroughPlayers,
                    boardGameDetails: widget.boardGameDetails,
                  ),
                ),
                Step(
                  title: const Text('How long?'),
                  content: _StepperDurationStep(),
                ),
              ],
              onStepCancel: () => _cancel(),
              onStepContinue: () => _continue(),
              onStepTapped: (int index) => _stepTapped(index),
              controlsBuilder: (_, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return _stepActionButtons(onStepContinue, onStepCancel);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepActionButtons(VoidCallback onStepContinue, VoidCallback onStepCancel) {
    Widget step;
    if (_step == 0) {
      step = Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: () => onStepContinue(),
          child: const Text('Next'),
        ),
      );
    }

    if (_step == 1 || _step == 2) {
      step = Row(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => onStepContinue(),
            child: _step == 1 ? const Text('Next') : const Text('Done'),
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

  void _stepTapped(int index) {
    setState(() {
      _step = index;
    });
  }

  void _continue() {
    if (_step <= 3) {
      setState(() {
        _step += 1;
      });
    }
  }

  void _cancel() {
    if (_step > 0) {
      setState(() {
        _step -= 1;
      });
    }
  }

  Future<void> _startNewGame(
    BuildContext context,
  ) async {
    final startPlaythroughStore = Provider.of<StartPlaythroughStore>(
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
}

class _StepperDurationStep extends StatefulWidget {
  const _StepperDurationStep({
    Key key,
  }) : super(key: key);

  @override
  _StepperDurationStepState createState() => _StepperDurationStepState();
}

class _StepperDurationStepState extends State<_StepperDurationStep> {
  int hoursPlayed = 0;
  int minutesPlyed = 30;
  PlaythroughStartTime _playthroughStartTime = PlaythroughStartTime.now;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Radio<PlaythroughStartTime>(
              value: PlaythroughStartTime.now,
              groupValue: _playthroughStartTime,
              activeColor: AppTheme.accentColor,
              onChanged: (PlaythroughStartTime value) {
                setState(() {
                  _playthroughStartTime = value;
                });
              },
            ),
            Text(
              'Start the timer now!',
              style: AppTheme.theme.textTheme.bodyText1,
            ),
          ],
        ),
        Row(
          children: [
            Radio<PlaythroughStartTime>(
              value: PlaythroughStartTime.inThePast,
              groupValue: _playthroughStartTime,
              activeColor: AppTheme.accentColor,
              onChanged: (PlaythroughStartTime value) {
                setState(() {
                  _playthroughStartTime = value;
                });
              },
            ),
            Text(
              'The game took us...',
              style: AppTheme.theme.textTheme.bodyText1,
            ),
          ],
        ),
        if (_playthroughStartTime == PlaythroughStartTime.inThePast)
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
    );
  }

  void _updateDurationHours(num value) {
    setState(() {
      hoursPlayed = value.toInt();
    });
  }

  void _updateDurationMinutes(num value) {
    setState(() {
      minutesPlyed = value.toInt();
    });
  }
}

class _StepperPlayersStep extends StatelessWidget {
  const _StepperPlayersStep({
    Key key,
    @required this.playthroughPlayers,
    @required this.boardGameDetails,
  }) : super(key: key);

  final List<PlaythroughPlayer> playthroughPlayers;
  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 200,
      child: _Players(
        playthroughPlayers: playthroughPlayers,
        boardGameDetails: boardGameDetails,
      ),
    );
  }
}

class _StepperTimeStep extends StatefulWidget {
  const _StepperTimeStep({
    @required this.onPlaythroughTimeChanged,
    Key key,
  }) : super(key: key);

  final Function(DateTime) onPlaythroughTimeChanged;

  @override
  _StepperTimeStepState createState() => _StepperTimeStepState();
}

class _StepperTimeStepState extends State<_StepperTimeStep> {
  DateTime _playthroughDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CalendarCard(_playthroughDate),
        const SizedBox(
          width: Dimensions.standardSpacing,
        ),
        ItemPropertyValue(
          _playthroughDate.toDaysAgo(),
        ),
      ],
    );
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
      padding: const EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      crossAxisCount: _numberOfPlayerColumns,
      children: List.generate(
        playthroughPlayers.length,
        (int index) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
                child: PlayerAvatar(playthroughPlayers[index].player),
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
                        onChanged: (checked) {},
                      );
                    },
                  ),
                ),
              ),
              Positioned.fill(
                child: RippleEffect(
                  onTap: () {
                    playthroughPlayers[index].isChecked = !playthroughPlayers[index].isChecked;
                  },
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
