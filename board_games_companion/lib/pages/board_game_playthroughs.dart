import 'package:board_games_companion/common/enums/collection_flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/app_theme.dart';
import '../extensions/page_controller_extensions.dart';
import '../models/hive/board_game_details.dart';
import '../stores/board_game_playthroughs_store.dart';
import '../stores/players_store.dart';
import '../stores/playthroughs_store.dart';
import '../utilities/navigator_helper.dart';
import '../widgets/common/bottom_tabs/custom_bottom_navigation_bar_item_widget.dart';
import '../widgets/common/page_container_widget.dart';
import 'base_page_state.dart';
import 'paythrough_statistcs_page.dart';
import 'playthroughs.dart';
import 'start_new_playthrough.dart';

class BoardGamePlaythroughsPage extends StatefulWidget {
  const BoardGamePlaythroughsPage(
    this.boardGameDetails,
    this.collectionFlag, {
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final CollectionFlag collectionFlag;

  @override
  _BoardGamePlaythroughsPageState createState() => _BoardGamePlaythroughsPageState();
}

class _BoardGamePlaythroughsPageState extends BasePageState<BoardGamePlaythroughsPage> {
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
    playthroughsStore = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );
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
              await _navigateToBoardGameDetails(context, widget.boardGameDetails);
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
                collectionFlag: widget.collectionFlag,
              ),
              PlaythroughsPage(
                widget.boardGameDetails,
                playthroughsStore,
              ),
              Consumer<PlayersStore>(
                builder: (_, __, ___) {
                  return StartNewPlaythroughPage(
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
            onTap: (index) {
              _onTabChanged(index, pageController);
            },
            currentIndex: store.boardGamePlaythroughPageIndex,
          );
        },
      ),
    );
  }

  void _onTabChanged(int index, PageController pageController) {
    pageController.animateToTab(index);
  }

  void _onTabPageChanged(int pageIndex, BoardGamePlaythroughsStore boardGamePlaythroughsStore) {
    boardGamePlaythroughsStore.boardGamePlaythroughPageIndex = pageIndex;
  }

  Future<void> _navigateToBoardGameDetails(
    BuildContext context,
    BoardGameDetails boardGameDetails,
  ) async {
    await NavigatorHelper.navigateToBoardGameDetails(
      context,
      boardGameDetails?.id,
      boardGameDetails?.name,
      BoardGamePlaythroughsPage,
    );
  }
}
