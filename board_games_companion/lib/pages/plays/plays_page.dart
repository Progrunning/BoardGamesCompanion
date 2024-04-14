import 'dart:async';
import 'dart:io';

import 'package:basics/basics.dart';
import 'package:board_games_companion/extensions/date_time_extensions.dart';
import 'package:board_games_companion/pages/plays/historical_playthrough.dart';
import 'package:board_games_companion/pages/plays/most_played_game.dart';
import 'package:board_games_companion/pages/plays/plays_stats_visual_states.dart';
import 'package:board_games_companion/widgets/common/section_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../common/enums/plays_tab.dart';
import '../../extensions/int_extensions.dart';
import '../../extensions/string_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../models/navigation/edit_playthrough_page_arguments.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../widgets/animations/image_fade_in_animation.dart';
import '../../widgets/board_games/board_game_name.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/app_bar/app_bar_bottom_tab.dart';
import '../../widgets/common/bgc_checkbox.dart';
import '../../widgets/common/collection_toggle_button.dart';
import '../../widgets/common/empty_page_information_panel.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/panel_container.dart';
import '../../widgets/common/segmented_buttons/bgc_segmented_button.dart';
import '../../widgets/common/segmented_buttons/bgc_segmented_buttons_container.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../../widgets/common/stats/vertical_statistics_item.dart';
import '../board_game_details/board_game_details_page.dart';
import '../edit_playthrough/edit_playthrough_page.dart';
import '../home/home_page.dart';
import '../playthroughs/playthroughs_page.dart';
import 'board_game_playthrough.dart';
import 'game_spinner_filters.dart';
import 'game_spinner_game_selected_dialog.dart';
import 'plays_page_visual_states.dart';
import 'plays_view_model.dart';

class PlaysPage extends StatefulWidget {
  const PlaysPage({
    required this.viewModel,
    super.key,
  });

  final PlaysViewModel viewModel;

  @override
  State<PlaysPage> createState() => _PlaysPageState();
}

class _PlaysPageState extends State<PlaysPage> with SingleTickerProviderStateMixin {
  static const int _spinAnimationTimeInMilliseconds = 2000;

