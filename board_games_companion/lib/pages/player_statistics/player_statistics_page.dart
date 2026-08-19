import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../models/navigation/player_page_arguments.dart';
import '../../models/navigation/player_statistics_page_arguments.dart';
import '../../models/player_overall_statistics.dart';
import '../../widgets/board_games/board_game_image.dart';
import '../../widgets/common/empty_page_information_panel.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/slivers/bgc_sliver_section_wrapper.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../../widgets/common/stats/vertical_statistics_item.dart';
import '../../widgets/player/player_avatar.dart';
import '../base_page_state.dart';
import '../board_game_details/board_game_details_page.dart';
import '../player/player_page.dart';
import 'player_statistics_view_model.dart';
import 'player_statistics_visual_state.dart';

class PlayerStatisticsPage extends StatefulWidget {
  const PlayerStatisticsPage({
    required this.viewModel,
    super.key,
  });

  static const String pageRoute = '/playerStatistics';

  final PlayerStatisticsViewModel viewModel;

  @override
  PlayerStatisticsPageState createState() => PlayerStatisticsPageState();
}

class PlayerStatisticsPageState extends BasePageState<PlayerStatisticsPage> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.loadPlayerStatistics();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Observer(
            builder: (_) => Text(
              widget.viewModel.player?.name ?? '',
              style: AppTheme.titleTextStyle,
            ),
          ),
          actions: [
            Observer(
              builder: (_) {
                final player = widget.viewModel.player;
                if (player == null) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    PlayerPage.pageRoute,
                    arguments: PlayerPageArguments(player: player),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: PageContainer(
            child: Observer(
              builder: (_) {
                return switch (widget.viewModel.visualState) {
                  PlayerStatisticsLoading() => const LoadingIndicator(),
                  PlayerStatisticsEmpty() => _EmptyState(viewModel: widget.viewModel),
                  PlayerStatisticsLoaded(:final statistics) => _LoadedContent(
                      viewModel: widget.viewModel,
                      statistics: statistics,
                    ),
                  _ => const LoadingIndicator(),
                };
              },
            ),
          ),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.viewModel});

  final PlayerStatisticsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(
            player: viewModel.player,
            isPlayerDeleted: viewModel.isPlayerDeleted,
          ),
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: EmptyPageInformationPanel(
              title: AppText.playerStatisticsPageNoPlaysTitle,
              icon: Icon(
                Icons.query_stats,
                size: Dimensions.emptyPageTitleIconSize,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadedContent extends StatelessWidget {
  const _LoadedContent({
    required this.viewModel,
    required this.statistics,
  });

  final PlayerStatisticsViewModel viewModel;
  final PlayerOverallStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(
            player: viewModel.player,
            isPlayerDeleted: viewModel.isPlayerDeleted,
          ),
        ),
        SliverSectionWrapper(
          child: _TotalsAndWinRates(statistics: statistics),
        ),
        if (statistics.gamesByPlays.isNotEmpty) ...[
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.title(
              primaryTitle: AppText.playerStatisticsPageGamesSectionTitle,
            ),
          ),
          SliverSectionWrapper(
            child: _GamesSection(viewModel: viewModel),
          ),
        ],
        if (statistics.rival != null) ...[
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.title(
              primaryTitle: AppText.playerStatisticsPageRivalSectionTitle,
            ),
          ),
          SliverSectionWrapper(
            child: _HeadToHeadRow(record: statistics.rival!),
          ),
        ],
        if (statistics.nemesis != null) ...[
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.title(
              primaryTitle: AppText.playerStatisticsPageNemesisSectionTitle,
            ),
          ),
          SliverSectionWrapper(
            child: _HeadToHeadRow(record: statistics.nemesis!),
          ),
        ],
        if (statistics.buddies.isNotEmpty) ...[
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.title(
              primaryTitle: AppText.playerStatisticsPageBuddiesSectionTitle,
            ),
          ),
          SliverSectionWrapper(
            child: _BuddiesSection(buddies: statistics.buddies),
          ),
        ],
        const SliverPadding(
          padding: EdgeInsets.only(
            bottom: Dimensions.standardSpacing + Dimensions.bottomTabTopHeight,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.player,
    required this.isPlayerDeleted,
  });

  final Player? player;
  final bool isPlayerDeleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isPlayerDeleted) const _DeletedPlayerBanner(),
        Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Center(
            child: SizedBox(
              width: Dimensions.defaultPlayerAvatarSize,
              height: Dimensions.defaultPlayerAvatarSize,
              child: PlayerAvatar(
                player: player,
                avatarImageSize: const Size(
                  Dimensions.defaultPlayerAvatarSize,
                  Dimensions.defaultPlayerAvatarSize,
                ),
                useHeroAnimation: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DeletedPlayerBanner extends StatelessWidget {
  const _DeletedPlayerBanner();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: Container(
                color: AppColors.redColor,
                child: const Center(
                  child: Text(AppText.playerPagePlayerDeletedBanner),
                ),
              ),
            ),
          ),
        ],
      );
}

