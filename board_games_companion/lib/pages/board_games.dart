import 'package:board_games_companion/common/routes.dart';
import 'package:flutter/material.dart';

class BoardGamesPage extends StatefulWidget {
  BoardGamesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BoardGamesPageState createState() => _BoardGamesPageState();
}

class _BoardGamesPageState extends State<BoardGamesPage> {
  void _navigateToSearchBoardGamesPage() {
    Navigator.pushNamed(context, Routes.addBoardGames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSearchBoardGamesPage,
        tooltip: 'Add a board game',
        child: Icon(Icons.add),
      ),
    );
  }
}
