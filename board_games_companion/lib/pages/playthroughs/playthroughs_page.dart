import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/enums/collection_type.dart';
import '../../extensions/page_controller_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../stores/playthroughs_store.dart';
import '../../widgets/common/bottom_tabs/custom_bottom_navigation_bar_item_widget.dart';
import '../../widgets/common/page_container_widget.dart';
import '../base_page_state.dart';
import '../board_game_details/board_game_details_page.dart';
import 'playthroughs_history_page.dart';
import 'playthroughs_log_game_page.dart';
import 'playthroughs_log_game_view_model.dart';
import 'playthroughs_statistics_page.dart';

class PlaythroughsPage extends StatefulWidget {
  const PlaythroughsPage({
    required this.viewModel,
    required this.playthroughsStore,
    required this.boardGameDetails,
    required this.collectionType,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/playthroughs';

  final BoardGameDetails boardGameDetails;
  final CollectionType collectionType;
  final PlaythroughsLogGameViewModel viewModel;
  final PlaythroughsStore playthroughsStore;

  @override
  _PlaythroughsPageState createState() => _PlaythroughsPageState();
}

class _PlaythroughsPageState extends BasePageState<PlaythroughsPage> {
  late PageController pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    
    pageController = PageController(initialPage: _pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.boardGameDetails.name),
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
            onPageChanged: (index) => _onTabPageChanged(index),
            children: <Widget>[
              PlaythroughStatistcsPage(
                boardGameDetails: widget.boardGameDetails,
                collectionType: widget.collectionType,
              ),
              PlaythroughsHistoryPage(
                boardGameDetails: widget.boardGameDetails,
                playthroughsStore: widget.playthroughsStore,
              ),
              PlaythroughsLogGamePage(
                boardGameDetails: widget.boardGameDetails,
                playthroughsLogGameViewModel: widget.viewModel,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.bottomTabBackgroundColor,
        items: <BottomNavigationBarItem>[
          CustomBottomNavigationBarItem('Stats', Icons.multiline_chart),
          CustomBottomNavigationBarItem('History', Icons.history),
          CustomBottomNavigationBarItem('Log Game', Icons.casino),
        ],
        onTap: (index) async {
          await _onTabChanged(index, pageController);
        },
        currentIndex: _pageIndex,
        unselectedItemColor: AppTheme.secondaryTextColor,
        selectedItemColor: AppTheme.defaultTextColor,
      ),
    );
  }

  Future<void> _onTabChanged(int index, PageController pageController) async {
    await pageController.animateToTab(index);
  }

  void _onTabPageChanged(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  Future<void> _navigateToBoardGameDetails(
    BuildContext context,
    BoardGameDetails boardGameDetails,
  ) async {
    await Navigator.pushNamed(
      context,
      BoardGamesDetailsPage.pageRoute,
      arguments: BoardGameDetailsPageArguments(
        boardGameDetails.id,
        boardGameDetails.name,
        PlaythroughsPage,
      ),
    );
  }
}