  late TabController _tabController;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.viewModel.visualState.when(
        history: () => 0,
        statistics: () => 1,
        selectGame: () => 2,
      ),
    );
    _tabController
        .addListener(() => widget.viewModel.setSelectTab(_tabController.index.toPlaysTab()));

    _scrollController = FixedExtentScrollController();

    widget.viewModel.loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          switch (widget.viewModel.futureLoadData?.status ?? FutureStatus.pending) {
            case FutureStatus.pending:
            case FutureStatus.rejected:
              return CustomScrollView(
                slivers: [
                  Observer(
                    builder: (_) {
                      return _AppBar(
                        tabVisualState: widget.viewModel.visualState,
                        tabController: _tabController,
                        onTabSelected: (tabIndex) => widget.viewModel.trackTabChange(tabIndex),
                      );
                    },
                  ),
                  const SliverFillRemaining(child: LoadingIndicator()),
                ],
              );
            case FutureStatus.fulfilled:
              return CustomScrollView(
                slivers: [
                  Observer(
                    builder: (_) {
                      return _AppBar(
                        tabVisualState: widget.viewModel.visualState,
                        tabController: _tabController,
                        onTabSelected: (tabIndex) => widget.viewModel.trackTabChange(tabIndex),
                      );
                    },
                  ),
                  Observer(
                    builder: (BuildContext context) {
                      return widget.viewModel.visualState.when(
                        history: () => Observer(
                          builder: (_) => _HistoryTab(
                            historicalPlaythroughs: widget.viewModel.historicalPlaythroughs,
                          ),
                        ),
                        statistics: () =>
                            _StatisticsTab(visualState: widget.viewModel.playsStatsVisualState),
                        selectGame: () {
                          if (!widget.viewModel.hasAnyBoardGames) {
                            return const _NoBoardGamesSliver();
                          }

                          return MultiSliver(
                            children: [
                              if (!widget.viewModel.hasAnyBoardGamesToShuffle)
                                const _NoBoardGamesToShuffleSliver(),
                              if (widget.viewModel.hasAnyBoardGamesToShuffle)
                                _GameSpinnerSliver(
                                  scrollController: _scrollController,
                                  shuffledBoardGames: widget.viewModel.shuffledBoardGames,
                                  onSpin: () => _spin(),
                                  onGameSelected: () => _selectGame(context),
                                ),
                              SliverPersistentHeader(
                                delegate: BgcSliverTitleHeaderDelegate.title(
                                  primaryTitle: AppText.playsPageGameSpinnerFilterSectionTitle,
                                ),
                              ),
                              Observer(
                                builder: (_) {
                                  return _GameSpinnerFilters(
                                    gameSpinnerFilters: widget.viewModel.gameSpinnerFilters,
                                    maxNumberOfPlayers: widget.viewModel.maxNumberOfPlayers,
                                    onCollectionToggled: (collectionTyp) => widget.viewModel
                                        .toggleGameSpinnerCollectionFilter(collectionTyp),
                                    onIncludeExpansionsToggled: (isChecked) =>
                                        widget.viewModel.toggleIncludeExpansionsFilter(isChecked),
                                    onNumberOfPlayersChanged: (numberOfPlayers) => widget.viewModel
                                        .updateNumberOfPlayersNumberFilter(numberOfPlayers),
                                    onPlaytimeChanged: (playtime) =>
                                        widget.viewModel.updatePlaytimeFilter(playtime),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              );
          }
        },
      );

  Future<void> _spin() async {
    await _scrollController.animateToItem(
      widget.viewModel.randomItemIndex,
      duration: const Duration(milliseconds: _spinAnimationTimeInMilliseconds),
      curve: Curves.elasticInOut,
    );
  }

  Future<void> _selectGame(BuildContext context) async {
    unawaited(widget.viewModel.trackGameSelected());
    final selectedBoardGame = widget.viewModel.shuffledBoardGames[
        _scrollController.selectedItem % widget.viewModel.shuffledBoardGames.length];
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      routeSettings: const RouteSettings(name: GameSpinnerGameSelectedDialog.pageRoute),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (_, __, ___) {
        return GameSpinnerGameSelectedDialog(selectedBoardGame: selectedBoardGame);
      },
    );
  }
}

class _StatisticsTab extends StatelessWidget {
  const _StatisticsTab({
    required this.visualState,
  });

  final PlaysStatsVisualState visualState;

  @override
  Widget build(BuildContext context) {
    return visualState.when(
      empty: () => const _NoPlaysStatsSliver(),
      init: () => const _LoadingPlaysStatsSliver(),
      loading: () => const _LoadingPlaysStatsSliver(),
      stats: (
        List<MostPlayedGame> mostPlayedGames,
        int totalGamesLogged,
        int totalGamesPlayed,
        int totalPlaytimeInSeconds,
        int totalDuelGamesLogged,
        int totalMultiPlayerGamesLogged,
      ) =>
          _PlaysStats(
        mostPlayedGames: mostPlayedGames,
        totalDuelGamesLogged: totalDuelGamesLogged,
        totalGamesLogged: totalGamesLogged,
        totalGamesPlayed: totalGamesPlayed,
        totalMultiPlayerGamesLogged: totalMultiPlayerGamesLogged,
        totalPlaytimeInSeconds: totalPlaytimeInSeconds,
      ),
    );
  }
}

class _PlaysStats extends StatelessWidget {
  const _PlaysStats({
    required this.mostPlayedGames,
    required this.totalGamesLogged,
    required this.totalGamesPlayed,
    required this.totalPlaytimeInSeconds,
    required this.totalDuelGamesLogged,
    required this.totalMultiPlayerGamesLogged,
  });

  final List<MostPlayedGame> mostPlayedGames;
  final int totalGamesLogged;
  final int totalGamesPlayed;
  final int totalPlaytimeInSeconds;
  final int totalDuelGamesLogged;
  final int totalMultiPlayerGamesLogged;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPersistentHeader(
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.playsPageOverallStatsMostPlayedGameSectionTitle,
          ),
        ),
        SliverToBoxAdapter(
          child: Observer(
            builder: (_) {
              return _MostPlayedGamesSection(
                mostPlayedGames: mostPlayedGames,
              );
            },
          ),
        ),
        SliverPersistentHeader(
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.playsPageOverallStatsTotalsSectionTitle,
          ),
        ),
        SliverToBoxAdapter(
          child: Observer(
            builder: (_) {
              return _OverallStatsSection(
                totalGamesLogged: totalGamesLogged,
                totalGamesPlayed: totalGamesPlayed,
                totalPlaytimeInSeconds: totalPlaytimeInSeconds,
                totalDuelGamesLogged: totalDuelGamesLogged,
                totalMultiPlayerGamesLogged: totalMultiPlayerGamesLogged,
              );
            },
          ),
        ),
        // TODO Add games distribution section in later iterations
        // SliverPersistentHeader(
        //   delegate: BgcSliverTitleHeaderDelegate.title(
        //     primaryTitle: AppText.playsPageOverallStatsGamesPlayedDistributionSctionTitle,
        //   ),
        // ),
        // SliverToBoxAdapter(
        //   child: Observer(
        //     builder: (_) {
        //       return const _GamesPlayedDistributionSection();
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class _NoPlaysStatsSliver extends StatelessWidget {
  const _NoPlaysStatsSliver();

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.standardSpacing,
        horizontal: Dimensions.doubleStandardSpacing,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
            EmptyPageInformationPanel(
              title: AppText.playsPageOverallStatsNoPlayesTitle,
              icon: Icon(
                FontAwesomeIcons.dice,
                size: Dimensions.emptyPageTitleIconSize,
                color: AppColors.primaryColor,
              ),
              subtitle: AppText.playsPageOverallStatsNoPlayesSubtitle,
            ),
            SizedBox(height: Dimensions.doubleStandardSpacing),
          ],
        ),
      ),
    );
  }
}

class _LoadingPlaysStatsSliver extends StatelessWidget {
  const _LoadingPlaysStatsSliver();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(child: LoadingIndicator());
  }
}

class _MostPlayedGamesSection extends StatelessWidget {
  const _MostPlayedGamesSection({
    required this.mostPlayedGames,
  });

  static const double _iconSize = 24;
  static const TextStyle _textStyle = TextStyle(fontSize: Dimensions.standardFontSize);

