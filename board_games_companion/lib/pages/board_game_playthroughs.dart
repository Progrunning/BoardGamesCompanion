import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/pages/playthroughs.dart';
import 'package:board_games_companion/pages/start_new_playthrough.dart';
import 'package:flutter/material.dart';

class BoardGamePlaythroughs extends StatefulWidget {
  final BoardGameDetails boardGameDetails;

  BoardGamePlaythroughs(this.boardGameDetails, {Key key}) : super(key: key);

  @override
  _BoardGamePlaythroughsState createState() => _BoardGamePlaythroughsState();
}

class _BoardGamePlaythroughsState extends State<BoardGamePlaythroughs> {
  static const int _playthroughsPageIndex = 0;

  int _selectedPageIndex = _playthroughsPageIndex;
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
          });
        },
        children: <Widget>[
          Playthrough(widget.boardGameDetails),
          StartNewPlaythrough(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Games Played'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            title: Text('New Game'),
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedPageIndex,
      ),
    );
  }

  void _onItemTapped(int index) {
    this._pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
  }
}
