import 'package:async/async.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/pages/board_game_playthroughs.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/widgets/board_game_widget.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:flutter/material.dart';

class BoardGamesPage extends StatefulWidget {
  BoardGamesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BoardGamesPageState createState() => _BoardGamesPageState();
}

class _BoardGamesPageState extends State<BoardGamesPage> {
  BoardGamesService _boardGamesService = BoardGamesService();

  AsyncMemoizer _memoizer;

  Future<void> _navigateToSearchBoardGamesPage() async {
    await Navigator.pushNamed(context, Routes.addBoardGames);
    // MK Ensure that the board games collection list refreshes
    _memoizer = new AsyncMemoizer();
  }

  Future<void> _navigateToGamesPlayedPage(
      BoardGameDetails boardGameDetails) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return BoardGamePlaythroughs(boardGameDetails);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
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

            return ListView.builder(
              padding: EdgeInsets.all(Dimensions.standardSpacing),
              itemCount: boardGames.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    _navigateToGamesPlayedPage(boardGames[index]);
                  },
                  child: BoardGameWidget(
                    boardGameDetails: boardGames[index],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    ' Oops, we ran into issue with retrieving your data. Please contact support at feedback@progrunning.net'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: IconAndTextButton(
        title: 'Add Game',
        icon: Icons.add,
        onPressed: _navigateToSearchBoardGamesPage,
      ),
    );
  }

  @override
  void dispose() {
    _boardGamesService.closeBox(HiveBoxes.BoardGames);

    super.dispose();
  }
}
