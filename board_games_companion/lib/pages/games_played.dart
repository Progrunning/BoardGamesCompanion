import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/widgets/board_game_image.dart';
import 'package:board_games_companion/widgets/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GamesPlayed extends StatefulWidget {
  final BoardGameDetails boardGameDetails;

  GamesPlayed(this.boardGameDetails);

  @override
  _GamesPlayedState createState() => _GamesPlayedState();
}

class _GamesPlayedState extends State<GamesPlayed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Hero(
            tag:
                "${AnimationTags.boardGameImageHeroTag}${widget.boardGameDetails?.id}",
            child: BoardGameImage(
              boardGameDetails: widget.boardGameDetails,
            ),
          ),
          SizedBox(
            height: Dimensions.standardSpacing,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.standardSpacing),
              child: ListView.separated(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: Dimensions.standardSpacing,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        CalendarCard(),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
