import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/animation_tags.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/int_extensions.dart';
import '../../models/board_game_statistics.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/player.dart';
import '../../stores/playthrough_statistics_store.dart';
import '../../widgets/board_games/board_game_image.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/player_score_rank_avatar.dart';

class PlaythroughStatistcsPage extends StatefulWidget {
  const PlaythroughStatistcsPage({
    required this.boardGameDetails,
    required this.collectionType,
    Key? key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final CollectionType collectionType;

  @override
  _PlaythroughStatistcsPageState createState() => _PlaythroughStatistcsPageState();
}

class _PlaythroughStatistcsPageState extends State<PlaythroughStatistcsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          floating: false,
          expandedHeight: Constants.BoardGameDetailsImageHeight,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            centerTitle: true,
            background: BoardGameImage(
              widget.boardGameDetails,
              minImageHeight: Constants.BoardGameDetailsImageHeight,
              heroTag: '${AnimationTags.boardGamePlaythroughImageHeroTag}_${widget.collectionType}',
            ),
          ),
        ),
        SliverPadding(
          sliver: SliverToBoxAdapter(
            child: ChangeNotifierProvider.value(
              value: widget.boardGameDetails,
              child: const _Statistics(),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.standardSpacing,
          ),
        )
      ],
    );
  }
}

class _Statistics extends StatelessWidget {
  const _Statistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playthroughStatisticsStore = Provider.of<PlaythroughStatisticsStore>(context);