class _TotalsAndWinRates extends StatelessWidget {
  const _TotalsAndWinRates({required this.statistics});

  final PlayerOverallStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: VerticalStatisticsItem.withMaterialIcon(
                text: statistics.totalPlays.toString(),
                icon: Icons.casino,
                iconColor: AppColors.playedGamesStatColor,
                subtitle: AppText.playerStatisticsPageTotalPlays,
              ),
            ),
            Expanded(
              child: VerticalStatisticsItem.withFontAwesomeIcon(
                text: statistics.totalWins.toString(),
                icon: FontAwesomeIcons.trophy,
                iconColor: AppColors.totalWinsStatColor,
                subtitle: AppText.playerStatisticsPageTotalWins,
              ),
            ),
          ],
        ),
        if (statistics.competitiveWinRate != null || statistics.coopWinRate != null) ...[
          const SizedBox(height: Dimensions.doubleStandardSpacing),
          Row(
            children: [
              if (statistics.competitiveWinRate != null)
                Expanded(
                  child: VerticalStatisticsItem.withMaterialIcon(
                    text: '${(statistics.competitiveWinRate! * 100).toStringAsFixed(0)}%',
                    icon: Icons.leaderboard,
                    iconColor: AppColors.averageScoreStatColor,
                    subtitle: AppText.playerStatisticsPageCompetitiveWinRate,
                  ),
                ),
              if (statistics.coopWinRate != null)
                Expanded(
                  child: VerticalStatisticsItem.withMaterialIcon(
                    text: '${(statistics.coopWinRate! * 100).toStringAsFixed(0)}%',
                    icon: Icons.percent,
                    iconColor: AppColors.averagePlayerCountStatColor,
                    subtitle: AppText.playerStatisticsPageCoopWinRate,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _GamesSection extends StatelessWidget {
  const _GamesSection({required this.viewModel});

  final PlayerStatisticsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final game in viewModel.displayedGames) ...[
              _GameRow(game: game),
              const SizedBox(height: Dimensions.standardSpacing),
            ],
            if (viewModel.canExpandGames)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: viewModel.toggleGamesExpansion,
                  child: Text(
                    viewModel.isGamesListExpanded
                        ? AppText.playerStatisticsPageGamesShowLess
                        : AppText.playerStatisticsPageGamesShowMore,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GameRow extends StatelessWidget {
  const _GameRow({required this.game});

  final GamePlaysCount game;

  static const double _imageSize = 50;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
        onTap: () => Navigator.pushNamed(
          context,
          BoardGamesDetailsPage.pageRoute,
          arguments: BoardGameDetailsPageArguments(
            boardGameId: game.boardGameId,
            navigatingFromType: PlayerStatisticsPage,
            boardGameImageHeroId: game.boardGameId,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
              child: SizedBox(
                width: _imageSize,
                height: _imageSize,
                child: BoardGameImage(
                  id: game.boardGameId,
                  url: game.boardGameImageUrl,
                  minImageHeight: _imageSize,
                ),
              ),
            ),
            const SizedBox(width: Dimensions.standardSpacing),
            Expanded(
              child: Text(
                game.boardGameName,
                style: AppTheme.theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: Dimensions.standardSpacing),
            VerticalStatisticsItem.withMaterialIcon(
              text: game.playCount.toString(),
              icon: Icons.casino,
              iconColor: AppColors.playedGamesStatColor,
              iconSize: Dimensions.defaultButtonIconSize,
              textStyle: const TextStyle(fontSize: Dimensions.mediumFontSize),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeadToHeadRow extends StatelessWidget {
  const _HeadToHeadRow({required this.record});

  final HeadToHeadRecord record;

  @override
  Widget build(BuildContext context) {
    return _OpponentRow(
      player: record.opponent,
      trailing: Text(
        '${record.wins}–${record.losses}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Dimensions.largeFontSize,
        ),
      ),
    );
  }
}

class _BuddiesSection extends StatelessWidget {
  const _BuddiesSection({required this.buddies});

  final List<BuddyRecord> buddies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final buddy in buddies) ...[
          _OpponentRow(
            player: buddy.buddy,
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  buddy.sharedPlaysCount.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.largeFontSize,
                  ),
                ),
                Text(
                  AppText.playerStatisticsPageBuddiesSharedPlays,
                  style: AppTheme.theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
        ],
      ],
    );
  }
}

class _OpponentRow extends StatelessWidget {
  const _OpponentRow({
    required this.player,
    required this.trailing,
  });

  final Player player;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
        onTap: () => Navigator.pushNamed(
          context,
          PlayerStatisticsPage.pageRoute,
          arguments: PlayerStatisticsPageArguments(player: player),
        ),
        child: Row(
          children: [
            SizedBox(
              width: Dimensions.smallPlayerAvatarSize.width,
              height: Dimensions.smallPlayerAvatarSize.height,
              child: PlayerAvatar(
                player: player,
                avatarImageSize: Dimensions.smallPlayerAvatarSize,
                useHeroAnimation: false,
              ),
            ),
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }
}
