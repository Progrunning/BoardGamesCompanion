import 'dart:math' as math;

import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/widgets/common/cunsumer_future_builder_widget.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaythroughsPage extends StatelessWidget {
  final BoardGameDetails _boardGameDetails;
  final PlaythroughsStore _playthroughsStore;

  PlaythroughsPage(
    this._boardGameDetails,
    this._playthroughsStore,
  );

  static const double _maxPlaythroughItemHeight = 360;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
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
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return SizedBox(
                      height: math.max(_maxPlaythroughItemHeight,
                          MediaQuery.of(context).size.height / 2),
                      child: PlaythroughItem(
                        store.playthroughs[index],
                        store.playthroughs.length - index,
                        key: ValueKey(store.playthroughs[index].id),
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(
                      height: 0,
                    );
                  },
                  itemCount: store.playthroughs.length,
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
