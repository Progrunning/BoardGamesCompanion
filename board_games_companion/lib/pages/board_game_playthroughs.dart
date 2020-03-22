import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/pages/playthroughs.dart';
import 'package:board_games_companion/pages/start_new_playthrough.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:flutter/material.dart';

class BoardGamePlaythroughsPage extends StatefulWidget {
  final BoardGameDetails boardGameDetails;

  BoardGamePlaythroughsPage(this.boardGameDetails, {Key key}) : super(key: key);

  @override
  _BoardGamePlaythroughsPageState createState() => _BoardGamePlaythroughsPageState();
}

class _BoardGamePlaythroughsPageState extends State<BoardGamePlaythroughsPage> {
  static const int _playthroughsPageIndex = 0;
  static const int _startNewGamePageIndex = 1;

  int _selectedPageIndex = _playthroughsPageIndex;
  double _startNewGameButtonOpacity = Styles.transparentOpacity;
  PageController _pageController =
      PageController(initialPage: _playthroughsPageIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playthroughs'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (pageIndex) {
          setState(() {
            _selectedPageIndex = pageIndex;
            switch (pageIndex) {
              case _playthroughsPageIndex:
                _startNewGameButtonOpacity = Styles.transparentOpacity;
                break;
              case _startNewGamePageIndex:
                _startNewGameButtonOpacity = Styles.opaqueOpacity;
                break;
            }
          });
        },
        children: <Widget>[
          PlaythroughsPage(widget.boardGameDetails),
          StartNewPlaythroughPage(),
        ],
      ),
      floatingActionButton: Opacity(
        opacity: _startNewGameButtonOpacity,
        child: IconAndTextButton(
          title: 'Start New Game',
          icon: Icons.play_arrow,
          onPressed: _onStartNewGame,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            title: Text('New Game'),
          ),
        ],
        onTap: _onTabChanged,
        currentIndex: _selectedPageIndex,
      ),
    );
  }

  void _onTabChanged(int index) {
    this._pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
  }

  void _onStartNewGame() {

  }
}
