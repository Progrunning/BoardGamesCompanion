import 'package:async/async.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/widgets/board_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGamesPage extends StatefulWidget {
  BoardGamesPage({Key key}) : super(key: key);

  @override
  _BoardGamesPageState createState() => _BoardGamesPageState();
}

class _BoardGamesPageState extends State<BoardGamesPage> {
  AsyncMemoizer _memoizer;
  BoardGamesService _boardGamesService;

  @override
  void initState() {
    super.initState();

    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    _boardGamesService = Provider.of<BoardGamesService>(context);

    return FutureBuilder(
      future: _memoizer.runOnce(() async {
        return _boardGamesService.retrieveBoardGames();
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var boardGames = (snapshot.data as List<BoardGameDetails>);
          if (boardGames?.isEmpty ?? true) {
            return Padding(
              padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Center(
                child: Text(
                    'It looks empty here, try adding a new board game to your collection'),
              ),
            );
          }

          boardGames.sort((a, b) => a.name?.compareTo(b.name));

          return SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.all(Dimensions.standardSpacing),
              itemCount: boardGames.length,
              itemBuilder: (BuildContext context, int index) {
                return BoardGameWidget(boardGames[index]);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                ' Oops, we ran into issue with retrieving your data. Please contact support at feedback@progrunning.net'),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    _boardGamesService?.closeBox(HiveBoxes.BoardGames);

    super.dispose();
  }
}
