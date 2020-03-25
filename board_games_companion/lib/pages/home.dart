import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/pages/board_games.dart';
import 'package:board_games_companion/pages/players.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _boardGamesPageIndex = 0;

  final PageController _pageController = PageController(
    initialPage: _boardGamesPageIndex,
  );

  int _currentTabPageIndex = _boardGamesPageIndex;

  BoardGamesPage _boardGamesPage;
  PlayersPage _playersPage;
  Widget _addBoardGameButton;
  Widget _addPlayerButton;

  @override
  void initState() {
    super.initState();

    _boardGamesPage = BoardGamesPage();
    _playersPage = PlayersPage();

    _addBoardGameButton = IconAndTextButton(
      title: 'Add Game',
      icon: Icons.add,
      onPressed: _navigateToAddBoardGamesPage,
    );
    _addPlayerButton = IconAndTextButton(
      title: 'Add Player',
      icon: Icons.add,
      onPressed: _navigateToAddPlayerPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          _boardGamesPage,
          _playersPage,
        ],
        onPageChanged: (pageIndex) {
          setState(() {
            _currentTabPageIndex = pageIndex;
          });
        },
      ),
      floatingActionButton: _currentTabPageIndex == _boardGamesPageIndex
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
        currentIndex: _currentTabPageIndex,
        onTap: (pageIndex) {
          _pageController.animateToPage(
            pageIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Future<void> _navigateToAddBoardGamesPage() async {
    await Navigator.pushNamed(context, Routes.addBoardGames);
    // MK Ensure that the board games collection list refreshes
    _boardGamesPage = BoardGamesPage();
    setState(() {});
  }

  Future<void> _navigateToAddPlayerPage() async {
    await Navigator.pushNamed(context, Routes.createEditPlayer);
    // MK Ensure that players list refreshes
    _playersPage = PlayersPage();
  }
}
