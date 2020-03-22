import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/pages/board_games.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _boardGamesPageIndex = 0;
  static const int _playersPageIndex = 1;

  final PageController _pageController = PageController(
    initialPage: _boardGamesPageIndex,
  );

  int _currentTabPageIndex = _boardGamesPageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          BoardGamesPage(),
        ],
        onPageChanged: (pageIndex) {
          setState(() {
            _currentTabPageIndex = pageIndex;
          });
        },
      ),
      floatingActionButton: IconAndTextButton(
        title: 'Add Game',
        icon: Icons.add,
        onPressed: _navigateToSearchBoardGamesPage,
      ),
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

  Future<void> _navigateToSearchBoardGamesPage() async {
    await Navigator.pushNamed(context, Routes.addBoardGames);
    // MK Ensure that the board games collection list refreshes
    // _memoizer = new AsyncMemoizer();
  }
}