  final List<MostPlayedGame> mostPlayedGames;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.mostPlayedGamesImageHeight + Dimensions.standardSpacing * 2,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int index) {
          final mostPlayedGame = mostPlayedGames[index].boardGameDetails;
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? Dimensions.standardSpacing : 0,
              top: Dimensions.standardSpacing,
              bottom: Dimensions.standardSpacing,
              right: index == mostPlayedGames.length - 1 ? Dimensions.standardSpacing : 0,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: Dimensions.mostPlayedGamesImageHeight,
                  child: BoardGameTile(
                    id: mostPlayedGame.id,
                    name: mostPlayedGame.name,
                    imageUrl: mostPlayedGame.imageUrl ?? '',
                    rank: index + 1,
                  ),
                ),
                const SizedBox(width: Dimensions.halfStandardSpacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    VerticalStatisticsItem(
                      text: sprintf(
                        AppText.playsPageOverallStatsTotalPlayedGamesFormat,
                        [mostPlayedGames[index].totalNumberOfPlays],
                      ),
                      textStyle: _textStyle,
                      icon: Icons.casino,
                      iconSize: _iconSize,
                      iconColor: AppColors.playedGamesStatColor,
                    ),
                    const SizedBox(height: Dimensions.halfStandardSpacing),
                    VerticalStatisticsItem(
                      text: mostPlayedGames[index].totalTimePlayedInSeconds.toPlaytimeDuration(),
                      textStyle: _textStyle,
                      icon: Icons.timelapse,
                      iconSize: _iconSize,
                      iconColor: AppColors.highscoreStatColor,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: Dimensions.doubleStandardSpacing),
        itemCount: mostPlayedGames.length,
      ),
    );
  }
}

class _OverallStatsSection extends StatelessWidget {
  const _OverallStatsSection({
    required this.totalGamesLogged,
    required this.totalGamesPlayed,
    required this.totalPlaytimeInSeconds,
    required this.totalDuelGamesLogged,
    required this.totalMultiPlayerGamesLogged,
  });

