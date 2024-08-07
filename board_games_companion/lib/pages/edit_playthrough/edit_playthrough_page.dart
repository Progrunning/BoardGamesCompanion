import 'dart:math' as math;
import 'dart:math';

import 'package:basics/basics.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/pages/edit_playthrough/playthrough_scores_visual_state.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../mixins/enter_score_dialog.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/hive/player.dart';
import '../../models/hive/playthrough_note.dart';
import '../../models/navigation/playthough_note_page_arguments.dart';
import '../../models/player_score.dart';
import '../../utilities/periodic_boardcast_stream.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../../widgets/common/tile_positioned_rank_ribbon.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/cooperative_game_result_segmented_button.dart';
import '../../widgets/playthrough/playthrough_note_list_item.dart';
import '../enter_score/enter_score_view_model.dart';
import 'edit_playthrough_view_model.dart';
import 'playthrough_note_page.dart';

class EditPlaythroughPage extends StatefulWidget {
  const EditPlaythroughPage({
    required this.viewModel,
    required this.goBackPageRoute,
    super.key,
  });

  static const String pageRoute = '/editPlaythrough';

  final EditPlaythoughViewModel viewModel;
  final String goBackPageRoute;

  @override
  EditPlaythroughPageState createState() => EditPlaythroughPageState();
}

