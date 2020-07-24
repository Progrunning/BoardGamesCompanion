import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/pages/collections.dart';
import 'package:board_games_companion/pages/players.dart';
import 'package:board_games_companion/pages/search_board_games.dart';
import 'package:board_games_companion/pages/settings.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/home_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/bottom_tabs/custom_bottom_navigation_bar_item_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/extensions/page_controller_extensions.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final PageController _pageController = PageController();

  static final GlobalKey<ScaffoldState> homePageGlobalKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _addPlayerButton = IconAndTextButton(
      icon: Icons.add,
      onPressed: () => _navigateToAddPlayerPage(context),
    );

    return Scaffold(
      key: homePageGlobalKey,
      body: PageContainer(
        child: PageView(
          controller: _pageController,
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
              _pageController.animateToTab(pageIndex);
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
