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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.boardGameDetails,
      builder: (_, __) {
        return Consumer2<PlaythroughStatisticsStore, BoardGameDetails>(
          builder: (_, store, boardGameDetails, __) {
            final boardGameStatistics = store.boardGamesStatistics[boardGameDetails.id];
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
                      heroTag:
                          '${AnimationTags.boardGamePlaythroughImageHeroTag}_${widget.collectionType}',
                    ),
                  ),
                ),
                _SliverSectionWrapper(
                    child: _LastWinnerSection(boardGameStatistics: boardGameStatistics)),
                _SliverSectionWrapper(
                  child: _QuickStatsSection(boardGameStatistics: boardGameStatistics),
                ),
                if (boardGameStatistics?.topScoreres?.isNotEmpty ?? false)
                  _SliverSectionWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ItemPropertyTitle(
                            AppText.playthroughsStatisticsPageTopFiveSectionTitle),
                        const SizedBox(height: Dimensions.halfStandardSpacing),
                        _TopScores(boardGameStatistics: boardGameStatistics!),
                      ],
                    ),
                  ),
                if (boardGameStatistics?.playerCountPercentage?.isNotEmpty ?? false)
                  _SliverSectionWrapper(
                    child: _PlayerCountPercentageChart(boardGameStatistics: boardGameStatistics!),
                  ),
                if (boardGameStatistics?.personalBests?.isNotEmpty ?? false) ...<Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        ItemPropertyTitle(
                            AppText.playthroughsStatisticsPagePersonalBestsSectionTitle),
                        SizedBox(height: Dimensions.halfStandardSpacing),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                    sliver: SliverGrid.extent(
                      crossAxisSpacing: Dimensions.standardSpacing,
                      mainAxisSpacing: Dimensions.standardSpacing,
                      maxCrossAxisExtent: Dimensions.smallPlayerAvatarWithScoreSize,
                      childAspectRatio: 0.9,
                      children: <Widget>[
                        for (final MapEntry<Player, String> personalBest
                            in boardGameStatistics!.personalBests!.entries)
                          PlayerScoreRankAvatar(
                            player: personalBest.key,
                            score: personalBest.value,
                            useHeroAnimation: false,
                          )
                      ],
                    ),
                  ),
                ],
                const SliverPadding(padding: EdgeInsets.only(bottom: Dimensions.standardSpacing)),
              ],
            );
          },
        );
      },
    );
  }
}

class _LastWinnerSection extends StatelessWidget {
  const _LastWinnerSection({
    Key? key,
    required this.boardGameStatistics,
  }) : super(key: key);

  final BoardGameStatistics? boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ItemPropertyTitle(AppText.playthroughsStatisticsPageLastWinnerSectionTitle),
        const SizedBox(height: Dimensions.halfStandardSpacing),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _LastWinnerAvatar(boardGameStatistics: boardGameStatistics),
            const SizedBox(width: Dimensions.standardSpacing),
            _LastWinnerText(boardGameStatistics: boardGameStatistics),
            const SizedBox(width: Dimensions.standardSpacing),
            Expanded(child: _LastTimePlayed(boardGameStatistics: boardGameStatistics)),
          ],
        ),
      ],
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
        const ItemPropertyTitle(
            AppText.playthroughsStatisticsPagePlayerCountPercentageSectionTitle),
        const SizedBox(height: Dimensions.halfStandardSpacing),
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
              'points on',
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
    return Row(
      children: <Widget>[
        CalendarCard(boardGameStatistics?.lastPlayed),
        const SizedBox(width: Dimensions.standardSpacing),
        Flexible(
          child: Text(
            boardGameStatistics?.lastPlayed?.toDaysAgo() ?? '',
            style: const TextStyle(
              fontSize: Dimensions.smallFontSize,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickStatsSection extends StatelessWidget {
  const _QuickStatsSection({
    required this.boardGameStatistics,
    Key? key,
  }) : super(key: key);

  final BoardGameStatistics? boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ItemPropertyTitle(AppText.playthroughsStatisticsPageQuickStatsSectionTitle),
        const SizedBox(height: Dimensions.halfStandardSpacing),
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
    return SizedBox(
      height: Dimensions.smallPlayerAvatarWithScoreSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: boardGameStatistics.topScoreres!.length,
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
      ),
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

class _SliverSectionWrapper extends StatelessWidget {
  const _SliverSectionWrapper({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: Dimensions.standardSpacing,
        top: Dimensions.halfStandardSpacing,
        right: Dimensions.standardSpacing,
        bottom: Dimensions.doubleStandardSpacing,
      ),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}
