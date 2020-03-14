import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:flutter/material.dart';

class BoardGameWidget extends StatelessWidget {
  final BoardGame boardGame;

  BoardGameWidget({Key key, this.boardGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.standardSpacing),
      // decoration: BoxDecoration(color: Colors.red),
      child: Card(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              // TODO MK Add a placeholder in case there's no image
              // TODO MK Handle no internet situation
              child: Image.network(
                boardGame?.thumbnailUrl ?? 'https://picsum.photos/250?image=9',
              ),
            ),
            Expanded(
                child: Stack(
              children: <Widget>[Text(boardGame?.name ?? '')],
            )),
          ],
        ),
      ),
    );
  }
}
