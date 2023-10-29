import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobx/mobx.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/player_score.dart';
import '../../widgets/common/empty_page_information_panel.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/cooperative_game_result_segmented_button.dart';
import 'playthrough_migration_progress.dart';
import 'playthrough_migration_view_model.dart';
import 'playthroughs_page.dart';

class PlaythroughMigrationPage extends StatefulWidget {
  const PlaythroughMigrationPage({
    required this.viewModel,
    super.key,
  });

  final PlaythroughMigrationViewModel viewModel;

  static const String pageRoute = '/playthroughMigration';

  @override
  State<PlaythroughMigrationPage> createState() => _PlaythroughMigrationPageState();
}

class _PlaythroughMigrationPageState extends State<PlaythroughMigrationPage> {
  late ReactionDisposer _restoreMigrationProgressReactionDisposer;

  @override
  void initState() {
    super.initState();

    _restoreMigrationProgressReactionDisposer =
        reaction((_) => widget.viewModel.playthroughMighrationProgress,
            (PlaythroughMigrationProgress migrationProgress) {
      migrationProgress.maybeWhen(
        invalid: (errorMessage) => _showMigrationSnackbar(context, errorMessage),
        failure: () => _showMigrationSnackbar(context, AppText.playthroughMigrationFailureSnackbar),
        success: () => Navigator.pop(context),
        orElse: () {},
      );
    });
  }

