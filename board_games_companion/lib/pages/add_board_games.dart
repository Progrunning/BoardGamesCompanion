import 'package:async/async.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/widgets/board_game_search_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBoardGamesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBoardGamesPageState();
}

class _AddBoardGamesPageState extends State<AddBoardGamesPage> {
  final int _numberOfBoardGameColumns = 3;

  AsyncMemoizer _memoizer;
  bool _isRefreshing;

  @override
  void initState() {
    super.initState();

    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    final _boardGamesGeekService = Provider.of<BoardGamesGeekService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Board Games'),
        ),
        body: FutureBuilder(
          future: _memoizer.runOnce(() async {
            return _boardGamesGeekService.retrieveHot();
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _isRefreshing = false;

              if (snapshot.data is List<BoardGame>) {
                return GridView.count(
                  crossAxisCount: _numberOfBoardGameColumns,
                  children: List.generate(
                    (snapshot.data as List<BoardGame>).length,
                    (int index) {
                      return BoardGameSearchItemWidget(
                        boardGame: snapshot.data[index],
                      );
                    },
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.standardSpacing),
                      child: Center(
                        child: Text(
                            'We couldn\'t retrieve any board games. Check your Internet connectivity and try again.'),
                      ),
                    ),
                    SizedBox(height: Dimensions.standardSpacing),
                    RaisedButton(
                      child: Text('Refresh'),
                      onPressed: () {
                        setState(() {
                          _isRefreshing = true;
                        });
                      },
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError && !_isRefreshing) {
              return Center(child: Text('Oops, something went wrong'));
            }

            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