class EditPlaythroughPageState extends State<EditPlaythroughPage> with EnterScoreDialogMixin {
  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) async => _handleOnPop(context, didPop: didPop),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(AppText.editPlaythroughPageTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _close(context),
              ),
            ],
          ),
          body: SafeArea(
            child: PageContainer(
              child: Observer(builder: (_) {
                return CustomScrollView(
                  slivers: [
                    _PlayDateTimeSection(viewModel: widget.viewModel),
                    widget.viewModel.editPlaythroughPageVisualState.when(
                      init: () => const SizedBox.shrink(),
                      editScoreGame: (_) => Observer(
                        builder: (context) {
                          return _ScoresSection(
                            playthroughScoresVisualState:
                                widget.viewModel.playthroughScoresVisualState,
                            playthroughDetailsId: widget.viewModel.playthroughDetails?.id,
                            onItemTapped: (PlayerScore playerScore) async =>
                                _editPlayerScore(playerScore, context),
                            onReorder: (oldIndex, newIndex) =>
                                widget.viewModel.reorderPlayerScores(oldIndex, newIndex),
                            onToggleSharedPlaceTiebreaker: (playerScore, sharePlace) => widget
                                .viewModel
                                .toggleSharedPlaceTiebreaker(playerScore, sharePlace),
                          );
                        },
                      ),
                      editNoScoreGame: (_) => _NoScoreSection(
                        playthroughId: widget.viewModel.playthrough.id,
                        players: widget.viewModel.players,
                        cooperativeGameResult: widget.viewModel.cooperativeGameResult,
                        onCooperativeGameResultChanged: (cooperativeGameResult) =>
                            widget.viewModel.updateCooperativeGameResult(cooperativeGameResult),
                      ),
                    ),
                    if (widget.viewModel.hasNotes)
                      _NotesSection(
                        notes: widget.viewModel.notes!,
                        onTap: (note) => _editNote(note),
                        onDelete: (note) => _deleteNote(note),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: Dimensions.floatingActionButtonBottomSpacing),
                    ),
                  ],
                );
              }),
            ),
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.menu,
            backgroundColor: AppColors.accentColor,
            activeBackgroundColor: AppColors.redColor,
            overlayColor: AppColors.dialogBackgroundColor,
            activeIcon: Icons.close,
            openCloseDial: widget.viewModel.isSpeedDialContextMenuOpen,
            onPress: () => widget.viewModel.isSpeedDialContextMenuOpen.value =
                !widget.viewModel.isSpeedDialContextMenuOpen.value,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.save),
                backgroundColor: AppColors.accentColor,
                foregroundColor: Colors.white,
                label: AppText.save,
                labelBackgroundColor: AppColors.accentColor,
                shape: const CircleBorder(),
                onTap: () async => _save(),
              ),
              if (!widget.viewModel.playthoughEnded)
                SpeedDialChild(
                  child: const Icon(Icons.stop),
                  backgroundColor: AppColors.blueColor,
                  foregroundColor: Colors.white,
                  label: AppText.stop,
                  labelBackgroundColor: AppColors.blueColor,
                  shape: const CircleBorder(),
                  onTap: () async => _stopPlaythrough(),
                ),
              SpeedDialChild(
                child: const Icon(Icons.note_add),
                backgroundColor: AppColors.greenColor,
                foregroundColor: Colors.white,
                label: AppText.editPlaythroughAddNote,
                labelBackgroundColor: AppColors.greenColor,
                shape: const CircleBorder(),
                onTap: () async => _addNote(),
              ),
              SpeedDialChild(
                child: const Icon(Icons.delete),
                backgroundColor: AppColors.redColor,
                foregroundColor: Colors.white,
                label: AppText.delete,
                labelBackgroundColor: AppColors.redColor,
                shape: const CircleBorder(),
                onTap: () async => _showDeletePlaythroughDialog(context),
              ),
            ],
          ),
        ),
      );

  Future<double> _editPlayerScore(PlayerScore playerScore, BuildContext context) async {
    final viewModel = EnterScoreViewModel(playerScore);
    if (playerScore.id.isNullOrBlank) {
      // MK Unsure in which circumstances a player wouldn't have an id defined
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(
          margin: Dimensions.snackbarMargin,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
          content: Text(AppText.editPlaythroughCannotUpdateScore),
        ),
      );

      return viewModel.score;
    }

    await showEnterScoreDialog(context, viewModel);
    widget.viewModel.updatePlayerScore(playerScore.id!, viewModel.score);
    return viewModel.score;
  }

  Future<void> _save() async {
    await widget.viewModel.saveChanges();
    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  Future<void> _stopPlaythrough() async {
    await widget.viewModel.stopPlaythrough();
    setState(() {});
  }

  Future<void> _close(BuildContext context) async {
    _handleOnPop(context, didPop: false);
  }

  Future<void> _showDeletePlaythroughDialog(BuildContext context) async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppText.editPlaythroughPageDeleteConfirmationDialogTitle),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(AppText.cancel, style: TextStyle(color: AppColors.accentColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () async {
                await widget.viewModel.deletePlaythrough();
                if (!context.mounted) {
                  return;
                }

                Navigator.of(context).popUntil(ModalRoute.withName(widget.goBackPageRoute));
              },
              child:
                  const Text(AppText.delete, style: TextStyle(color: AppColors.defaultTextColor)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleOnPop(BuildContext context, {required bool didPop}) async {
    if (didPop) {
      return;
    }

    if (!widget.viewModel.isDirty) {
      Navigator.of(context).pop();
      return;
    }

    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppText.editPlaythroughPageUnsavedChangesDialogTitle),
          content: const Text(AppText.editPlaythroughPageUnsavedChangesDialogContent),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(AppText.cancel, style: TextStyle(color: AppColors.accentColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () async {
                Navigator.of(context).popUntil(ModalRoute.withName(widget.goBackPageRoute));
              },
              child: const Text(
                AppText.editPlaythroughPageUnsavedChangesActionButtonText,
                style: TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addNote() async {
    final PlaythroughNote? addedNote = await Navigator.of(context).pushNamed(
      PlaythroughNotePage.pageRoute,
      arguments: const PlaythroughNotePageArguments(),
    );

    if (addedNote == null) {
      return;
    }

    widget.viewModel.addPlaythroughNote(addedNote);
  }

  Future<void> _editNote(PlaythroughNote note) async {
    final PlaythroughNote? editedNote = await Navigator.of(context).pushNamed(
      PlaythroughNotePage.pageRoute,
      arguments: PlaythroughNotePageArguments(note: note),
    );

    if (editedNote == null) {
      return;
    }

    widget.viewModel.editPlaythroughNote(editedNote);
  }

  Future<void> _deleteNote(PlaythroughNote note) async {
    widget.viewModel.deletePlaythroughNote(note);
  }
}

class _ScoresSection extends StatelessWidget {
  const _ScoresSection({
    required this.playthroughScoresVisualState,
    required this.playthroughDetailsId,
    required this.onItemTapped,
    required this.onReorder,
    required this.onToggleSharedPlaceTiebreaker,
  });

  final PlaythroughScoresVisualState playthroughScoresVisualState;
  final String? playthroughDetailsId;
  final Future<double> Function(PlayerScore) onItemTapped;
  final void Function(int currentIndex, int newIndex) onReorder;
  final void Function(PlayerScore playerScore, bool sharePlace) onToggleSharedPlaceTiebreaker;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPersistentHeader(
          pinned: true,
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.editPlaythroughScoresHeaderTitle,
          ),
        ),
        playthroughScoresVisualState.maybeWhen(
          finishedScoring: (_, scoreTiebreakersSet, __) {
            if (scoreTiebreakersSet.isNotEmpty) {
              return const _ScoreTieBreakerInstruction();
            }
            return const SizedBox.shrink();
          },
          orElse: () => const SizedBox.shrink(),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
          sliver: playthroughScoresVisualState.when(
            init: () => const SliverFillRemaining(child: LoadingIndicator()),
            finishedScoring: (playerScores, scoreTiebreakersSet, _) {
              if (scoreTiebreakersSet.isNotEmpty) {
                return _ReordableScoreSliverList(
                  onItemTapped: onItemTapped,
                  onReorder: onReorder,
                  playerScores: playerScores,
                  playthroughDetailsId: playthroughDetailsId,
                  scoreTiebreakersSet: scoreTiebreakersSet,
                  onToggleSharedPlaceTiebreaker: (playerScore, sharePlace) =>
                      onToggleSharedPlaceTiebreaker(playerScore, sharePlace),
                );
              }

              return _ScoresSliverList(
                key: const Key('PlayerScoresFinishedScoring'),
                onItemTapped: onItemTapped,
                playerScores: playerScores,
                playthroughDetailsId: playthroughDetailsId,
                hasFinishedScoring: true,
              );
            },
            scoring: (playerScores) => _ScoresSliverList(
              key: const Key('PlayerScoresScoring'),
              onItemTapped: onItemTapped,
              playerScores: playerScores,
              playthroughDetailsId: playthroughDetailsId,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReordableScoreSliverList extends StatelessWidget {
  const _ReordableScoreSliverList({
    required this.playerScores,
    required this.scoreTiebreakersSet,
    required this.playthroughDetailsId,
    required this.onItemTapped,
    required this.onReorder,
    required this.onToggleSharedPlaceTiebreaker,
  });

  final List<PlayerScore> playerScores;
  final Map<String, ScoreTiebreakerType> scoreTiebreakersSet;
  final String? playthroughDetailsId;
  final Future<double> Function(PlayerScore playerScore) onItemTapped;
  final void Function(int currentIndex, int newIndex) onReorder;
  final void Function(PlayerScore playerScore, bool sharePlace) onToggleSharedPlaceTiebreaker;

  @override
  Widget build(BuildContext context) {
    return SliverReorderableList(
      itemBuilder: (_, index) {
        final int itemIndex = index ~/ 2;
        final playerScore = playerScores[itemIndex];
        if (index.isEven) {
          return _PlayerScoreTile(
            key: ObjectKey(playerScore),
            reordableIndex: index,
            playerScore: playerScore,
            playthroughDetailsId: playthroughDetailsId,
            onItemTapped: onItemTapped,
            hasFinishedScoring: true,
            onToggleSharedPlaceTiebreaker: (sharePlace) =>
                onToggleSharedPlaceTiebreaker(playerScore, sharePlace),
          );
        }

        return SizedBox(
          key: Key('PlayerScoreSeparator${playerScore.id}'),
          height: Dimensions.doubleStandardSpacing,
        );
      },
      itemCount: max(0, playerScores.length * 2 - 1),
      onReorder: (int currentIndex, int newIndex) =>
          _handleScoresReorder(context, currentIndex, newIndex),
    );
  }

  void _handleScoresReorder(BuildContext context, int currentIndex, int newIndex) {
    final itemsCurrentIndex = currentIndex ~/ 2;
    final itemsNewIndex = newIndex ~/ 2;
    if (scoreTiebreakersSet[playerScores[itemsCurrentIndex].id] == null ||
        scoreTiebreakersSet[playerScores[itemsNewIndex].id] == null) {
      _showCannotReorderNotTiedScore(context);
      return;
    }

    if (scoreTiebreakersSet[playerScores[itemsCurrentIndex].id] == ScoreTiebreakerType.shared ||
        scoreTiebreakersSet[playerScores[itemsNewIndex].id] == ScoreTiebreakerType.shared) {
      _showCannotReorderSharedPlaceScore(context);
      return;
    }

    onReorder(itemsCurrentIndex, itemsNewIndex);
  }

  void _showCannotReorderNotTiedScore(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        margin: Dimensions.snackbarMargin,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text(AppText.editPlaythroughPageCannotReorderNotTiedScore),
      ),
    );
  }

  void _showCannotReorderSharedPlaceScore(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        margin: Dimensions.snackbarMargin,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text(AppText.editPlaythroughPageCannotReorderSharedPlaceScore),
      ),
    );
  }
}

class _ScoresSliverList extends StatelessWidget {
  const _ScoresSliverList({
    required super.key,
    required this.playerScores,
    required this.playthroughDetailsId,
    required this.onItemTapped,
    this.hasFinishedScoring = false,
  });

  final List<PlayerScore> playerScores;
  final String? playthroughDetailsId;
  final Future<double> Function(PlayerScore) onItemTapped;
  final bool hasFinishedScoring;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final int itemIndex = index ~/ 2;
          if (index.isEven) {
            final playerScore = playerScores[itemIndex];
            return _PlayerScoreTile(
              // Giving it a key in order to force re-render when finishedScoring state
              // kicks in. Otherwise the old scores would show on the screen
              key: ObjectKey(playerScore),
              playerScore: playerScore,
              playthroughDetailsId: playthroughDetailsId,
              onItemTapped: onItemTapped,
              hasFinishedScoring: hasFinishedScoring,
            );
          }

          return const SizedBox(height: Dimensions.doubleStandardSpacing);
        },
        childCount: max(0, playerScores.length * 2 - 1),
      ),
    );
  }
}

