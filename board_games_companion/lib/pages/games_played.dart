import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/widgets/board_game_image_widget.dart';
import 'package:board_games_companion/widgets/calendar_card.dart';
import 'package:board_games_companion/widgets/game_detail_item_widget.dart';
import 'package:board_games_companion/widgets/players_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GamesPlayed extends StatefulWidget {
  final BoardGameDetails boardGameDetails;

  GamesPlayed(this.boardGameDetails);

  @override
  _GamesPlayedState createState() => _GamesPlayedState();
}

class _GamesPlayedState extends State<GamesPlayed> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games Played'),
      ),
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
                              return Player();
                            }),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Games Played'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            title: Text('New Game'),
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
