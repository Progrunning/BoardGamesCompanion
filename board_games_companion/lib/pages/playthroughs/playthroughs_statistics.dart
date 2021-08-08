import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/dimensions.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/int_extensions.dart';
import '../../models/board_game_statistics.dart';
import '../../models/hive/board_game_details.dart';
import '../../stores/playthrough_statistics_store.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/scores/player_score_widget.dart';
import '../../widgets/playthrough/calendar_card.dart';

class PlaythroughsStatistics extends StatelessWidget {
  const PlaythroughsStatistics({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playthroughStatisticsStore = Provider.of<PlaythroughStatisticsStore>(context);

    return Consumer<BoardGameDetails>(
      builder: (_, boardGameDetails, __) {
        final boardGameStatistics =
            playthroughStatisticsStore.boardGamesStatistics[boardGameDetails.id];
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.standardSpacing,
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _LastWinner(
                        boardGameStatistics: boardGameStatistics,
                      ),
                      const SizedBox(
                        height: Dimensions.standardSpacing,
                      ),
                      _LastTimePlayed(
                        boardGameStatistics: boardGameStatistics,
                      ),
                      const SizedBox(
                        height: Dimensions.doubleStandardSpacing,
                      ),
                      _Statistics(
                        boardGameStatistics: boardGameStatistics,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LastWinner extends StatelessWidget {
  const _LastWinner({
    @required this.boardGameStatistics,
    Key key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const ItemPropertyTitle('Last winner'),
        const SizedBox(
          height: Dimensions.halfStandardSpacing,
        ),
        PlayerScore(
          boardGameStatistics?.lastWinner,
        ),
      ],
    );
  }
}

class _LastTimePlayed extends StatelessWidget {
  const _LastTimePlayed({
    @required this.boardGameStatistics,
    Key key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const ItemPropertyTitle('Last played'),
        const SizedBox(
          height: Dimensions.halfStandardSpacing,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CalendarCard(
              boardGameStatistics?.lastPlayed,
            ),
            const SizedBox(
              width: Dimensions.standardSpacing,
            ),
            Expanded(
              child: ItemPropertyValue(
                boardGameStatistics?.lastPlayed?.toDaysAgo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Statistics extends StatelessWidget {
  const _Statistics({
    @required this.boardGameStatistics,
    Key key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _StatisticsItem(
          value: boardGameStatistics?.numberOfGamesPlayed?.toString() ?? '-',
          icon: Icons.insert_chart,
          iconColor: Theme.of(context).accentColor,
          subtitle: 'Played games',
        ),
        _StatisticsItem(
          value: boardGameStatistics?.highscore?.toString() ?? '-',
          icon: Icons.show_chart,
          iconColor: Colors.red,
          subtitle: 'Highscore',
        ),
        _StatisticsItem(
          value: boardGameStatistics?.averagePlaytimeInSeconds?.toAverageDuration('-') ?? '-',
          icon: Icons.hourglass_empty,
          iconColor: Colors.blue,
          subtitle: 'Ave. playtime',
        ),
      ],
    );
  }
}


class _StatisticsItem extends StatelessWidget {
  const _StatisticsItem({
    Key key,
    @required this.icon,
    @required this.value,
    @required this.subtitle,
    this.iconColor,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: iconColor ?? IconTheme.of(context).color,
            ),
            const SizedBox(
              width: Dimensions.halfStandardSpacing,
            ),
            ItemPropertyValue(value ?? ''),
          ],
        ),
        ItemPropertyTitle(subtitle ?? '')
      ],
    );
  }
}
