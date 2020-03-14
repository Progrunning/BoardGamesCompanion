import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/widgets/board_game_widget.dart';
import 'package:flutter/material.dart';

class AddBoardGames extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBoardGames();
}

class _AddBoardGames extends State<AddBoardGames> {
  final BoardGamesGeekService _boardGamesGeekService = BoardGamesGeekService();

  List<BoardGame> _hotBoardGames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Board Games'),
        ),
        body: FutureBuilder(
          future: _boardGamesGeekService.retrieveHot(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data is List<BoardGame>) {
                return ListView.builder(
                    itemCount: (snapshot.data as List<BoardGame>).length,
                    itemBuilder: (BuildContext context, int index) {
                      return BoardGameWidget(
                        boardGame: snapshot.data[index],
                      );
                    });
              }
            } else if (snapshot.hasError) {
              return Center(child: Text('Oops, something went wrong'));
            }

            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
