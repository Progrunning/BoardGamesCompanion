import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/app_theme.dart';
import '../common/dimensions.dart';
import '../services/analytics_service.dart';
import '../services/rate_and_review_service.dart';
import '../stores/board_games_store.dart';
import '../stores/user_store.dart';
import '../widgets/common/page_container_widget.dart';
import 'base_page_state.dart';
import 'games/games_page.dart';
import 'players/players_page.dart';
import 'search_board_games/search_board_games_page.dart';
import 'settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.analyticsService,
    required this.rateAndReviewService,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/home';

  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  static final GlobalKey<ScaffoldMessengerState> homePageGlobalKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> with SingleTickerProviderStateMixin {
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
        body: PageContainer(
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              Consumer2<BoardGamesStore, UserStore>(
                builder: (_, boardGamesStore, userStore, __) {
                  return GamesPage(
                    boardGamesStore,
                    userStore,
                    widget.analyticsService,
                    widget.rateAndReviewService,
                  );
                },
              ),
              SearchBoardGamesPage(analyticsService: widget.analyticsService),
              const PlayersPage(),
              const SettingsPage(),
            ],
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          controller: tabController,
          backgroundColor: AppTheme.bottomTabBackgroundColor,
          top: -Dimensions.bottomTabTopHeight,
          items: const <TabItem>[
            TabItem<_BottomTabIcon>(
              title: 'Games',
              icon: _BottomTabIcon(iconData: Icons.video_library),
              activeIcon: _BottomTabIcon(iconData: Icons.video_library, isActive: true),
            ),
            TabItem<_BottomTabIcon>(
              title: 'Search',
              icon: _BottomTabIcon(iconData: Icons.search),
              activeIcon: _BottomTabIcon(iconData: Icons.search, isActive: true),
            ),
            TabItem<_BottomTabIcon>(
              title: 'Players',
              icon: _BottomTabIcon(iconData: Icons.group),
              activeIcon: _BottomTabIcon(iconData: Icons.group, isActive: true),
            ),
            TabItem<_BottomTabIcon>(
              title: 'Settings',
              icon: _BottomTabIcon(iconData: Icons.settings),
              activeIcon: _BottomTabIcon(iconData: Icons.settings, isActive: true),
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

class _BottomTabIcon extends StatelessWidget {
  const _BottomTabIcon({
    required this.iconData,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: isActive ? AppTheme.activeBottomTabColor : AppTheme.inactiveBottomTabColor,
    );
  }
}
