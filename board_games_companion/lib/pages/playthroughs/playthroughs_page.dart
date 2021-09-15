import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/ripple_effect.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
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
              CustomBottomNavigationBarItem('New Game', Icons.play_arrow),
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
          return Stepper(
            currentStep: 0,
            steps: [
              Step(
                content: Container(
                  color: Colors.blue,
                  height: 400,
                  child: _Players(
                    playthroughPlayers: store.playthroughPlayers,
                    boardGameDetails: widget.boardGameDetails,
                    pageController: widget.pageController,
                  ),
                ),
                title: const Text('Players'),
              ),
            ],
          );
        }

        return const _NoPlayers();
      },
    );
  }
}

class _Players extends StatelessWidget {
  const _Players({
    Key key,
    @required this.playthroughPlayers,
    @required this.boardGameDetails,
    @required this.pageController,
  }) : super(key: key);

  int get _numberOfPlayerColumns => 3;
  final List<PlaythroughPlayer> playthroughPlayers;
  final BoardGameDetails boardGameDetails;
  final PageController pageController;

  static const int _playthroughsPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GridView.count(
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
        ),
        if (playthroughPlayers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              bottom: Dimensions.standardSpacing,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconAndTextButton(
                icon: const DefaultIcon(Icons.play_arrow),
                onPressed: () => _onStartNewGame(context),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onStartNewGame(
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
      boardGameDetails.id,
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

    pageController.animateToTab(_playthroughsPageIndex);
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
