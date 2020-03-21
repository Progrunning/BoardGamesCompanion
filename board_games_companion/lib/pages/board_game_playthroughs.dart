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
  static const int _startNewPlaythroughPageIndex = 1;

  int _selectedIndex = _playthroughsPageIndex;

  @override
  Widget build(BuildContext context) {
    Widget _selectedTabbedPage;
    switch (_selectedIndex) {
      case _playthroughsPageIndex:
        _selectedTabbedPage = Playthrough(widget.boardGameDetails);
        break;
      case _startNewPlaythroughPageIndex:
        _selectedTabbedPage = StartNewPlaythrough();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Playthroughs'),
      ),
      body: _selectedTabbedPage,
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
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