  final int totalGamesLogged;
  final int totalGamesPlayed;
  final int totalPlaytimeInSeconds;
  final int totalDuelGamesLogged;
  final int totalMultiPlayerGamesLogged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              VerticalStatisticsItem(
                text: totalGamesLogged.toString(),
                icon: Icons.casino,
                iconColor: AppColors.playedGamesStatColor,
                subtitle: AppText.playsPageOverallStatsTotalGamesLogged,
              ),
              const SizedBox(height: Dimensions.doubleStandardSpacing),
              VerticalStatisticsItem(
                text: totalPlaytimeInSeconds.toPlaytimeDuration(),
                icon: Icons.timelapse,
                iconColor: AppColors.highscoreStatColor,
                subtitle: AppText.playsPageOverallStatsTotalPlaytime,
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: <Widget>[
              VerticalStatisticsItem(
                text: totalGamesPlayed.toString(),
                icon: FontAwesomeIcons.snowflake,
                iconColor: AppColors.averagePlayerCountStatColor,
                subtitle: AppText.playsPageOverallStatsTotalPlayedGames,
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: <Widget>[
              VerticalStatisticsItem(
                text: totalDuelGamesLogged.toString(),
                icon: Icons.people,
                iconColor: AppColors.averagePlaytimeStatColor,
                subtitle: AppText.playsPageOverallStatsTotalDuels,
              ),
              const SizedBox(height: Dimensions.doubleStandardSpacing),
              VerticalStatisticsItem(
                text: totalMultiPlayerGamesLogged.toString(),
                icon: Icons.person_add_alt_1,
                iconColor: AppColors.totalPlaytimeStatColor,
                subtitle: AppText.playsPageOverallStatsTotalMultiplePlayerGames,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class _GamesPlayedDistributionSection extends StatelessWidget {
//   const _GamesPlayedDistributionSection();

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class _PlayerCharts extends StatefulWidget {
//   const _PlayerCharts({
//     required this.playerCountPercentage,
//   });

//   final List<PlayerCountStatistics> playerCountPercentage;
//   final List<PlayerWinsStatistics>? playerWinsPercentage;

//   @override
//   State<_PlayerCharts> createState() => _PlayerChartsState();
// }

// class _PlayerChartsState extends State<_PlayerCharts> {
//   late Map<int, Color> playerCountChartColors;
//   late Map<Player, Color> playerWinsChartColors;

//   static const double _chartSize = 160;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO MK Probalby not best to calculate this with every build
//     //         Need a better state control strategy (mobx?)
//     playerCountChartColors = {};
//     playerWinsChartColors = {};
//     int i = 0;
//     for (final PlayerCountStatistics playeCountStatistics in widget.playerCountPercentage) {
//       playerCountChartColors[playeCountStatistics.numberOfPlayers] =
//           AppColors.chartColorPallete[i++ % AppColors.chartColorPallete.length];
//     }
//     if (widget.playerWinsPercentage != null) {
//       i = 0;
//       for (final PlayerWinsStatistics playerWinsStatistics in widget.playerWinsPercentage!) {
//         playerWinsChartColors[playerWinsStatistics.player] =
//             AppColors.chartColorPallete[i++ % AppColors.chartColorPallete.length];
//       }
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         const SizedBox(height: Dimensions.halfStandardSpacing),
//         Row(
//           children: <Widget>[
//             SizedBox(
//               height: _chartSize,
//               width: _chartSize,
//               child: PieChart(
//                 PieChartData(
//                   sections: <PieChartSectionData>[
//                     for (final PlayerCountStatistics playeCountStatistics
//                         in widget.playerCountPercentage)
//                       PieChartSectionData(
//                         value: playeCountStatistics.gamesPlayedPercentage,
//                         title: '${playeCountStatistics.numberOfGamesPlayed}',
//                         color: playerCountChartColors[playeCountStatistics.numberOfPlayers],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(),
//             if (widget.playerWinsPercentage != null)
//               SizedBox(
//                 height: _chartSize,
//                 width: _chartSize,
//                 child: PieChart(
//                   PieChartData(
//                     sections: <PieChartSectionData>[
//                       for (final PlayerWinsStatistics playeWinsStatistics
//                           in widget.playerWinsPercentage!)
//                         PieChartSectionData(
//                           value: playeWinsStatistics.winsPercentage,
//                           title: '${playeWinsStatistics.numberOfWins}',
//                           color: playerWinsChartColors[playeWinsStatistics.player],
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: Dimensions.halfStandardSpacing),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 for (final PlayerCountStatistics playeCountStatistics
//                     in widget.playerCountPercentage)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: Dimensions.standardSpacing),
//                     child: Row(
//                       children: <Widget>[
//                         ChartLegendBox(
//                             color: playerCountChartColors[playeCountStatistics.numberOfPlayers]!),
//                         const SizedBox(width: Dimensions.halfStandardSpacing),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: sprintf(
//                                   playeCountStatistics.numberOfPlayers > 1
//                                       ? AppText
//                                           .playthroughsStatisticsPagePlayerCountChartLegendFormatPlural
//                                       : AppText
//                                           .playthroughsStatisticsPagePlayerCountChartLegendFormatSingular,
//                                   [
//                                     playeCountStatistics.numberOfPlayers,
//                                   ],
//                                 ),
//                               ),
//                               TextSpan(
//                                 text:
//                                     ' [${(playeCountStatistics.gamesPlayedPercentage * 100).toStringAsFixed(0)}%]',
//                                 style: AppTheme.theme.textTheme.titleMedium,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//             const Spacer(),
//             if (widget.playerWinsPercentage != null)
//               Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   for (final PlayerWinsStatistics playerWinsStatistics
//                       in widget.playerWinsPercentage!)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: Dimensions.standardSpacing),
//                       child: Row(
//                         children: <Widget>[
//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(text: '${playerWinsStatistics.player.name} '),
//                                 TextSpan(
//                                   text:
//                                       '[${(playerWinsStatistics.winsPercentage * 100).toStringAsFixed(0)}%]',
//                                   style: AppTheme.theme.textTheme.titleMedium,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: Dimensions.halfStandardSpacing),
//                           ChartLegendBox(
//                             color: playerWinsChartColors[playerWinsStatistics.player]!,
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }

class _HistoricalPlaythroughSliverList extends StatelessWidget {
  const _HistoricalPlaythroughSliverList({
    required this.historicalPlaythroughs,
  });

  final List<HistoricalPlaythrough> historicalPlaythroughs;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        final isLast = index == historicalPlaythroughs.length - 1;
        final historicalPlaythrough = historicalPlaythroughs[index].when(
          withDateHeader: (playedOn, boardGamePlaythroughs) =>
              _HistoricalPlaythroughItem.withDateHeader(
            boardGamePlaythrough: boardGamePlaythroughs,
            playedOn: playedOn,
          ),
          withoutDateHeader: (boardGamePlaythroughs) =>
              _HistoricalPlaythroughItem.withoutDateHeader(
            boardGamePlaythrough: boardGamePlaythroughs,
          ),
        );

        if (isLast) {
          return Column(
            children: [
              historicalPlaythrough,
              const SizedBox(height: Dimensions.bottomTabTopHeight)
            ],
          );
        }

        return historicalPlaythrough;
      },
      childCount: historicalPlaythroughs.length,
    ));
  }
}

class _GameSpinnerFilters extends StatelessWidget {
  const _GameSpinnerFilters({
    required this.gameSpinnerFilters,
    required this.maxNumberOfPlayers,
    required this.onCollectionToggled,
    required this.onIncludeExpansionsToggled,
    required this.onNumberOfPlayersChanged,
    required this.onPlaytimeChanged,
  });

  final GameSpinnerFilters gameSpinnerFilters;
  final int maxNumberOfPlayers;
  final void Function(CollectionType collectionTyp) onCollectionToggled;
  final void Function(bool? isChecked) onIncludeExpansionsToggled;
  final void Function(NumberOfPlayersFilter numberOfPlayersFilter) onNumberOfPlayersChanged;
  final void Function(PlaytimeFilter playtimeFilter) onPlaytimeChanged;

  static const Map<int, CollectionType> collectionsMap = <int, CollectionType>{
    0: CollectionType.owned,
    1: CollectionType.friends,
  };

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppText.playsPageGameSpinnerCollectionsFilter,
                  style: AppTheme.theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                ToggleButtons(
                  isSelected: [
                    gameSpinnerFilters.hasOwnedCollection,
                    gameSpinnerFilters.hasFriendsCollection,
                  ],
                  onPressed: (int index) => onCollectionToggled(collectionsMap[index]!),
                  children: [
                    CollectionToggleButton(
                      icon: Icons.grid_on,
                      title: AppText.ownedCollectionToggleButtonText,
                      isSelected: gameSpinnerFilters.hasOwnedCollection,
                    ),
                    CollectionToggleButton(
                      icon: Icons.group,
                      title: AppText.friendsCollectionToggleButtonText,
                      isSelected: gameSpinnerFilters.hasFriendsCollection,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: Dimensions.standardSpacing),
            Row(
              children: [
                Text(
                  AppText.playsPageGameSpinnerExpansionsFilter,
                  style: AppTheme.theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                BgcCheckbox(
                  isChecked: gameSpinnerFilters.includeExpansions,
                  onChanged: (isChecked) => onIncludeExpansionsToggled(isChecked),
                  borderColor: AppColors.accentColor,
                ),
              ],
            ),
            const SizedBox(height: Dimensions.standardSpacing),
            _PlayersFilter(
              numberOfPlayersFilter: gameSpinnerFilters.numberOfPlayersFilter,
              maxNumberOfPlayers: maxNumberOfPlayers,
              onChanged: (numberOfPlayers) => onNumberOfPlayersChanged(numberOfPlayers),
            ),
            const SizedBox(height: Dimensions.standardSpacing),
            _PlaytimeFilter(
              playtimeFilter: gameSpinnerFilters.playtimeFilter,
              onChanged: (playtime) => onPlaytimeChanged(playtime),
            ),
            const SizedBox(height: Dimensions.bottomTabTopHeight + Dimensions.standardSpacing),
          ],
        ),
      );
}

class _PlayersFilter extends StatelessWidget {
  const _PlayersFilter({
    required this.numberOfPlayersFilter,
    required this.maxNumberOfPlayers,
    required this.onChanged,
  });

  static const double sliderAnyNumberValue = -1;
  static const double hasSoloModeValue = 0;
  static const double sliderTwoPlayersOnlyValue = 1;

  final NumberOfPlayersFilter numberOfPlayersFilter;
  final int maxNumberOfPlayers;
  final void Function(NumberOfPlayersFilter numberOfPlayersFilter) onChanged;

  double get sliderMinValue => sliderAnyNumberValue;
  double get sliderMaxValue => maxNumberOfPlayers.toDouble();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppText.playsPageGameSpinnerNumberOfPlayersFilter,
          style: AppTheme.theme.textTheme.bodyMedium,
        ),
        const SizedBox(width: Dimensions.standardSpacing),
        Expanded(
          child: Slider(
            value: _getSliderValue(),
            min: sliderMinValue,
            divisions: (sliderMaxValue - sliderMinValue).toInt(),
            max: sliderMaxValue,
            label: _formatSliderLabelText(),
            onChanged: (value) => _handleOnChanged(value.round()),
            activeColor: AppColors.accentColor,
          ),
        ),
      ],
    );
  }

  String _formatSliderLabelText() {
    return numberOfPlayersFilter.when(
      any: () => AppText.gameFiltersAnyNumberOfPlayers,
      solo: () => AppText.gameFiltersSolo,
      couple: () => AppText.gameFiltersCouple,
      moreOrEqualTo: (numberOfPlayers) => '$numberOfPlayers+',
    );
  }

  double _getSliderValue() {
    return numberOfPlayersFilter.when(
      any: () => sliderAnyNumberValue,
      solo: () => hasSoloModeValue,
      couple: () => sliderTwoPlayersOnlyValue,
      moreOrEqualTo: (numberOfPlayers) => numberOfPlayers.toDouble(),
    );
  }

  void _handleOnChanged(int value) {
    late NumberOfPlayersFilter numberOfPlayersFilter;
    if (value == sliderAnyNumberValue) {
      numberOfPlayersFilter = const NumberOfPlayersFilter.any();
    } else if (value == hasSoloModeValue) {
      numberOfPlayersFilter = const NumberOfPlayersFilter.solo();
    } else if (value == sliderTwoPlayersOnlyValue) {
      numberOfPlayersFilter = const NumberOfPlayersFilter.couple();
    } else {
      numberOfPlayersFilter = NumberOfPlayersFilter.moreOrEqualTo(numberOfPlayers: value);
    }

    onChanged(numberOfPlayersFilter);
  }
}

