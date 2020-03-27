import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/board_games/board_game_image_widget.dart';
import 'package:board_games_companion/widgets/board_games/game_detail_item_widget.dart';
import 'package:board_games_companion/widgets/player/player_score_widget.dart';
import 'package:board_games_companion/widgets/playthrough/calendar_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaythroughsPage extends StatefulWidget {
  final BoardGameDetails boardGameDetails;

  PlaythroughsPage(this.boardGameDetails);

  @override
  _PlaythroughsPageState createState() => _PlaythroughsPageState();
}

class _PlaythroughsPageState extends State<PlaythroughsPage> {
  static const double _minBoardGameImageHeight = 240;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Hero(
          tag:
              "${AnimationTags.boardGameImageHeroTag}${widget.boardGameDetails?.id}",
          child: BoardGameImage(
            boardGameDetails: widget.boardGameDetails,
            minImageHeight: _minBoardGameImageHeight,
          ),
        ),
        SizedBox(
          height: Dimensions.standardSpacing,
        ),
        Expanded(
          child: CarouselSlider(
            viewportFraction: 1.0,
            height: double.infinity,
            items: [1, 2, 3].map((item) {
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
                                GameDetailItem('443', 'day(s) ago'),
                                Divider(
                                  height: Dimensions.standardSpacing,
                                ),
                                GameDetailItem('10th', 'game'),
                                Divider(
                                  height: Dimensions.standardSpacing,
                                ),
                                GameDetailItem('1987', 'highscore'),
                                Divider(
                                  height: Dimensions.standardSpacing,
                                ),
                                GameDetailItem('120min', 'duration'),
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
            }).toList(),
          ),
        ),
      ],
    );
  }
}
