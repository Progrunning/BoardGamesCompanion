import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../common/dimensions.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/playthrough.dart';
import '../stores/playthroughs_store.dart';
import '../widgets/common/cunsumer_future_builder_widget.dart';
import '../widgets/playthrough/playthrough_item_widget.dart';

class PlaythroughsPage extends StatefulWidget {
  final BoardGameDetails boardGameDetails;
  final PlaythroughsStore playthroughsStore;

  const PlaythroughsPage(
    this.boardGameDetails,
    this.playthroughsStore, {
    Key key,
  }) : super(key: key);

  @override
  _PlaythroughsPageState createState() => _PlaythroughsPageState();
}

class _PlaythroughsPageState extends State<PlaythroughsPage> {
  static const double _maxPlaythroughItemHeight = 300;

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
            future: widget.playthroughsStore
                .loadPlaythroughs(widget.boardGameDetails),
            success: (_, PlaythroughsStore store) {
              final hasPlaythroughs = store.playthroughs?.isNotEmpty ?? false;
              if (hasPlaythroughs) {
                store.playthroughs
                    .sort((a, b) => b.startDate?.compareTo(a.startDate));
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return SizedBox(
                      height: math.max(_maxPlaythroughItemHeight,
                          MediaQuery.of(context).size.height / 3),
                      child: PlaythroughItem(
                        store.playthroughs[index],
                        store.playthroughs.length - index,
                        key: ValueKey(store.playthroughs[index].id),
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(
                      height: Dimensions.doubleStandardSpacing,
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