class _ScoreTieBreakerInstruction extends StatelessWidget {
  const _ScoreTieBreakerInstruction();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppText.editPlaythroughPageTieBreakerInstruction,
              style: AppTheme.theme.textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ).animate().fade(),
          ),
        ],
      ),
    );
  }
}

class _NoScoreSection extends StatelessWidget {
  const _NoScoreSection({
    required this.playthroughId,
    required this.cooperativeGameResult,
    required this.players,
    required this.onCooperativeGameResultChanged,
  });

  final String playthroughId;
  final CooperativeGameResult? cooperativeGameResult;
  final List<Player> players;
  final void Function(CooperativeGameResult) onCooperativeGameResultChanged;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPersistentHeader(
          pinned: true,
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.editPlaythroughNoScoreResultHeaderTitle,
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
        SliverPersistentHeader(
          pinned: true,
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.editPlaythroughNoScorePlayersHeaderTitle,
          ),
        ),
        Observer(
          builder: (_) {
            return SliverPadding(
              padding: const EdgeInsets.all(Dimensions.standardSpacing),
              sliver: SliverGrid.extent(
                crossAxisSpacing: Dimensions.standardSpacing,
                mainAxisSpacing: Dimensions.standardSpacing,
                maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
                children: [
                  for (final player in players)
                    SizedBox(
                      height: Dimensions.smallPlayerAvatarSize.height,
                      width: Dimensions.smallPlayerAvatarSize.width,
                      child: PlayerAvatar(
                        player: player,
                        playerHeroIdSuffix: playthroughId,
                        avatarImageSize: Dimensions.smallPlayerAvatarSize,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({
    required this.notes,
    required this.onTap,
    required this.onDelete,
  });

  final List<PlaythroughNote> notes;
  final void Function(PlaythroughNote) onTap;
  final void Function(PlaythroughNote) onDelete;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPersistentHeader(
          pinned: true,
          delegate: BgcSliverTitleHeaderDelegate.title(
            primaryTitle: AppText.editPlaythroughNotesHeaderTitle,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return PlaythroughNoteListItem(
                onTap: onTap,
                note: notes[index],
                onDelete: onDelete,
              );
            },
            childCount: notes.length,
          ),
        ),
        // MK Adding padding to the bottom of the list to avoid overlap of the FOB with the notes
        const SliverPadding(
          padding: EdgeInsets.only(
            bottom: Dimensions.floatingActionButtonBottomSpacing + Dimensions.standardSpacing,
          ),
        ),
      ],
    );
  }
}

class _PlayerScoreTile extends StatefulWidget {
  const _PlayerScoreTile({
    super.key,
    required this.playerScore,
    required this.playthroughDetailsId,
    required this.hasFinishedScoring,
    required this.onItemTapped,
    this.onToggleSharedPlaceTiebreaker,
    this.reordableIndex,
  });

  final PlayerScore playerScore;
  final String? playthroughDetailsId;
  final int? reordableIndex;
  final bool hasFinishedScoring;
  final Future<double> Function(PlayerScore) onItemTapped;
  final void Function(bool sharePlace)? onToggleSharedPlaceTiebreaker;

  @override
  State<_PlayerScoreTile> createState() => _PlayerScoreTileState();
}

class _PlayerScoreTileState extends State<_PlayerScoreTile> {
  late double? score;

  @override
  void initState() {
    super.initState();

    score = widget.playerScore.score.score;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final newScore = await widget.onItemTapped(widget.playerScore);
          setState(() {
            score = newScore;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
          child: SizedBox(
            height: Dimensions.smallPlayerAvatarSize.height,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: Dimensions.smallPlayerAvatarSize.height,
                  width: Dimensions.smallPlayerAvatarSize.width,
                  child: Stack(children: [
                    PlayerAvatar(
                      player: widget.playerScore.player,
                      avatarImageSize: Dimensions.smallPlayerAvatarSize,
                      playerHeroIdSuffix: widget.playthroughDetailsId ?? '',
                    ),
                    if (widget.hasFinishedScoring)
                      PositionedTileRankRibbon(
                        rank: widget.playerScore.score.scoreGameResult?.place ?? 0,
                      )
                    else
                      const SizedBox.shrink(),
                  ]),
                ),
                const SizedBox(width: Dimensions.standardSpacing),
                Expanded(child: _PlayerScore(score: score)),
                if (widget.playerScore.score.isTied && widget.reordableIndex != null) ...[
                  Checkbox(
                    value: widget.playerScore.score.scoreGameResult?.tiebreakerType ==
                        ScoreTiebreakerType.shared,
                    onChanged: (value) async {
                      widget.onToggleSharedPlaceTiebreaker?.call(value ?? false);
                    },
                  ),
                  ReorderableDragStartListener(
                    index: widget.reordableIndex!,
                    child: const Icon(Icons.drag_handle, size: Dimensions.largeIconSize),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    required this.score,
  });

  final double? score;

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
              score?.toStringAsFixed(0) ?? '-',
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

class _PlayDateTimeSection extends StatefulWidget {
  const _PlayDateTimeSection({
    required this.viewModel,
  });

  final EditPlaythoughViewModel viewModel;

  @override
  _PlayDateTimeSectionState createState() => _PlayDateTimeSectionState();
}

class _PlayDateTimeSectionState extends State<_PlayDateTimeSection> {
  static const int _maxHours = 99;

  late Duration playthroughDuration;
  int? playthroughDurationInSeconds;
  late int hoursPlayed;
  late int minutesPlyed;

  late int minHours;
  late int maxHours;
  late int minMinutes;
  late int maxMinutes;

  // MK An arbitrary number of seconds to refresh the duration
  final PeriodicBroadcastStream _refreshPlayDurationPeriodicStream =
      PeriodicBroadcastStream(const Duration(seconds: 10));

  @override
  void initState() {
    super.initState();

    if (!widget.viewModel.playthoughEnded) {
      _refreshPlayDurationPeriodicStream.stream.listen(_updateDuration);
    }
  }

  @override
  void dispose() {
    _refreshPlayDurationPeriodicStream.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    playthroughDuration = widget.viewModel.playthoughDuration;
    playthroughDurationInSeconds = playthroughDuration.inSeconds;
    hoursPlayed = playthroughDuration.inHours;
    minutesPlyed = playthroughDuration.inMinutes - hoursPlayed * Duration.minutesPerHour;

    _setHourseAndMinutesRange();
    return MultiSliver(
      children: [
        SliverPersistentHeader(
          delegate: BgcSliverTitleHeaderDelegate.titles(
            primaryTitle: AppText.editPlaythroughDateHeaderTitle,
            secondaryTitle: AppText.editPlaythroughDurationHeaderTitle,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
            child: Row(
              children: [
                Center(
                  child: Observer(
                    builder: (_) {
                      return CalendarCard(
                        widget.viewModel.playthroughStartTime,
                        onTap: widget.viewModel.playthoughEnded ? () => _pickStartDate() : null,
                      );
                    },
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
                AbsorbPointer(
                  absorbing: !widget.viewModel.playthoughEnded,
                  child: Row(
                    children: <Widget>[
                      NumberPicker(
                        value: math.min(hoursPlayed, _maxHours),
                        minValue: minHours,
                        maxValue: maxHours,
                        onChanged: (num value) => _updateDurationHours(value),
                        itemWidth: 46,
                        selectedTextStyle: const TextStyle(
                          color: AppColors.accentColor,
                          fontSize: Dimensions.doubleExtraLargeFontSize,
                        ),
                      ),
                      Text('h', style: AppTheme.theme.textTheme.bodyMedium),
                      const SizedBox(width: Dimensions.halfStandardSpacing),
                      NumberPicker(
                        value: minutesPlyed,
                        infiniteLoop: true,
                        minValue: minMinutes,
                        maxValue: maxMinutes,
                        onChanged: (num value) => _updateDurationMinutes(value),
                        itemWidth: 46,
                        selectedTextStyle: const TextStyle(
                          color: AppColors.accentColor,
                          fontSize: Dimensions.doubleExtraLargeFontSize,
                        ),
                      ),
                      Text('min ', style: AppTheme.theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _updateDuration(void _) {
    if (mounted && !widget.viewModel.playthoughEnded) {
      setState(() {});
    }
  }

  void _updateDurationHours(num value) {
    if (!widget.viewModel.playthoughEnded) {
      return;
    }

    setState(() {
      hoursPlayed = value.toInt();
      widget.viewModel.updateDuration(hoursPlayed, minutesPlyed);
    });
  }

  void _updateDurationMinutes(num value) {
    if (!widget.viewModel.playthoughEnded) {
      return;
    }

    setState(() {
      minutesPlyed = value.toInt();
      widget.viewModel.updateDuration(hoursPlayed, minutesPlyed);
    });
  }

  Future<void> _pickStartDate() async {
    final DateTime now = DateTime.now();
    final DateTime? newStartDate = await showDatePicker(
      context: context,
      initialDate: widget.viewModel.playthroughStartTime,
      firstDate: now.add(const Duration(days: -Constants.daysInTenYears)),
      lastDate: now,
      currentDate: now,
      helpText: 'Pick a playthrough date',
      builder: (_, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.accentColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (newStartDate == null) {
      return;
    }

    widget.viewModel.updateStartDate(newStartDate);
  }

  void _setHourseAndMinutesRange() {
    minHours = 0;
    maxHours = _maxHours;
    minMinutes = 0;
    maxMinutes = Duration.minutesPerHour - 1;
  }
}
