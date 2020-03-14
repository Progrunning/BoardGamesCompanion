import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/widgets/board_game_widget.dart';
import 'package:flutter/material.dart';

class BoardGamesPage extends StatefulWidget {
  BoardGamesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BoardGamesPageState createState() => _BoardGamesPageState();
}

class _BoardGamesPageState extends State<BoardGamesPage> {
  List<BoardGame> _boardGames;

  void _navigateToSearchBoardGamesPage() {
    Navigator.pushNamed(context, Routes.addBoardGames);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasBoardGames = _boardGames?.isEmpty ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: hasBoardGames
          ? Center(
              child: Text(
                  'It looks empty here, try adding a new board game to your collection'))
          : ListView.builder(
              itemCount: 2, // hasBoardGames ? _boardGames.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return BoardGameWidget();
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSearchBoardGamesPage,
        tooltip: 'Add a board game',
        child: Icon(Icons.add),
      ),
    );
  }
}
