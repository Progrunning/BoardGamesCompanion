import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/ripple_effect.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:board_games_companion/widgets/playthrough/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
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
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/page_container_widget.dart';
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
  __LogPlaythroughStepperState createState() => __LogPlaythroughStepperState();
}

class __LogPlaythroughStepperState extends State<_LogPlaythroughStepper> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _step,
      steps: [
        Step(
          content: _PlaythroughTimeStep(),
          title: const Text('Pick time'),
        ),
        Step(
          content: _StepperPlayersStep(
            playthroughPlayers: widget.startPlaythroughStore.playthroughPlayers,
            boardGameDetails: widget.boardGameDetails,
          ),
          title: const Text('Pick players'),
        ),
        Step(
          content: _StepperDateStep(),
          title: const Text('Pick a date'),
        ),
      ],
      onStepCancel: () {
        _cancel();
      },
      onStepContinue: () {
        _continue();
      },
      onStepTapped: (int index) {
        _stepTapped(index);
      },
    );
  }

  void _stepTapped(int index) {
    setState(() {
      _step = index;
    });
  }

  void _continue() {
    if (_step <= 1) {
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

class _StepperDateStep extends StatelessWidget {
  const _StepperDateStep({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarCard(DateTime.now());
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
      height: 400,
      child: _Players(
        playthroughPlayers: playthroughPlayers,
        boardGameDetails: boardGameDetails,
      ),
    );
  }
}

class _PlaythroughTimeStep extends StatefulWidget {
  const _PlaythroughTimeStep({
    Key key,
  }) : super(key: key);

  @override
  __PlaythroughTimeStepState createState() => __PlaythroughTimeStepState();
}

class __PlaythroughTimeStepState extends State<_PlaythroughTimeStep> {
  PlaythoughTime _playthroughTime = PlaythoughTime.now;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Now'),
          leading: Radio<PlaythoughTime>(
            value: PlaythoughTime.now,
            groupValue: _playthroughTime,
            onChanged: (PlaythoughTime value) {
              setState(() {
                _playthroughTime = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('In the past'),
          leading: Radio<PlaythoughTime>(
            value: PlaythoughTime.inThePast,
            groupValue: _playthroughTime,
            onChanged: (PlaythoughTime value) {
              setState(() {
                _playthroughTime = value;
              });
            },
          ),
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

enum PlaythoughTime {
  now,
  inThePast,
}
