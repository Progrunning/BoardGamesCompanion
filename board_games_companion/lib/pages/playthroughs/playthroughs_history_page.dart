import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/dimensions.dart';
import '../../common/enums/game_classification.dart';
import '../../extensions/int_extensions.dart';
import '../../injectable.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/hive/player.dart';
import '../../models/navigation/edit_playthrough_page_arguments.dart';
import '../../models/navigation/playthrough_migration_page_arguments.dart';
import '../../models/playthroughs/playthrough_details.dart';
import '../../utilities/periodic_boardcast_stream.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/empty_page_information_panel.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/panel_container.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/player_score_rank_avatar.dart';
import '../edit_playthrough/edit_playthrough_page.dart';
import 'playthrough_migration.dart';
import 'playthrough_migration_page.dart';
import 'playthroughs_history_view_model.dart';
import 'playthroughs_page.dart';

class PlaythroughsHistoryPage extends StatefulWidget {
  const PlaythroughsHistoryPage({Key? key}) : super(key: key);

  @override
  PlaythroughsHistoryPageState createState() => PlaythroughsHistoryPageState();
}

class PlaythroughsHistoryPageState extends State<PlaythroughsHistoryPage> {
  late PlaythroughsHistoryViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt<PlaythroughsHistoryViewModel>();
    viewModel.loadPlaythroughs();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (viewModel.futureloadPlaythroughs?.status ?? FutureStatus.pending) {
          case FutureStatus.pending:
            return const LoadingIndicator();
          case FutureStatus.fulfilled:
            if (!viewModel.hasAnyPlaythroughs) {
              return const EmptyPageInformationPanel(
                title: AppText.playthroughsHistoryPageNoGamesTitle,
                subtitle: AppText.playthroughsHistoryPageNoGamesSubtitle,
                icon: Icon(
                  Icons.history,
                  size: Dimensions.emptyPageTitleIconSize,
                  color: AppColors.primaryColor,
                ),
                padding: EdgeInsets.only(
                  left: Dimensions.doubleStandardSpacing,
                  top: Dimensions.emptyPageTitleTopSpacing,
                  right: Dimensions.doubleStandardSpacing,
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
              itemBuilder: (_, index) => _Playthrough(
                playthroughDetails: viewModel.playthroughs[index],
                playthroughNumber: viewModel.playthroughs.length - index,
                gameClassification: viewModel.gameClassification,
                isLast: index == viewModel.playthroughs.length - 1,
              ),
              separatorBuilder: (_, index) =>
                  const SizedBox(height: Dimensions.doubleStandardSpacing),
              itemCount: viewModel.playthroughs.length,
            );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _Playthrough extends StatefulWidget {
  const _Playthrough({
    required this.playthroughDetails,
    required this.isLast,
    required this.gameClassification,
    this.playthroughNumber,
    Key? key,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;
  final bool isLast;
  final GameClassification gameClassification;
  final int? playthroughNumber;

  static const double _maxPlaythroughItemHeight = 240;

  @override
  State<_Playthrough> createState() => _PlaythroughState();
}

class _PlaythroughState extends State<_Playthrough> {
  @override
  Widget build(BuildContext context) {
    final migrateToCooperativeResult =
        widget.playthroughDetails.playerScoreBasedGameClassification != widget.gameClassification &&
            widget.gameClassification == GameClassification.NoScore &&
            widget.playthroughDetails.hasAnyScores;

    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
        bottom: widget.isLast ? Dimensions.bottomTabTopHeight : 0,
      ),
      child: PanelContainer(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: math.max(
              _Playthrough._maxPlaythroughItemHeight,
              MediaQuery.of(context).size.height / 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _PlaythroughGameStats(
                  playthroughDetails: widget.playthroughDetails,
                  playthroughNumber: widget.playthroughNumber,
                ),
                const SizedBox(width: Dimensions.doubleStandardSpacing),
                Expanded(
                  child: _PlaythroughPlayersStats(
                    playthroughDetails: widget.playthroughDetails,
                    gameClassification: widget.gameClassification,
                    migrateToCooperativeResult: migrateToCooperativeResult,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaythroughPlayersStats extends StatelessWidget {
  const _PlaythroughPlayersStats({
    Key? key,
    required this.playthroughDetails,
    required this.gameClassification,
    required this.migrateToCooperativeResult,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;
  final GameClassification gameClassification;
  final bool migrateToCooperativeResult;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: _PlaythroughPlayers(
              playthroughDetails: playthroughDetails,
              gameClassification: gameClassification,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (playthroughDetails.hasNotes)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.sticky_note_2_outlined, color: AppColors.accentColor),
                      const SizedBox(width: Dimensions.standardSpacing),
                      Expanded(
                        child: Text(
                          playthroughDetails.latestNote!.text,
                          style: const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: Dimensions.standardSpacing),
                    ],
                  ),
                ),
              if (!playthroughDetails.hasNotes) const Spacer(),
              if (!migrateToCooperativeResult)
                ElevatedIconButton(
                  title: AppText.edit,
                  icon: const DefaultIcon(Icons.edit),
                  color: AppColors.accentColor,
                  onPressed: () => _editPlaythrough(context),
                ),
              if (migrateToCooperativeResult)
                ElevatedIconButton(
                  title: AppText.migrate,
                  color: AppColors.blueColor,
                  icon: const DefaultIcon(
                    Icons.compare_arrows,
                  ),
                  onPressed: () => _migratePlaythrough(context),
                ),
            ],
          ),
        ],
      );

  Future<void> _editPlaythrough(BuildContext context) => Navigator.pushNamed(
        context,
        EditPlaythroughPage.pageRoute,
        arguments: EditPlaythroughPageArguments(
          boardGameId: playthroughDetails.boardGameId,
          playthroughId: playthroughDetails.id,
          goBackPageRoute: PlaythroughsPage.pageRoute,
        ),
      );

  Future<void> _migratePlaythrough(BuildContext context) => Navigator.pushNamed(
        context,
        PlaythroughMigrationPage.pageRoute,
        arguments: PlaythroughMigrationArguments(
          playthroughMigration: PlaythroughMigration.fromScoreToCooperative(
            playthroughDetails: playthroughDetails,
          ),
        ),
      );
}

class _PlaythroughPlayers extends StatelessWidget {
  const _PlaythroughPlayers({
    required this.playthroughDetails,
    required this.gameClassification,
    Key? key,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;
  final GameClassification gameClassification;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: playthroughDetails.playerScores.length,
      separatorBuilder: (context, index) {
        return const SizedBox(width: Dimensions.doubleStandardSpacing);
      },
      itemBuilder: (context, index) {
        switch (gameClassification) {
          case GameClassification.Score:
            return PlayerScoreRankAvatar(
              player: playthroughDetails.playerScores[index].player,
              playerHeroIdSuffix: playthroughDetails.id,
              rank: playthroughDetails.playerScores[index].place,
              score: playthroughDetails.playerScores[index].score.value,
            );
          case GameClassification.NoScore:
            return _PlayerNoScoreAvatar(
              player: playthroughDetails.playerScores[index].player,
              playerHeroIdSuffix: playthroughDetails.id,
              noScoreGameResult: playthroughDetails.playerScores[index].score.noScoreGameResult,
            );
        }
      },
    );
  }
}

class _PlayerNoScoreAvatar extends StatelessWidget {
  const _PlayerNoScoreAvatar({
    required this.player,
    this.playerHeroIdSuffix = '',
    this.noScoreGameResult,
  });

  final Player? player;
  final String playerHeroIdSuffix;
  final NoScoreGameResult? noScoreGameResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Dimensions.smallPlayerAvatarSize.height,
          width: Dimensions.smallPlayerAvatarSize.width,
          child: PlayerAvatar(
            player: player,
            avatarImageSize: Dimensions.smallPlayerAvatarSize,
            playerHeroIdSuffix: playerHeroIdSuffix,
          ),
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        Text(
          noScoreGameResult.toPlayerAvatarDisplayText(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Dimensions.extraLargeFontSize,
          ),
        ),
      ],
    );
  }
}

class _PlaythroughGameStats extends StatelessWidget {
  const _PlaythroughGameStats({
    Key? key,
    required this.playthroughDetails,
    required this.playthroughNumber,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;
  final int? playthroughNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CalendarCard(playthroughDetails.startDate),
        if (playthroughDetails.daysSinceStart == 0)
          const Text(AppText.playthroughsHistoryPageToday),
        if (playthroughDetails.daysSinceStart == 1)
          const Text(AppText.playthroughsHistoryPageYesterday),
        if (playthroughDetails.daysSinceStart > 1)
          _PlaythroughItemDetail(
            playthroughDetails.daysSinceStart.toString(),
            AppText.playthroughsHistoryPageDaysAgo,
          ),
        _PlaythroughItemDetail(
          '$playthroughNumber${playthroughNumber.toOrdinalAbbreviation()}',
          AppText.playthroughsHistoryPageGameNumberSubtitle,
        ),
        _PlaythroughDuration(playthroughDetails: playthroughDetails),
      ],
    );
  }
}

class _PlaythroughDuration extends StatefulWidget {
  const _PlaythroughDuration({
    required this.playthroughDetails,
    Key? key,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;

  @override
  _PlaythroughDurationState createState() => _PlaythroughDurationState();
}

class _PlaythroughDurationState extends State<_PlaythroughDuration> {
  final PeriodicBroadcastStream periodicBroadcastStream =
      PeriodicBroadcastStream(const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();

    if (!widget.playthroughDetails.playthoughEnded) {
      periodicBroadcastStream.stream.listen(_updateDuration);
    }
  }

  @override
  void dispose() {
    if (!widget.playthroughDetails.playthoughEnded) {
      periodicBroadcastStream.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PlaythroughItemDetail(
      widget.playthroughDetails.duration.inSeconds.toPlaytimeDuration(),
      'duration',
    );
  }

  void _updateDuration(void _) {
    if (mounted) {
      setState(() {});
    }
  }
}

class _PlaythroughItemDetail extends StatelessWidget {
  const _PlaythroughItemDetail(
    this.title,
    this.subtitle, {
    Key? key,
  }) : super(key: key);

  final String subtitle;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemPropertyValue(title),
        ItemPropertyTitle(subtitle),
      ],
    );
  }
}