  @override
  void dispose() {
    _restoreMigrationProgressReactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => _handleOnWillPop(context),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              AppText.playthroughMigrationPageTitle,
              style: AppTheme.titleTextStyle,
            ),
          ),
          body: Observer(
            builder: (_) {
              return CustomScrollView(
                slivers: [
                  widget.viewModel.playthroughMighration.maybeWhen(
                    fromScoreToCooperative: (playthroughDetails, cooperativeGameResult) {
                      return MultiSliver(
                        children: [
                          const _OverviewSection(),
                          _ResultSection(
                            cooperativeGameResult: cooperativeGameResult,
                            onCooperativeGameResultChanged: (selectedResult) =>
                                widget.viewModel.updateCooperativeGameResult(selectedResult),
                          ),
                          _PlayerScoresSection(
                            playerScores: playthroughDetails.playerScores,
                            onPlayerScoreRemoved: (playerScore) =>
                                widget.viewModel.removePlayerScore(playerScore),
                          ),
                        ],
                      );
                    },
                    orElse: () => const SliverFillRemaining(
                      child: Center(
                        child: EmptyPageInformationPanel(
                          title: AppText.playthroughMigrationPageInvalidMigrationTitle,
                          subtitle: AppText.playthroughMigrationPageInvalidMigrationSubtitle,
                          icon: Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: Observer(
            builder: (_) {
              return widget.viewModel.playthroughMighrationProgress.maybeWhen(
                orElse: () => FloatingActionButton(
                  onPressed: () => widget.viewModel.migrate(),
                  backgroundColor: AppColors.blueColor,
                  child: const Icon(Icons.compare_arrows),
                ),
                inProgress: () => const FloatingActionButton(
                  onPressed: null,
                  backgroundColor: AppColors.blueColor,
                  child: CircularProgressIndicator(color: AppColors.accentColor),
                ),
              );
            },
          ),
        ),
      );

  void _showMigrationSnackbar(BuildContext context, String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: Dimensions.snackbarMargin.copyWith(bottom: Dimensions.standardSpacing),
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }

  Future<bool> _handleOnWillPop(BuildContext context) async {
    if (!widget.viewModel.isDirty) {
      return true;
    }

    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppText.playthroughMigrationPageMigrationNotFinishedDialogTitle),
          content: const Text(AppText.playthroughMigrationPageMigrationNotFinishedDialogContent),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(AppText.cancel, style: TextStyle(color: AppColors.accentColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () async =>
                  Navigator.of(context).popUntil(ModalRoute.withName(PlaythroughsPage.pageRoute)),
              child: const Text(
                AppText.playthroughMigrationPageMigrationNotFinishedActionButtonText,
                style: TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );

    return false;
  }
}

class _PlayerScoresSection extends StatelessWidget {
  const _PlayerScoresSection({
    required this.playerScores,
    required this.onPlayerScoreRemoved,
  });

  final List<PlayerScore> playerScores;
  final void Function(PlayerScore) onPlayerScoreRemoved;

  bool get hasMultiplePlayerScores => playerScores.length > 1;

  @override
  Widget build(BuildContext context) => MultiSliver(
        children: [
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.title(
              primaryTitle: AppText.playthroughMigrationPageMigrationPlayerScoresHeader,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  final int itemIndex = index ~/ 2;
                  if (index.isEven) {
                    final playerScoreRow = Row(
                      children: [
                        Expanded(
                          child: _PlayerScoreTile(
                            playerScore: playerScores[itemIndex],
                          ),
                        ),
                      ],
                    );
                    if (hasMultiplePlayerScores) {
                      return Slidable(
                        endActionPane: ActionPane(
                          extentRatio: 0.25,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              icon: Icons.delete,
                              onPressed: (_) => onPlayerScoreRemoved(playerScores[itemIndex]),
                              backgroundColor: AppColors.redColor,
                            ),
                          ],
                        ),
                        child: playerScoreRow,
                      );
                    }

                    return playerScoreRow;
                  }

                  return const SizedBox(height: Dimensions.doubleStandardSpacing);
                },
                childCount: max(0, playerScores.length * 2 - 1),
              ),
            ),
          ),
        ],
      );
}

class _PlayerScoreTile extends StatelessWidget {
  const _PlayerScoreTile({
    required this.playerScore,
  });

  final PlayerScore playerScore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: SizedBox(
        height: Dimensions.smallPlayerAvatarSize.height,
        child: Row(
          children: <Widget>[
            SizedBox(
              height: Dimensions.smallPlayerAvatarSize.height,
              width: Dimensions.smallPlayerAvatarSize.width,
              child: PlayerAvatar(
                player: playerScore.player,
                avatarImageSize: Dimensions.smallPlayerAvatarSize,
              ),
            ),
            const SizedBox(width: Dimensions.standardSpacing),
            Expanded(
              child: _PlayerScore(score: playerScore.score.scoreFormatted ?? '-'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    required this.score,
  });

  final String score;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(width: Dimensions.standardSpacing),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              score,
              style: AppStyles.playerScoreTextStyle,
            ),
            const SizedBox(height: Dimensions.halfStandardSpacing),
            Text(AppText.editPlaythroughScorePoints, style: AppTheme.theme.textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.cooperativeGameResult,
    required this.onCooperativeGameResultChanged,
  });

  final CooperativeGameResult? cooperativeGameResult;
  final void Function(CooperativeGameResult) onCooperativeGameResultChanged;

  @override
  Widget build(BuildContext context) => MultiSliver(
        children: [
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.title(
              primaryTitle: AppText.playthroughMigrationPageMigrationResultHeader,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const Text(
                    AppText.editPlaythroughNoScoreResultText,
                    style: AppTheme.defaultTextFieldStyle,
                  ),
                  const Spacer(),
                  CooperativeGameResultSegmentedButton(
                    cooperativeGameResult: cooperativeGameResult,
                    onCooperativeGameResultChanged: (cooperativeGameResult) =>
                        onCooperativeGameResultChanged(cooperativeGameResult),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection();

  @override
  Widget build(BuildContext context) => MultiSliver(
        children: [
          SliverPersistentHeader(
            delegate: BgcSliverTitleHeaderDelegate.title(
              primaryTitle: AppText.playthroughMigrationPageMigrationOverviewHeader,
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.standardSpacing),
              child: Column(
                children: [
                  Text(
                    AppText.playthroughMigrationPageMigrationOverviewContent,
                    style: AppTheme.defaultTextFieldStyle,
                  ),
                  SizedBox(height: Dimensions.doubleStandardSpacing),
                  InfoPanel(text: AppText.playthroughMigrationPageMigrationOverviewAiInfo),
                  SizedBox(height: Dimensions.halfStandardSpacing),
                  InfoPanel(text: AppText.playthroughMigrationPagePlayerScoresInfo),
                ],
              ),
            ),
          ),
        ],
      );
}
