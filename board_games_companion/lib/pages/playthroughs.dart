import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/widgets/common/cunsumer_future_builder_widget.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaythroughsPage extends StatelessWidget {
  final BoardGameDetails _boardGameDetails;
  final PlaythroughsStore _playthroughsStore;

  PlaythroughsPage(
    this._boardGameDetails,
    this._playthroughsStore,
  );

  static const double _minBoardGameImageHeight = 240;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // BoardGameImage(
        //   _boardGameDetails,
        //   minImageHeight: _minBoardGameImageHeight,
        // ),
        SizedBox(
          height: Dimensions.standardSpacing,
        ),
        Expanded(
          child: ConsumerFutureBuilder<List<Playthrough>, PlaythroughsStore>(
            future: _playthroughsStore.loadPlaythroughs(_boardGameDetails),
            success: (_, PlaythroughsStore store) {
              final hasPlaythroughs = store.playthroughs?.isNotEmpty ?? false;
              if (hasPlaythroughs) {
                store.playthroughs
                    .sort((a, b) => b.startDate?.compareTo(a.startDate));
                return CarouselSlider(
                  viewportFraction: .9,
                  enableInfiniteScroll: false,
                  height: double.infinity,
                  items: store.playthroughs
                      .asMap()
                      .map((index, playthough) {
                        return MapEntry(
                          index,
                          PlaythroughItem(
                            playthough,
                            store.playthroughs.length - index,
                            key: ValueKey(playthough.id),
                          ),
                        );
                      })
                      .values
                      .toList(),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.doubleStandardSpacing,
                ),
                child: Center(
                  child: Text(
                    'It looks like you haven\'t played this game yet',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
