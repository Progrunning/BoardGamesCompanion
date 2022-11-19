import 'package:board_games_companion/extensions/int_extensions.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_page.dart';
import 'package:board_games_companion/pages/playthroughs_history/board_game_playthrough.dart';
import 'package:board_games_companion/pages/playthroughs_history/grouped_board_game_playthroughs.dart';
import 'package:board_games_companion/pages/playthroughs_history/playthroughs_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/panel_container.dart';
import '../../widgets/common/slivers/bgc_sliver_header_delegate.dart';
import '../board_game_details/board_game_details_page.dart';

class PlaythroughsHistoryPage extends StatefulWidget {
  const PlaythroughsHistoryPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PlaythroughsHistoryViewModel viewModel;

  @override
  State<PlaythroughsHistoryPage> createState() => _PlaythroughsHistoryPageState();
}

class _PlaythroughsHistoryPageState extends State<PlaythroughsHistoryPage> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.loadGamesPlaythroughs();
  }

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          switch (widget.viewModel.futureLoadGamesPlaythroughs?.status ?? FutureStatus.pending) {
            case FutureStatus.pending:
            case FutureStatus.rejected:
              return const CustomScrollView(
                slivers: [
                  _AppBar(),
                  SliverFillRemaining(child: LoadingIndicator()),
                ],
              );
            case FutureStatus.fulfilled:
              return CustomScrollView(
                slivers: [
                  const _AppBar(),
                  if (!widget.viewModel.hasAnyFinishedPlaythroughs) const _NoPlaythroughsSliver(),
                  for (final groupedBoardGamePlaythroughs
                      in widget.viewModel.finishedBoardGamePlaythroughs) ...[
                    _PlaythroughGroupHeaderSliver(
                      widget: widget,
                      groupedBoardGamePlaythroughs: groupedBoardGamePlaythroughs,
                    ),
                    _PlaythroughGroupListSliver(
                      groupedBoardGamePlaythroughs: groupedBoardGamePlaythroughs,
                    ),
                  ]
                ],
              );
          }
        },
      );
}

class _PlaythroughGroupListSliver extends StatelessWidget {
  const _PlaythroughGroupListSliver({
    Key? key,
    required this.groupedBoardGamePlaythroughs,
  }) : super(key: key);

  final GroupedBoardGamePlaythroughs groupedBoardGamePlaythroughs;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final boardGamePlaythrough = groupedBoardGamePlaythroughs.boardGamePlaythroughs[index];
          return Padding(
            padding: const EdgeInsets.only(
              top: Dimensions.standardSpacing,
              bottom: Dimensions.standardSpacing,
              left: Dimensions.standardSpacing,
              right: Dimensions.standardSpacing,
            ),
            child: PanelContainer(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicHeight(
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
                            child: _PlaythroughDetails(boardGamePlaythrough: boardGamePlaythrough),
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
          );
        },
        childCount: groupedBoardGamePlaythroughs.boardGamePlaythroughs.length,
      ),
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
        boardGameName: boardGamePlaythrough.boardGameDetails.name,
        boardGameImageHeroId: boardGamePlaythrough.id,
        navigatingFromType: PlaythroughsHistoryPage,
      ),
    );
  }
}

class _PlaythroughDetails extends StatelessWidget {
  const _PlaythroughDetails({
    Key? key,
    required this.boardGamePlaythrough,
  }) : super(key: key);

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
          statistic:
              '${boardGamePlaythrough.winner.player?.name ?? ''} (${boardGamePlaythrough.winner.score.valueInt} points)',
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
    Key? key,
    required this.icon,
    required this.statistic,
  }) : super(key: key);

  final Widget icon;
  final String statistic;

  static const double _uniformedIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: _uniformedIconSize, child: Center(child: icon)),
        const SizedBox(width: Dimensions.standardSpacing),
        Text(
          statistic,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.subTitleTextStyle.copyWith(color: AppColors.whiteColor),
        ),
      ],
    );
  }
}

class _PlaythroughActions extends StatelessWidget {
  const _PlaythroughActions({
    Key? key,
    required this.onTapBoardGameDetails,
    required this.onTapPlaythroughs,
  }) : super(key: key);

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

class _PlaythroughGroupHeaderSliver extends StatelessWidget {
  const _PlaythroughGroupHeaderSliver({
    Key? key,
    required this.widget,
    required this.groupedBoardGamePlaythroughs,
  }) : super(key: key);

  final PlaythroughsHistoryPage widget;
  final GroupedBoardGamePlaythroughs groupedBoardGamePlaythroughs;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: BgcSliverHeaderDelegate(primaryTitle: groupedBoardGamePlaythroughs.dateFormtted),
    );
  }
}

class _NoPlaythroughsSliver extends StatelessWidget {
  const _NoPlaythroughsSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
              Center(
                child: Text(
                  AppText.playHistoryPageEmptyTitle,
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
                    TextSpan(
                      text: AppText.playHistoryPageEmptyTextPartOne,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: AppText.playHistoryPageEmptyTextPartTwo),
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

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      pinned: true,
      floating: true,
      elevation: Dimensions.defaultElevation,
      titleSpacing: Dimensions.standardSpacing,
      foregroundColor: AppColors.accentColor,
      title: Text(AppText.playHistoryPageTitle, style: AppTheme.titleTextStyle),
    );
  }
}
