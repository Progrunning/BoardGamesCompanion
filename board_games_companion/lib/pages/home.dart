import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/pages/board_games.dart';
import 'package:board_games_companion/pages/players.dart';
import 'package:board_games_companion/stores/home_store.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final PageController _pageController = PageController();
  final _boardGamesPage = BoardGamesPage();
  final _playersPage = PlayersPage();

  @override
  Widget build(BuildContext context) {
    final _addBoardGameButton = IconAndTextButton(
      title: 'Add Game',
      icon: Icons.add,
      onPressed: () => _navigateToAddBoardGamesPage(context),
    );
    final _addPlayerButton = IconAndTextButton(
      title: 'Add Player',
      icon: Icons.add,
      onPressed: () => _navigateToAddPlayerPage(context),
    );

    return Consumer<HomeStore>(
      builder: (context, homeStore, child) {
        return Scaffold(
          body: PageView(
            controller: _pageController,
            children: <Widget>[
              _boardGamesPage,
              _playersPage,
            ],
            onPageChanged: (pageIndex) {
              homeStore.updateSelectedPageIndex(pageIndex);
            },
          ),
          floatingActionButton: homeStore.boardGamesPageIndex == 0
              ? _addBoardGameButton
              : _addPlayerButton,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.games),
                title: Text('Games Collection'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Players'),
              ),
            ],
            currentIndex: homeStore.boardGamesPageIndex,
            onTap: (pageIndex) {
              _pageController.animateToPage(
                pageIndex,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _navigateToAddBoardGamesPage(BuildContext context) async {
    await Navigator.pushNamed(context, Routes.addBoardGames);
  }

  Future<void> _navigateToAddPlayerPage(BuildContext context) async {
    await Navigator.pushNamed(context, Routes.createEditPlayer);
  }
}
