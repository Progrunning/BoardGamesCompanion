import 'dart:math';

import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/injectable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/int_extensions.dart';
import '../../models/board_game_statistics.dart';
import '../../models/hive/player.dart';
import '../../models/player_statistics.dart';
import '../../widgets/board_games/board_game_image.dart';
import '../../widgets/common/slivers/bgc_sliver_header_delegate.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/player_score_rank_avatar.dart';
import 'playthrough_statistics_view_model.dart';

class PlaythroughStatistcsPage extends StatefulWidget {
  const PlaythroughStatistcsPage({
    required this.boardGameImageHeroId,
    Key? key,
  }) : super(key: key);

  final String boardGameImageHeroId;

  @override
  PlaythroughStatistcsPageState createState() => PlaythroughStatistcsPageState();
}

class PlaythroughStatistcsPageState extends State<PlaythroughStatistcsPage> {
  late PlaythroughStatisticsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt<PlaythroughStatisticsViewModel>();
    viewModel.loadBoardGamesStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: false,
              expandedHeight: Constants.boardGameDetailsImageHeight,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                background: BoardGameImage(
                  id: widget.boardGameImageHeroId,
                  url: viewModel.boardGameImageUrl,
                  minImageHeight: Constants.boardGameDetailsImageHeight,
                ),
              ),
            ),
            if (viewModel.futureLoadBoardGamesStatistics?.status == FutureStatus.fulfilled) ...[
              SliverPersistentHeader(
                delegate: BgcSliverHeaderDelegate(
                  primaryTitle: AppText.playthroughsStatisticsPageLastWinnerSectionTitle,
                ),
              ),
              _SliverSectionWrapper(
                child: _LastWinnerSection(boardGameStatistics: viewModel.boardGameStatistics),
              ),
              SliverPersistentHeader(
                delegate: BgcSliverHeaderDelegate(
                  primaryTitle: AppText.playthroughsStatisticsPageOverallStatsSectionTitle,
                ),
              ),
              _SliverSectionWrapper(
                child: _OverallStatsSection(boardGameStatistics: viewModel.boardGameStatistics),
              ),
              if (viewModel.boardGameStatistics.topScoreres?.isNotEmpty ?? false) ...[
                SliverPersistentHeader(
                  delegate: BgcSliverHeaderDelegate(
                    primaryTitle: AppText.playthroughsStatisticsPageTopFiveSectionTitle,
                  ),
                ),
                _SliverSectionWrapper(
                  child: _TopScores(boardGameStatistics: viewModel.boardGameStatistics),
                ),
              ],
              if ((viewModel.boardGameStatistics.playerCountPercentage?.isNotEmpty ?? false) &&
                  (viewModel.boardGameStatistics.playerWinsPercentage?.isNotEmpty ?? false)) ...[
                SliverPersistentHeader(
                  delegate: BgcSliverHeaderDelegate(
                    primaryTitle: AppText
                        .playthroughsStatisticsPageGamesPlayedAndWonChartsSectionPrimaryTitle,
                    secondaryTitle: AppText
                        .playthroughsStatisticsPageGamesPlayedAndWonChartsSectionSecondaryTitle,
                  ),
                ),
                _SliverSectionWrapper(
                  child: _PlayerCharts(boardGameStatistics: viewModel.boardGameStatistics),
                ),
              ],
              if (viewModel.boardGameStatistics.playersStatistics?.isNotEmpty ?? false) ...[
                SliverPersistentHeader(
                  delegate: BgcSliverHeaderDelegate(
                    primaryTitle: AppText.playthroughsStatisticsPagePlayersStatsSectionTitle,
                  ),
                ),
                _PlayersStatisticsSection(boardGameStatistics: viewModel.boardGameStatistics),
              ],
              const SliverPadding(
                padding: EdgeInsets.only(
                  bottom: Dimensions.standardSpacing + Dimensions.bottomTabTopHeight,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PlayersStatisticsSection extends StatelessWidget {
  const _PlayersStatisticsSection({
    Key? key,
    required this.boardGameStatistics,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: Dimensions.standardSpacing,
        left: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            final int itemIndex = index ~/ 2;
            if (index.isEven) {
              final PlayerStatistics playerStatistics =
                  boardGameStatistics.playersStatistics![itemIndex];
              return SizedBox(
                height: Dimensions.smallPlayerAvatarSize,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.smallPlayerAvatarSize,
                      width: Dimensions.smallPlayerAvatarSize,
                      child: PlayerAvatar(
                        playerStatistics.player,
                        useHeroAnimation: false,
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    if (playerStatistics.personalBestScore != null) ...<Widget>[
                      Center(
                        child: _StatisticsItem(
                          value: playerStatistics.personalBestScore.toString(),
                          valueTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.extraLargeFontSize,
                          ),
                          icon: Icons.show_chart,
                          iconColor: AppColors.highscoreStatColor,
                          iconSize: 38,
                          subtitle: AppText.playthroughsStatisticsPagePlayersStatsPersonalBest,
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                    ],
                    if (playerStatistics.averageScore != null) ...<Widget>[
                      Center(
                        child: _StatisticsItem(
                          value: playerStatistics.averageScore!.toStringAsFixed(0),
                          valueTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.extraLargeFontSize,
                          ),
                          icon: Icons.calculate,
                          iconColor: AppColors.averageScoreStatColor,
                          iconSize: 38,
                          subtitle: AppText.playthroughsStatisticsPagePlayersStatsAvgScore,
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                    ],
                    if (playerStatistics.numberOfGamesPlayed != null) ...<Widget>[
                      Center(
                        child: _StatisticsItem(
                          value: playerStatistics.numberOfGamesPlayed.toString(),
                          valueTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.extraLargeFontSize,
                          ),
                          icon: Icons.casino,
                          iconColor: AppColors.playedGamesStatColor,
                          iconSize: 38,
                          subtitle: AppText.playthroughsStatisticsPagePlayersStatsPlayedGames,
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                    ],
                  ],
                ),
              );
            }

            return const SizedBox(height: Dimensions.standardSpacing);
          },
          childCount: max(0, boardGameStatistics.playersStatistics!.length * 2 - 1),
        ),
      ),
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
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _LastWinnerAvatar(boardGameStatistics: boardGameStatistics),
              const SizedBox(width: Dimensions.standardSpacing),
              _LastWinnerText(boardGameStatistics: boardGameStatistics),
              const SizedBox(width: Dimensions.standardSpacing),
              _LastTimePlayed(boardGameStatistics: boardGameStatistics),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerCharts extends StatefulWidget {
  const _PlayerCharts({
    required this.boardGameStatistics,
    Key? key,
  }) : super(key: key);

  final BoardGameStatistics boardGameStatistics;

  @override
  State<_PlayerCharts> createState() => _PlayerChartsState();
}

class _PlayerChartsState extends State<_PlayerCharts> {
  late Map<int, Color> playerCountChartColors;
  late Map<Player, Color> playerWinsChartColors;

  static const double _chartSize = 160;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO MK Probalby not best to calculate this with every build
    //         Need a better state control strategy (mobx?)
    playerCountChartColors = {};
    playerWinsChartColors = {};
    int i = 0;
    for (final PlayerCountStatistics playeCountStatistics
        in widget.boardGameStatistics.playerCountPercentage!) {
      playerCountChartColors[playeCountStatistics.numberOfPlayers] =
          AppColors.chartColorPallete[i++ % AppColors.chartColorPallete.length];
    }
    i = 0;
    for (final PlayerWinsStatistics playerWinsStatistics
        in widget.boardGameStatistics.playerWinsPercentage!) {
      playerWinsChartColors[playerWinsStatistics.player] =
          AppColors.chartColorPallete[i++ % AppColors.chartColorPallete.length];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: Dimensions.halfStandardSpacing),
        Row(
          children: <Widget>[
            SizedBox(
              height: _chartSize,
              width: _chartSize,
              child: PieChart(
                PieChartData(
                  sections: <PieChartSectionData>[
                    for (final PlayerCountStatistics playeCountStatistics
                        in widget.boardGameStatistics.playerCountPercentage!)
                      PieChartSectionData(
                        value: playeCountStatistics.gamesPlayedPercentage,
                        title: '${playeCountStatistics.numberOfGamesPlayed}',
                        color: playerCountChartColors[playeCountStatistics.numberOfPlayers],
                      ),
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
            SizedBox(
              height: _chartSize,
              width: _chartSize,
              child: PieChart(
                PieChartData(
                  sections: <PieChartSectionData>[
                    for (final PlayerWinsStatistics playeWinsStatistics
                        in widget.boardGameStatistics.playerWinsPercentage!)
                      PieChartSectionData(
                        value: playeWinsStatistics.winsPercentage,
                        title: '${playeWinsStatistics.numberOfWins}',
                        color: playerWinsChartColors[playeWinsStatistics.player],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.halfStandardSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final PlayerCountStatistics playeCountStatistics
                    in widget.boardGameStatistics.playerCountPercentage!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.standardSpacing),
                    child: Row(
                      children: <Widget>[
                        _ChartLegendBox(
                            color: playerCountChartColors[playeCountStatistics.numberOfPlayers]!),
                        const SizedBox(width: Dimensions.halfStandardSpacing),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: sprintf(
                                  playeCountStatistics.numberOfPlayers > 1
                                      ? AppText
                                          .playthroughsStatisticsPagePlayerCountChartLegendFormatPlural
                                      : AppText
                                          .playthroughsStatisticsPagePlayerCountChartLegendFormatSingular,
                                  [
                                    playeCountStatistics.numberOfPlayers,
                                  ],
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' [${(playeCountStatistics.gamesPlayedPercentage * 100).toStringAsFixed(0)}%]',
                                style: AppTheme.theme.textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (final PlayerWinsStatistics playerWinsStatistics
                    in widget.boardGameStatistics.playerWinsPercentage!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.standardSpacing),
                    child: Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: '${playerWinsStatistics.player.name} '),
                              TextSpan(
                                text:
                                    '[${(playerWinsStatistics.winsPercentage * 100).toStringAsFixed(0)}%]',
                                style: AppTheme.theme.textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Dimensions.halfStandardSpacing),
                        _ChartLegendBox(color: playerWinsChartColors[playerWinsStatistics.player]!),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ChartLegendBox extends StatelessWidget {
  const _ChartLegendBox({
    required this.color,
    Key? key,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
      ),
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
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Text(
                'won with',
                style: TextStyle(fontSize: Dimensions.smallFontSize, fontWeight: FontWeight.normal),
              ),
            ),
            TextSpan(
              text: ' ${boardGameStatistics?.lastWinner?.score.value ?? '-'} ',
              style: AppStyles.playerScoreTextStyle,
            ),
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Text(
                'points on',
                style: TextStyle(fontSize: Dimensions.smallFontSize, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
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
        Text(
          boardGameStatistics?.lastPlayed?.toDaysAgo() ?? '',
          style: const TextStyle(
            fontSize: Dimensions.smallFontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _OverallStatsSection extends StatelessWidget {
  const _OverallStatsSection({
    required this.boardGameStatistics,
    Key? key,
  }) : super(key: key);

  final BoardGameStatistics? boardGameStatistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                _StatisticsItem(
                  value: boardGameStatistics?.numberOfGamesPlayed?.toString() ?? '-',
                  icon: Icons.casino,
                  iconColor: AppColors.playedGamesStatColor,
                  subtitle: AppText.playthroughsStatisticsPageOverallStatsAvgPlayedGames,
                ),
                const SizedBox(height: Dimensions.doubleStandardSpacing),
                _StatisticsItem(
                  value: boardGameStatistics?.bestScore?.toString() ?? '-',
                  icon: Icons.show_chart,
                  iconColor: AppColors.highscoreStatColor,
                  subtitle: AppText.playthroughsStatisticsPageOverallStatsBestScore,
                ),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
            Column(
              children: <Widget>[
                _StatisticsItem(
                  value: boardGameStatistics?.averageNumberOfPlayers?.toStringAsFixed(0) ?? '-',
                  icon: Icons.person,
                  iconColor: AppColors.averagePlayerCountStatColor,
                  subtitle: AppText.playthroughsStatisticsPageOverallStatsAvgPlayerCount,
                ),
                const SizedBox(height: Dimensions.doubleStandardSpacing),
                _StatisticsItem(
                  value: boardGameStatistics?.averageScore?.toStringAsFixed(0) ?? '-',
                  icon: Icons.calculate,
                  iconColor: AppColors.averageScoreStatColor,
                  subtitle: AppText.playthroughsStatisticsPageOverallStatsAvgScore,
                ),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
            Column(
              children: <Widget>[
                _StatisticsItem(
                  value: boardGameStatistics?.averagePlaytimeInSeconds
                          ?.toPlaytimeDuration(fallbackValue: '-') ??
                      '-',
                  icon: Icons.av_timer,
                  iconColor: AppColors.averagePlaytimeStatColor,
                  subtitle: AppText.playthroughsStatisticsPageOverallStatsAvgPlaytime,
                ),
                const SizedBox(height: Dimensions.doubleStandardSpacing),
                _StatisticsItem(
                  value: boardGameStatistics?.totalPlaytimeInSeconds
                          ?.toPlaytimeDuration(fallbackValue: '-') ??
                      '-',
                  icon: Icons.timelapse,
                  iconColor: AppColors.totalPlaytimeStatColor,
                  subtitle: AppText.playthroughsStatisticsPageOverallStatsTotalPlaytime,
                ),
              ],
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
            player: boardGameStatistics.topScoreres![index].item1,
            rank: index + 1,
            score: boardGameStatistics.topScoreres![index].item2,
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
    this.iconSize = 28,
    this.valueTextStyle = const TextStyle(fontSize: Dimensions.largeFontSize),
  }) : super(key: key);

  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  final String value;
  final String subtitle;
  final TextStyle valueTextStyle;

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
              size: iconSize,
            ),
            const SizedBox(width: Dimensions.quarterStandardSpacing),
            Text(value, style: valueTextStyle),
          ],
        ),
        ItemPropertyTitle(
          subtitle,
          color: AppColors.defaultTextColor,
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
        top: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
        bottom: Dimensions.doubleStandardSpacing,
      ),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}