class _PlaytimeFilter extends StatelessWidget {
  const _PlaytimeFilter({
    required this.playtimeFilter,
    required this.onChanged,
  });

  final PlaytimeFilter playtimeFilter;
  final void Function(PlaytimeFilter) onChanged;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppText.playsPageGameSpinnerPlaytimeFilter,
            style: AppTheme.theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Dimensions.doubleStandardSpacing),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: Dimensions.standardSpacing),
              child: BgcSegmentedButtonsContainer(
                height: Dimensions.collectionFilterHexagonSize + Dimensions.doubleStandardSpacing,
                child: Row(
                  children: [
                    _FilterPlaytime.time(
                      isSelected: playtimeFilter == const PlaytimeFilter.any(),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.any(),
                    ),
                    _FilterPlaytime.time(
                      isSelected:
                          playtimeFilter == const PlaytimeFilter.lessThan(playtimeInMinutes: 90),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.lessThan(playtimeInMinutes: 90),
                    ),
                    _FilterPlaytime.time(
                      isSelected:
                          playtimeFilter == const PlaytimeFilter.lessThan(playtimeInMinutes: 60),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.lessThan(playtimeInMinutes: 60),
                    ),
                    _FilterPlaytime.time(
                      isSelected:
                          playtimeFilter == const PlaytimeFilter.lessThan(playtimeInMinutes: 45),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.lessThan(playtimeInMinutes: 45),
                    ),
                    _FilterPlaytime.time(
                      isSelected:
                          playtimeFilter == const PlaytimeFilter.lessThan(playtimeInMinutes: 30),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.lessThan(playtimeInMinutes: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class _GameSpinnerSliver extends StatefulWidget {
  const _GameSpinnerSliver({
    required this.scrollController,
    required this.shuffledBoardGames,
    required this.onSpin,
    required this.onGameSelected,
  });

  static const double _gameSpinnerItemHeight = 80;
  static const double _gameSpinnerItemSqueeze = 1.2;

  final ScrollController scrollController;
  final List<BoardGameDetails> shuffledBoardGames;
  final VoidCallback onSpin;
  final VoidCallback onGameSelected;

  @override
  State<_GameSpinnerSliver> createState() => _GameSpinnerSliverState();
}

class _GameSpinnerSliverState extends State<_GameSpinnerSliver> {
  static const int _debounceSpinnerThresholdInMilliseconds = 300;

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: SizedBox(
          height: Dimensions.gameSpinnerHeight,
          child: Row(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification &&
                        (_debounce?.isActive ?? false)) {
                      _debounce!.cancel();
                    }

                    if (scrollNotification is ScrollEndNotification) {
                      _debounce = Timer(
                        const Duration(milliseconds: _debounceSpinnerThresholdInMilliseconds),
                        () => widget.onGameSelected(),
                      );
                    }

                    return false;
                  },
                  child: ListWheelScrollView.useDelegate(
                    controller: widget.scrollController,
                    itemExtent: _GameSpinnerSliver._gameSpinnerItemHeight,
                    squeeze: _GameSpinnerSliver._gameSpinnerItemSqueeze,
                    perspective: 0.0035,
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: [
                        for (final boardGame in widget.shuffledBoardGames) ...[
                          Center(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: Dimensions.gameSpinnerMaxWidth,
                              ),
                              child: Stack(
                                children: [
                                  if (boardGame.imageUrl.isNotNullOrBlank)
                                    Positioned.fill(
                                      child: _GameSpinnerItem(
                                        boardGameId: boardGame.id,
                                        boardGameImageUrl: boardGame.imageUrl!,
                                      ),
                                    ),
                                  if (boardGame.imageUrl.isNullOrBlank)
                                    Container(decoration: AppStyles.tileGradientBoxDecoration),
                                  Center(
                                    child: BoardGameName(
                                      name: boardGame.name,
                                      fontSize: Dimensions.mediumFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.standardSpacing),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => widget.onSpin(),
                  child: const Padding(
                    padding: EdgeInsets.all(Dimensions.standardSpacing),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.arrowsSpin),
                        Text(AppText.playsPageGameSpinnerSpinButtonText),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameSpinnerItem extends StatelessWidget {
  const _GameSpinnerItem({
    required this.boardGameId,
    required this.boardGameImageUrl,
  });

  final String boardGameId;
  final String boardGameImageUrl;

  @override
  Widget build(BuildContext context) => Hero(
        tag: '${AnimationTags.gameSpinnerBoardGameHeroTag}$boardGameId',
        child: LayoutBuilder(
          builder: (_, BoxConstraints boxConstraints) {
            return boardGameImageUrl.toImageType().when(
                  web: () => _GameSpinnerItemWebImage(
                    boardGameImageUrl: boardGameImageUrl,
                    boxConstraints: boxConstraints,
                  ),
                  file: () => ClipRRect(
                    borderRadius: AppTheme.defaultBorderRadius,
                    child: Image.file(
                      File(boardGameImageUrl),
                      fit: BoxFit.cover,
                      cacheHeight: boxConstraints.maxWidth.toInt(),
                      frameBuilder: (_, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }

                        return ImageFadeInAnimation(frame: frame, child: child);
                      },
                    ),
                  ),
                  undefined: () => const SizedBox.shrink(),
                );
          },
        ),
      );
}

class _GameSpinnerItemWebImage extends StatelessWidget {
  const _GameSpinnerItemWebImage({
    required this.boardGameImageUrl,
    required this.boxConstraints,
    this.errorWidget,
  });

  final BoxConstraints boxConstraints;
  final String boardGameImageUrl;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      maxHeightDiskCache: boxConstraints.maxWidth.toInt(),
      imageUrl: boardGameImageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: AppTheme.defaultBorderRadius,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      fit: BoxFit.fitWidth,
      placeholder: (context, url) => Container(
        decoration: AppStyles.tileGradientBoxDecoration,
      ),
      errorWidget: (context, url, dynamic error) {
        if (errorWidget != null) {
          return errorWidget!;
        }

        // MK Re-trying to show web image on error because there seems to be an issue in Flutter SDK,
        //    where _minScrollExtent in scroll_position.dart file is null when being accessed.
        //    The problem appears to be happening only on the first "draw" of the screen with ListWheelScrollView
        //    but with second attempt it works fine.
        //
        //    Github issues:
        //    - https://github.com/flutter/flutter/issues/60578
        //    - https://github.com/flutter/flutter/issues/61228 <-- an idea from hyungtaecf comment that seems to fix it
        return _GameSpinnerItemWebImage(
          boardGameImageUrl: boardGameImageUrl,
          boxConstraints: boxConstraints,
          errorWidget: Container(
            decoration: AppStyles.tileGradientBoxDecoration,
          ),
        );
      },
    );
  }
}

class _HistoricalPlaythroughItem extends StatelessWidget {
  const _HistoricalPlaythroughItem._({
    required this.boardGamePlaythrough,
    this.playedOn,
  }) : super();

  factory _HistoricalPlaythroughItem.withoutDateHeader({
    required BoardGamePlaythrough boardGamePlaythrough,
  }) =>
      _HistoricalPlaythroughItem._(boardGamePlaythrough: boardGamePlaythrough);

  factory _HistoricalPlaythroughItem.withDateHeader({
    required BoardGamePlaythrough boardGamePlaythrough,
    required DateTime playedOn,
  }) =>
      _HistoricalPlaythroughItem._(
        boardGamePlaythrough: boardGamePlaythrough,
        playedOn: playedOn,
      );

  static const double _playthroughContainerHeight = 110;

  final BoardGamePlaythrough boardGamePlaythrough;
  final DateTime? playedOn;

  @override
  Widget build(BuildContext context) {
    final playthroughTile = Padding(
      padding: const EdgeInsets.only(
        bottom: Dimensions.standardSpacing,
        left: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
      ),
      child: PanelContainer(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppStyles.panelContainerCornerRadius),
            onTap: () => _navigateToEditPlaythrough(
              context,
              boardGamePlaythrough.boardGameDetails.id,
              boardGamePlaythrough.playthrough.id,
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.standardSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _playthroughContainerHeight,
                    child: Row(
                      children: [
                        SizedBox(
                          height: Dimensions.collectionSearchResultBoardGameImageHeight,
                          width: Dimensions.collectionSearchResultBoardGameImageWidth,
                          child: BoardGameTile(
                            id: boardGamePlaythrough.id,
                            imageUrl: boardGamePlaythrough.boardGameDetails.thumbnailUrl ?? '',
                          ),
                        ),
                        const SizedBox(width: Dimensions.standardSpacing),
                        Expanded(
                          child: _PlaythroughDetails(
                            boardGamePlaythrough: boardGamePlaythrough,
                          ),
                        ),
                        _PlaythroughActions(
                          onTapBoardGameDetails: () =>
                              _navigateToBoardGameDetails(context, boardGamePlaythrough),
                          onTapPlaythroughs: () =>
                              _navigateToPlaythrough(context, boardGamePlaythrough),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (playedOn == null) {
      return playthroughTile;
    }

    return Column(
      children: [
        SectionHeader.title(title: playedOn!.toHistoricalPlaythroughHeaderFormat()),
        const SizedBox(height: Dimensions.standardSpacing),
        playthroughTile,
      ],
    );
  }

  Future<void> _navigateToPlaythrough(
    BuildContext context,
    BoardGamePlaythrough boardGamePlaythrough,
  ) =>
      Navigator.pushNamed(
        context,
        PlaythroughsPage.pageRoute,
        arguments: PlaythroughsPageArguments(
          boardGameDetails: boardGamePlaythrough.boardGameDetails,
          boardGameImageHeroId: boardGamePlaythrough.id,
        ),
      );

  void _navigateToBoardGameDetails(
    BuildContext context,
    BoardGamePlaythrough boardGamePlaythrough,
  ) {
    Navigator.pushNamed(
      context,
      BoardGamesDetailsPage.pageRoute,
      arguments: BoardGameDetailsPageArguments(
        boardGameId: boardGamePlaythrough.boardGameDetails.id,
        boardGameImageHeroId: boardGamePlaythrough.id,
        navigatingFromType: PlaysPage,
      ),
    );
  }

  void _navigateToEditPlaythrough(
    BuildContext context,
    String boardGameId,
    String playthroughId,
  ) {
    Navigator.pushNamed(
      context,
      EditPlaythroughPage.pageRoute,
      arguments: EditPlaythroughPageArguments(
        boardGameId: boardGameId,
        playthroughId: playthroughId,
        goBackPageRoute: HomePage.pageRoute,
      ),
    );
  }
}

class _PlaythroughDetails extends StatelessWidget {
  const _PlaythroughDetails({
    required this.boardGamePlaythrough,
  });

  static const double _playthroughStatsIconSize = 16;
  static const double _playthroughStatsFontAwesomeIconSize = _playthroughStatsIconSize - 4;

  final BoardGamePlaythrough boardGamePlaythrough;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boardGamePlaythrough.boardGameDetails.name,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        _PlaythroughGeneralStats(
          icon: const Icon(
            FontAwesomeIcons.trophy,
            size: _playthroughStatsFontAwesomeIconSize,
          ),
          statistic: boardGamePlaythrough.gameResultTextFormatted,
        ),
        _PlaythroughGeneralStats(
          icon: const Icon(Icons.people, size: _playthroughStatsIconSize),
          statistic: '${boardGamePlaythrough.playthrough.playerScores.length} players',
        ),
        _PlaythroughGeneralStats(
          icon: const Icon(Icons.hourglass_bottom, size: _playthroughStatsIconSize),
          statistic: boardGamePlaythrough.playthrough.duration.inSeconds
              .toPlaytimeDuration(showSeconds: false),
        ),
      ],
    );
  }
}

class _PlaythroughGeneralStats extends StatelessWidget {
  const _PlaythroughGeneralStats({
    required this.icon,
    required this.statistic,
  });

  final Widget icon;
  final String statistic;

  static const double _uniformedIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: _uniformedIconSize, child: icon),
        const SizedBox(width: Dimensions.standardSpacing),
        Expanded(
          child: Text(
            statistic,
            style: AppTheme.subTitleTextStyle.copyWith(color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }
}

class _PlaythroughActions extends StatelessWidget {
  const _PlaythroughActions({
    required this.onTapBoardGameDetails,
    required this.onTapPlaythroughs,
  });

  final VoidCallback onTapBoardGameDetails;
  final VoidCallback onTapPlaythroughs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => onTapBoardGameDetails(),
        ),
        const Expanded(child: SizedBox.shrink()),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.dice),
          onPressed: () => onTapPlaythroughs(),
        ),
      ],
    );
  }
}

class _NoPlaythroughsSliver extends StatelessWidget {
  const _NoPlaythroughsSliver();

  @override
  Widget build(BuildContext context) => const SliverPadding(
        padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
              Center(
                child: Text(
                  AppText.playsPageHistoryTabEmptyTitle,
                  style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                ),
              ),
              SizedBox(height: Dimensions.doubleStandardSpacing),
              FaIcon(
                FontAwesomeIcons.dice,
                size: Dimensions.emptyPageTitleIconSize,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: Dimensions.doubleStandardSpacing),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: AppText.playPageHistoryTabEmptySubtitle),
                  ],
                ),
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: Dimensions.mediumFontSize),
              ),
            ],
          ),
        ),
      );
}

