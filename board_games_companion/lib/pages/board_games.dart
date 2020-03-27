import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGamesPage extends StatefulWidget {
  final BoardGamesStore _boardGamesStore;

  BoardGamesPage(this._boardGamesStore, {Key key}) : super(key: key);

  @override
  _BoardGamesPageState createState() => _BoardGamesPageState();
}

class _BoardGamesPageState extends State<BoardGamesPage> {
  @override
  void initState() {
    super.initState();

    widget._boardGamesStore.loadBoardGames();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._boardGamesStore.loadDataState == LoadDataState.Loaded) {
      if (widget._boardGamesStore.boardGames?.isEmpty ?? true) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
          child: Center(
            child: Text(
                'It looks empty here, try adding a new board game to your collection'),
          ),
        );
      }

      widget._boardGamesStore.boardGames
          .sort((a, b) => a.name?.compareTo(b.name));

      return SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(Dimensions.standardSpacing),
          itemCount: widget._boardGamesStore.boardGames.length,
          itemBuilder: (BuildContext context, int index) {
            return ChangeNotifierProvider<BoardGameDetails>.value(
              value: widget._boardGamesStore.boardGames[index],
              child: BoardGameWidget(),
            );
          },
        ),
      );
    } else if (widget._boardGamesStore.loadDataState == LoadDataState.Error) {
      return Center(
        child: Text(
            ' Oops, we ran into issue with retrieving your data. Please contact support at feedback@progrunning.net'),
      );
    }

    return Center(child: CircularProgressIndicator());
  }
}
