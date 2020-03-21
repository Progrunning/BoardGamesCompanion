import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/widgets/board_game_image.dart';
import 'package:flutter/material.dart';

class GamesPlayed extends StatefulWidget {
  BoardGameDetails boardGameDetails;

  GamesPlayed(this.boardGameDetails);

  @override
  _GamesPlayedState createState() => _GamesPlayedState();
}

class _GamesPlayedState extends State<GamesPlayed> {
  @override
  Widget build(BuildContext context) {
    // final BoardGameDetails boardGameDetails =
    //     ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag:
                  "${AnimationTags.boardGameImageHeroTag}${widget.boardGameDetails?.id}",
              child: BoardGameImage(
                boardGameDetails: widget.boardGameDetails,
                minImageHeight: 300,
              ),
            )
          ],
        ),
      ),
    );
  }
}
