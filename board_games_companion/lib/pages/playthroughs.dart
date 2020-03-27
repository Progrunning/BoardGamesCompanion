import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_image_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class PlaythroughsPage extends StatelessWidget {
  final BoardGameDetails boardGameDetails;

  PlaythroughsPage(this.boardGameDetails);

  static const double _minBoardGameImageHeight = 240;

  @override
  Widget build(BuildContext context) {
    final _store = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );
    _store.loadPlaythroughs(boardGameDetails);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Hero(
          tag: "${AnimationTags.boardGameImageHeroTag}${boardGameDetails?.id}",
          child: BoardGameImage(
            boardGameDetails: boardGameDetails,
            minImageHeight: _minBoardGameImageHeight,
          ),
        ),
        SizedBox(
          height: Dimensions.standardSpacing,
        ),
        Expanded(
          child: Consumer<PlaythroughsStore>(
            builder: (_, store, __) {
              if (store.loadDataState == LoadDataState.Loaded) {
                final hasPlaythroughs = store.playthroughs?.isNotEmpty ?? false;
                if (hasPlaythroughs) {
                  return CarouselSlider(
                    viewportFraction: 1.0,
                    height: double.infinity,
                    items: store.playthroughs.map((playthough) {
                      return PlaythroughItem();
                    }).toList(),
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
              } else if (store.loadDataState == LoadDataState.Error) {
                return Center(
                  child: Text(
                      ' Oops, we ran into issue with retrieving your data. Please contact support at feedback@progrunning.net'),
                );
              }

              return LoadingIndicator();
            },
          ),
        ),
      ],
    );
  }
}
