import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/pages/board_games.dart';
import 'package:board_games_companion/pages/players.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/home_store.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final PageController _pageController = PageController();

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
      builder: (_, homeStore, __) {
        return Scaffold(
          body: PageView(
            controller: _pageController,
            children: <Widget>[
              Consumer<BoardGamesStore>(
                builder: (_, boardGamesStore, __) {
                  return BoardGamesPage(boardGamesStore);
                },
              ),
              Consumer<PlayersStore>(
                builder: (_, playersStore, __) {
                  return PlayersPage(playersStore);
                },
              ),
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
    await NavigatorHelper.navigateToCreatePlayerPage(context);
  }
}
