import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/widgets/player/player_score_widget.dart';
import 'package:board_games_companion/widgets/playthrough/calendar_card.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_item_detail_widget.dart';
import 'package:flutter/material.dart';

class PlaythroughItem extends StatelessWidget {
  const PlaythroughItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CalendarCard(),
              SizedBox(
                height: Dimensions.standardSpacing,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      PlaythroughItemDetail('443', 'day(s) ago'),
                      Divider(
                        height: Dimensions.standardSpacing,
                      ),
                      PlaythroughItemDetail('10th', 'game'),
                      Divider(
                        height: Dimensions.standardSpacing,
                      ),
                      PlaythroughItemDetail('1987', 'highscore'),
                      Divider(
                        height: Dimensions.standardSpacing,
                      ),
                      PlaythroughItemDetail('120min', 'duration'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: Dimensions.standardSpacing,
          ),
          Expanded(
            child: ListView.separated(
                itemCount: 4,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: Dimensions.standardSpacing,
                  );
                },
                itemBuilder: (context, index) {
                  return PlayerScore(
                    medal: MedalEnum.Bronze,
                  );
                }),
          )
        ],
      ),
    );
  }
}
