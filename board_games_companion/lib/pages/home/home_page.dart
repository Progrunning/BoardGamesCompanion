import 'package:board_games_companion/pages/games/games_view_model.dart';
import 'package:board_games_companion/pages/players/players_view_model.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../services/analytics_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/user_store.dart';
import '../../widgets/bottom_tab_icon.dart';
import '../../widgets/common/page_container_widget.dart';
import '../base_page_state.dart';
import '../games/games_page.dart';
import '../players/players_page.dart';
import '../search_board_games/search_board_games_page.dart';
import 'home_page_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.analyticsService,
    required this.rateAndReviewService,
    required this.gamesViewModel,
    required this.playersViewModel,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/home';

  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;
  final GamesViewModel gamesViewModel;
  final PlayersViewModel playersViewModel;

  static final GlobalKey<ScaffoldMessengerState> homePageGlobalKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  static const int _numberOfTabs = 3;
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
                Consumer2<GamesViewModel, UserStore>(
                  builder: (_, viewModel, userStore, __) {
                    return GamesPage(
                      viewModel,
                      userStore,
                      widget.analyticsService,
                      widget.rateAndReviewService,
                    );
                  },
                ),
                SearchBoardGamesPage(analyticsService: widget.analyticsService),
                PlayersPage(playersViewModel: widget.playersViewModel),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          controller: tabController,
          backgroundColor: AppTheme.bottomTabBackgroundColor,
          top: -Dimensions.bottomTabTopHeight,
          items: const <TabItem>[
            TabItem<BottomTabIcon>(
              title: 'Games',
              icon: BottomTabIcon(iconData: Icons.video_library),
              activeIcon: BottomTabIcon(iconData: Icons.video_library, isActive: true),
            ),
            TabItem<BottomTabIcon>(
              title: 'Search',
              icon: BottomTabIcon(iconData: Icons.search),
              activeIcon: BottomTabIcon(iconData: Icons.search, isActive: true),
            ),
            TabItem<BottomTabIcon>(
              title: 'Players',
              icon: BottomTabIcon(iconData: Icons.group),
              activeIcon: BottomTabIcon(iconData: Icons.group, isActive: true),
            ),
          ],
          initialActiveIndex: _initialTabIndex,
          activeColor: AppTheme.accentColor,
          color: AppTheme.inactiveBottomTabColor,
        ),
      ),
    );
  }
}
