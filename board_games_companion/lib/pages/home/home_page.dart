import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/pages/home/home_view_model.dart';
import 'package:board_games_companion/pages/playthroughs_history/playthroughs_history_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/dimensions.dart';
import '../../widgets/bottom_tab_icon.dart';
import '../../widgets/common/page_container.dart';
import '../base_page_state.dart';
import '../games/games_page.dart';
import '../players/players_page.dart';
import '../search_board_games/search_board_games_page.dart';
import 'home_page_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/home';

  final HomeViewModel viewModel;

  static final GlobalKey<ScaffoldMessengerState> homePageGlobalKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BasePageState<HomePage> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  static const int _numberOfTabs = 4;
  static const int _initialTabIndex = 0;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      initialIndex: _initialTabIndex,
      length: _numberOfTabs,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: HomePage.homePageGlobalKey,
      child: Scaffold(
        drawer: const Drawer(child: HomePageDrawer()),
        body: SafeArea(
          child: PageContainer(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                GamesPage(
                  widget.viewModel.gamesViewModel,
                  widget.viewModel.boardGamesFiltersStore,
                  widget.viewModel.analyticsService,
                  widget.viewModel.rateAndReviewService,
                ),
                SearchBoardGamesPage(viewModel: widget.viewModel.searchBoardGamesViewModel),
                PlaythroughsHistoryPage(viewModel: widget.viewModel.playthroughsHistoryViewModel),
                PlayersPage(viewModel: widget.viewModel.playersViewModel),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          controller: tabController,
          backgroundColor: AppColors.bottomTabBackgroundColor,
          top: -Dimensions.bottomTabTopHeight,
          items: const <TabItem>[
            TabItem<BottomTabIcon>(
              title: AppText.homePageGamesTabTitle,
              icon: BottomTabIcon(iconData: Icons.video_library),
              activeIcon: BottomTabIcon(iconData: Icons.video_library, isActive: true),
            ),
            TabItem<BottomTabIcon>(
              title: AppText.homePageSearchTabTitle,
              icon: BottomTabIcon(iconData: Icons.search),
              activeIcon: BottomTabIcon(iconData: Icons.search, isActive: true),
            ),
            TabItem<BottomTabIcon>(
              title: AppText.homePageGamesHistoryTabTitle,
              icon: BottomTabIcon(iconData: Icons.history),
              activeIcon: BottomTabIcon(iconData: Icons.history, isActive: true),
            ),
            TabItem<BottomTabIcon>(
              title: AppText.homePageGamesPlayersTabTitle,
              icon: BottomTabIcon(iconData: Icons.group),
              activeIcon: BottomTabIcon(iconData: Icons.group, isActive: true),
            ),
          ],
          initialActiveIndex: _initialTabIndex,
          activeColor: AppColors.accentColor,
          color: AppColors.inactiveBottomTabColor,
          onTap: (int tabIndex) => widget.viewModel.trackTabChange(tabIndex),
        ),
      ),
    );
  }
}