class _NoBoardGamesSliver extends StatelessWidget {
  const _NoBoardGamesSliver();

  @override
  Widget build(BuildContext context) => const SliverPadding(
        padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
              Center(
                child: Text(
                  AppText.playsPageSelectGameTabEmptyTitle,
                  style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                ),
              ),
              SizedBox(height: Dimensions.doubleStandardSpacing),
              FaIcon(
                Icons.grid_on,
                size: Dimensions.emptyPageTitleIconSize,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: Dimensions.doubleStandardSpacing),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: AppText.playsPageSelectGameTabEmptySubtitle),
                  ],
                ),
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: Dimensions.mediumFontSize),
              ),
            ],
          ),
        ),
      );
}

class _NoBoardGamesToShuffleSliver extends StatelessWidget {
  const _NoBoardGamesToShuffleSliver();

  @override
  Widget build(BuildContext context) => const SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.doubleStandardSpacing,
          vertical: Dimensions.standardSpacing,
        ),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            height: Dimensions.gameSpinnerHeight,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text(
                      AppText.playsPageSelectGameNoBoardGamesToShuffleTitle,
                      style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                    ),
                  ),
                  SizedBox(height: Dimensions.doubleStandardSpacing),
                  FaIcon(
                    FontAwesomeIcons.arrowsSpin,
                    size: Dimensions.emptyPageTitleIconSize,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: Dimensions.doubleStandardSpacing),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(text: AppText.playsPageSelectGameNoBoardGamesToShuffleSubtitle),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: Dimensions.mediumFontSize),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.tabVisualState,
    required this.tabController,
    required this.onTabSelected,
  });

  final PlaysPageVisualState? tabVisualState;
  final TabController tabController;
  final void Function(int tabIndex) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      forceElevated: true,
      elevation: Dimensions.defaultElevation,
      titleSpacing: Dimensions.standardSpacing,
      foregroundColor: AppColors.accentColor,
      title: const Text(AppText.playsPageTitle, style: AppTheme.titleTextStyle),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: TabBar(
          overlayColor: MaterialStateColor.resolveWith((states) => AppColors.accentColor),
          controller: tabController,
          tabs: <Widget>[
            AppBarBottomTab(
              AppText.playsPageHistoryTabTitle,
              Icons.history,
              isSelected: tabVisualState == const PlaysPageVisualState.history(),
            ),
            AppBarBottomTab(
              AppText.playsPageStatisticsTabTitle,
              Icons.query_stats,
              isSelected: tabVisualState == const PlaysPageVisualState.statistics(),
            ),
            AppBarBottomTab(
              AppText.playsPageSelectGameTabTitle,
              Icons.shuffle,
              isSelected: tabVisualState == const PlaysPageVisualState.selectGame(),
            ),
          ],
          indicatorColor: AppColors.accentColor,
          onTap: (int tabIndex) => onTabSelected(tabIndex),
        ),
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({
    required this.historicalPlaythroughs,
  });

  final List<HistoricalPlaythrough> historicalPlaythroughs;

  @override
  Widget build(BuildContext context) {
    if (historicalPlaythroughs.isEmpty) {
      return const _NoPlaythroughsSliver();
    } else {
      return _HistoricalPlaythroughSliverList(
        historicalPlaythroughs: historicalPlaythroughs,
      );
    }
  }
}

class _FilterPlaytime extends BgcSegmentedButton<PlaytimeFilter> {
  _FilterPlaytime.time({
    required super.isSelected,
    required PlaytimeFilter playtimeFilter,
    required Function(PlaytimeFilter) onSelected,
  }) : super(
          value: playtimeFilter,
          onTapped: (_) => onSelected(playtimeFilter),
          child: Center(
            child: Text(
              playtimeFilter.toFormattedText(),
              style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                color: isSelected ? AppColors.defaultTextColor : AppColors.secondaryTextColor,
              ),
            ),
          ),
        );
}
