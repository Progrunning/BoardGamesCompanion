import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
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
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/playthrough/playthrough_no_players.dart';
import '../../widgets/playthrough/playthrough_players.dart';
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
          return PlaythroughPlayers(
            playthroughPlayers: store.playthroughPlayers,
            boardGameDetails: widget.boardGameDetails,
            pageController: widget.pageController,
          );
        }

        return const PlaythroughNoPlayers();
      },
    );
  }
}
