import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/widgets/board_game_widget.dart';
import 'package:flutter/material.dart';

class AddBoardGames extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBoardGames();
}

class _AddBoardGames extends State<AddBoardGames> {
  final BoardGamesGeekService _boardGamesGeekService =
      new BoardGamesGeekService();

  List<BoardGame> _hotBoardGames;

  @override
  void initState() {
    super.initState();

    _retrieveHotBoardGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Board Games'),
      ),
      body: ListView.builder(
          itemCount: _hotBoardGames?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return BoardGameWidget(
              boardGame: _hotBoardGames[index],
            );
          }),
    );
  }

  void _retrieveHotBoardGames() async {
    _hotBoardGames = await _boardGamesGeekService.retrieveHot();
    setState(() {
      
    });
  }
}