    return Consumer<BoardGameDetails>(
      builder: (_, boardGameDetails, __) {
        final boardGameStatistics =
            playthroughStatisticsStore.boardGamesStatistics[boardGameDetails.id];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  ItemPropertyTitle(AppText.playthroughsStatisticsPageLastWinnerSectionTitle),
                  Expanded(child: SizedBox.shrink()),
                  ItemPropertyTitle(AppText.playthroughsStatisticsPageLastTimePlayedSectionTitle),
                ],
              ),
              const SizedBox(height: Dimensions.halfStandardSpacing),
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _LastWinnerAvatar(boardGameStatistics: boardGameStatistics),
                      const SizedBox(width: Dimensions.standardSpacing),
                      _LastWinnerText(boardGameStatistics: boardGameStatistics),
                    ],
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  _LastTimePlayed(boardGameStatistics: boardGameStatistics),
                ],
              ),
              const SizedBox(height: Dimensions.doubleStandardSpacing),
              const ItemPropertyTitle(AppText.playthroughsStatisticsPageQuickStatsSectionTitle),
              const SizedBox(height: Dimensions.halfStandardSpacing),
              _QuickStats(boardGameStatistics: boardGameStatistics),
              if (boardGameStatistics?.topScoreres?.isNotEmpty ?? false) ...<Widget>[
                const SizedBox(height: Dimensions.doubleStandardSpacing),
                const ItemPropertyTitle(AppText.playthroughsStatisticsPageTopFiveSectionTitle),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                SizedBox(
                  height: 140,
                  child: _TopScores(boardGameStatistics: boardGameStatistics!),
                ),
              ],
              if (boardGameStatistics?.playerCountPercentage?.isNotEmpty ?? false) ...<Widget>[
                const SizedBox(height: Dimensions.doubleStandardSpacing),
                const ItemPropertyTitle(
                    AppText.playthroughsStatisticsPagePlayerCountPercentageSectionTitle),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _PlayerCountPercentageChart(boardGameStatistics: boardGameStatistics!),
                const SizedBox(height: Dimensions.doubleStandardSpacing),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PlayerCountPercentageChart extends StatefulWidget {
  const _PlayerCountPercentageChart({
    required this.boardGameStatistics,
    Key? key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  State<_PlayerCountPercentageChart> createState() => _PlayerCountPercentageChartState();
}

class _PlayerCountPercentageChartState extends State<_PlayerCountPercentageChart> {
  late final Map<int, Color> playerCountChartColor;

  @override
  void initState() {
    super.initState();

    playerCountChartColor = {};
    int i = 0;
    for (final MapEntry<int, double> playeCountPercentage
        in widget.boardGameStatistics.playerCountPercentage!.entries) {
      playerCountChartColor[playeCountPercentage.key] =
          AppTheme.chartColorPallete[i++ % AppTheme.chartColorPallete.length];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 160,
          width: 160,
          child: PieChart(
            PieChartData(
              sections: <PieChartSectionData>[
                for (final MapEntry<int, double> playeCountPercentage
                    in widget.boardGameStatistics.playerCountPercentage!.entries)
                  PieChartSectionData(
                    value: playeCountPercentage.value,
                    title: '${(playeCountPercentage.value * 100).toStringAsFixed(0)}%',
                    color: playerCountChartColor[playeCountPercentage.key],
                  ),
              ],
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (final MapEntry<int, double> playeCountPercentage
                in widget.boardGameStatistics.playerCountPercentage!.entries)
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.standardSpacing),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: playerCountChartColor[playeCountPercentage.key],
                      ),
                    ),
                    const SizedBox(width: Dimensions.halfStandardSpacing),
                    Text(
                        '${playeCountPercentage.key} player${playeCountPercentage.key > 1 ? "s" : ""}'),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _LastWinnerText extends StatelessWidget {
  const _LastWinnerText({
    Key? key,
    required this.boardGameStatistics,
  }) : super(key: key);

  final BoardGameStatistics? boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Text(
              'won with',
              style: TextStyle(
                fontSize: Dimensions.smallFontSize,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          TextSpan(
            text: ' ${boardGameStatistics?.lastWinner?.score.value ?? '-'} ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Text(
              'points',
              style: TextStyle(
                fontSize: Dimensions.smallFontSize,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
    );
  }
}

class _LastWinnerAvatar extends StatelessWidget {
  const _LastWinnerAvatar({
    required this.boardGameStatistics,
    Key? key,
  }) : super(key: key);

  final BoardGameStatistics? boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.smallPlayerAvatarSize,
      width: Dimensions.smallPlayerAvatarSize,
      child: PlayerAvatar(boardGameStatistics?.lastWinner?.player, useHeroAnimation: false),
    );
  }
}

class _LastTimePlayed extends StatelessWidget {
  const _LastTimePlayed({
    required this.boardGameStatistics,
    Key? key,
  }) : super(key: key);

  final BoardGameStatistics? boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        CalendarCard(boardGameStatistics?.lastPlayed),
        const SizedBox(height: Dimensions.standardSpacing),
        ItemPropertyValue(
          boardGameStatistics?.lastPlayed?.toDaysAgo(),
        ),
      ],
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({
    required this.boardGameStatistics,
    Key? key,
  }) : super(key: key);

  final BoardGameStatistics? boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            _StatisticsItem(
              value: boardGameStatistics?.numberOfGamesPlayed?.toString() ?? '-',
              icon: Icons.insert_chart,
              iconColor: AppTheme.accentColor,
              subtitle: AppText.playthroughsStatisticsPageQuickStatsAvgPlayedGames,
            ),
            const Expanded(child: SizedBox.shrink()),
            _StatisticsItem(
              value: boardGameStatistics?.highscore?.toString() ?? '-',
              icon: Icons.show_chart,
              iconColor: Colors.red,
              subtitle: AppText.playthroughsStatisticsPageQuickStatsHighscore,
            ),
            const Expanded(child: SizedBox.shrink()),
            _StatisticsItem(
              value: boardGameStatistics?.averagePlaytimeInSeconds?.toAverageDuration('-') ?? '-',
              icon: Icons.hourglass_empty,
              iconColor: Colors.blue,
              subtitle: AppText.playthroughsStatisticsPageQuickStatsAvgPlaytime,
            ),
          ],
        ),
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _StatisticsItem(
              value: boardGameStatistics?.averageScore?.toStringAsFixed(0) ?? '-',
              icon: Icons.calculate,
              iconColor: AppTheme.purpleColor,
              subtitle: AppText.playthroughsStatisticsPageQuickStatsAvgScore,
            ),
            _StatisticsItem(
              value: boardGameStatistics?.averageNumberOfPlayers?.toStringAsFixed(0) ?? '-',
              icon: Icons.person,
              iconColor: AppTheme.greenColor,
              subtitle: AppText.playthroughsStatisticsPageQuickStatsAvgPlayerCount,
            ),
          ],
        ),
      ],
    );
  }
}

class _TopScores extends StatelessWidget {
  const _TopScores({
    required this.boardGameStatistics,
    Key? key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    final List<Player> keys = boardGameStatistics.topScoreres!.keys.toList();
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: min(boardGameStatistics.topScoreres!.length, 5),
      separatorBuilder: (context, index) {
        return const SizedBox(width: Dimensions.doubleStandardSpacing);
      },
      itemBuilder: (context, index) {
        return PlayerScoreRankAvatar(
          player: keys[index],
          rank: index + 1,
          score: boardGameStatistics.topScoreres![keys[index]],
          useHeroAnimation: false,
        );
      },
    );
  }
}

class _StatisticsItem extends StatelessWidget {
  const _StatisticsItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.subtitle,
    this.iconColor,
  }) : super(key: key);

  final IconData icon;
  final Color? iconColor;
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
              size: 28,
            ),
            const SizedBox(width: Dimensions.quarterStandardSpacing),
            ItemPropertyValue(
              value,
              fontSize: Dimensions.largeFontSize,
            ),
          ],
        ),
        ItemPropertyTitle(
          subtitle,
          color: AppTheme.defaultTextColor,
          fontSize: Dimensions.smallFontSize,
        ),
      ],
    );
  }
}
