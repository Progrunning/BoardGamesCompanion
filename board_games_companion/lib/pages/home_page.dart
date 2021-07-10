import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/app_theme.dart';
import '../common/constants.dart';
import '../extensions/page_controller_extensions.dart';
import '../stores/board_games_store.dart';
import '../stores/home_store.dart';
import '../stores/user_store.dart';
import '../utilities/navigator_helper.dart';
import '../widgets/common/bottom_tabs/custom_bottom_navigation_bar_item_widget.dart';
import '../widgets/common/icon_and_text_button.dart';
import '../widgets/common/page_container_widget.dart';
import 'base_page_state.dart';
import 'collections/collections_page.dart';
import 'players.dart';
import 'search_board_games.dart';
import 'settings/settings_page.dart';

class HomePage extends StatefulWidget {
  static final GlobalKey<ScaffoldState> homePageGlobalKey =
      GlobalKey<ScaffoldState>();
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final _addPlayerButton = IconAndTextButton(
      icon: Icons.add,
      onPressed: () => _navigateToAddPlayerPage(context),
    );

    return Scaffold(
      key: HomePage.homePageGlobalKey,
      body: PageContainer(
        child: PageView(
          controller: pageController,
          children: <Widget>[
            Consumer2<BoardGamesStore, UserStore>(
              builder: (_, boardGamesStore, userStore, __) {
                return CollectionsPage(
                  boardGamesStore,
                  userStore,
                );
              },
            ),
            SearchBoardGamesPage(),
            PlayersPage(),
            SettingsPage(),
          ],
          onPageChanged: (pageIndex) {
            final homeStore = Provider.of<HomeStore>(
              context,
              listen: false,
            );
            homeStore.boardGamesPageIndex = pageIndex;
          },
        ),
      ),
      floatingActionButton: Consumer<HomeStore>(
        builder: (_, homeStore, __) {
          switch (homeStore.boardGamesPageIndex) {
            case Constants.PlayersTabIndex:
              return _addPlayerButton;
            default:
              return Container();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Consumer<HomeStore>(
        builder: (_, homeStore, __) {
          return BottomNavigationBar(
            backgroundColor: AppTheme.bottomTabBackgroundColor,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              CustomBottomNavigationBarItem('Collection', Icons.grid_on),
              CustomBottomNavigationBarItem('Search', Icons.search),
              CustomBottomNavigationBarItem('Players', Icons.group),
              CustomBottomNavigationBarItem('Settings', Icons.settings),
            ],
            currentIndex: homeStore.boardGamesPageIndex,
            onTap: (pageIndex) {
              pageController.animateToTab(pageIndex);
            },
          );
        },
      ),
    );
  }

  Future<void> _navigateToAddPlayerPage(BuildContext context) async {
    await NavigatorHelper.navigateToCreatePlayerPage(context);
  }
}
