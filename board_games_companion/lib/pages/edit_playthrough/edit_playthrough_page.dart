import 'dart:math' as math;
import 'dart:math';

import 'package:board_games_companion/models/hive/playthrough_note.dart';
import 'package:board_games_companion/models/navigation/playthough_note_page_arguments.dart';
import 'package:board_games_companion/pages/edit_playthrough/playthrough_note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../mixins/enter_score_dialog.dart';
import '../../models/player_score.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/slivers/bgc_sliver_header_delegate.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../enter_score/enter_score_view_model.dart';
import 'edit_playthrough_view_model.dart';

class EditPlaythroughPage extends StatefulWidget {
  const EditPlaythroughPage({
    required this.viewModel,
    required this.goBackPageRoute,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/editPlaythrough';

  final EditPlaythoughViewModel viewModel;
  final String goBackPageRoute;

  @override
  EditPlaythroughPageState createState() => EditPlaythroughPageState();
}

class EditPlaythroughPageState extends State<EditPlaythroughPage> with EnterScoreDialogMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _handleOnWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(AppText.editPlaythroughPageTitle),
          actions: [
            IconButton(icon: const Icon(Icons.close), onPressed: () => _close(context)),
          ],
        ),
        body: SafeArea(
          child: PageContainer(
            child: Observer(builder: (_) {
              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: BgcSliverHeaderDelegate(
                      primaryTitle: AppText.editPlaythroughDateAndDurationHeaderTitle,
                    ),
                  ),
                  _PlayDateTimeSection(viewModel: widget.viewModel),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: BgcSliverHeaderDelegate(
                        primaryTitle: AppText.editPlaythroughScoresHeaderTitle),
                  ),
                  _ScoresSection(
                    viewModel: widget.viewModel,
                    onItemTapped: (PlayerScore playerScore) async =>
                        _editPlayerScore(playerScore, context),
                  ),
                  if (widget.viewModel.hasNotes) ...[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: BgcSliverHeaderDelegate(
                          primaryTitle: AppText.editPlaythroughNotesHeaderTitle),
                    ),
                    _NotesSection(
                      notes: widget.viewModel.notes!,
                      onTap: (note) => _editNote(note.id),
                      onDelete: (note) => _deleteNote(note),
                    ),
                    // MK Adding padding to the bottom of the list to avoid overlap of the FOB with the notes
                    const SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: Dimensions.floatingActionButtonBottomSpacing +
                            Dimensions.standardSpacing,
                      ),
                    ),
                  ]
                ],
              );
            }),
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
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
              onTap: () async => _save(),
            ),
            if (!widget.viewModel.playthoughEnded)
              SpeedDialChild(
                child: const Icon(Icons.stop),
                backgroundColor: AppColors.blueColor,
                foregroundColor: Colors.white,
                label: AppText.stop,
                labelBackgroundColor: AppColors.blueColor,
                onTap: () async => _stopPlaythrough(),
              ),
            SpeedDialChild(
              child: const Icon(Icons.note_add),
              backgroundColor: AppColors.greenColor,
              foregroundColor: Colors.white,
              label: AppText.editPlaythroughAddNote,
              labelBackgroundColor: AppColors.greenColor,
              onTap: () async => _addNote(),
            ),
            SpeedDialChild(
              child: const Icon(Icons.delete),
              backgroundColor: AppColors.redColor,
              foregroundColor: Colors.white,
              label: AppText.delete,
              labelBackgroundColor: AppColors.redColor,
              onTap: () async => _showDeletePlaythroughDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _editPlayerScore(PlayerScore playerScore, BuildContext context) async {
    final viewModel = EnterScoreViewModel(playerScore);
    await showEnterScoreDialog(context, viewModel);
    widget.viewModel.updatePlayerScore(playerScore, viewModel.score);
    return viewModel.score.toString();
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
    if (await _handleOnWillPop(context)) {
      Navigator.pop(context);
    }
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
                if (!mounted) {
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

  Future<bool> _handleOnWillPop(BuildContext context) async {
    if (!widget.viewModel.isDirty) {
      return true;
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

    return false;
  }

  Future<void> _addNote() async {
    await Navigator.of(context).pushNamed(
      PlaythroughNotePage.pageRoute,
      arguments: PlaythroughNotePageArguments(widget.viewModel.playthrough),
    );
    widget.viewModel.refreshNotes();
  }

  Future<void> _editNote(String noteId) async {
    await Navigator.of(context).pushNamed(
      PlaythroughNotePage.pageRoute,
      arguments: PlaythroughNotePageArguments(widget.viewModel.playthrough, noteId: noteId),
    );
    widget.viewModel.refreshNotes();
  }

  Future<void> _deleteNote(PlaythroughNote note) async {
    widget.viewModel.deletePlaythroughNote(note);
  }
}

class _ScoresSection extends StatelessWidget {
  const _ScoresSection({
    Key? key,
    required this.viewModel,
    required this.onItemTapped,
  }) : super(key: key);

  final EditPlaythoughViewModel viewModel;
  final Future<String?> Function(PlayerScore) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final int itemIndex = index ~/ 2;
                if (index.isEven) {
                  return _PlayerScoreTile(
                    playerScore: viewModel.playerScores[itemIndex],
                    playthroughId: viewModel.playthroughDetails.id,
                    onItemTapped: onItemTapped,
                  );
                }

                return const SizedBox(height: Dimensions.doubleStandardSpacing);
              },
              childCount: max(0, viewModel.playerScores.length * 2 - 1),
            ),
          ),
        );
      },
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({
    required this.notes,
    required this.onTap,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  final List<PlaythroughNote> notes;
  final void Function(PlaythroughNote) onTap;
  final void Function(PlaythroughNote) onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final int itemIndex = index ~/ 2;
          final note = notes[itemIndex];
          if (index.isEven) {
            return InkWell(
              onTap: () => onTap(note),
              child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      icon: Icons.delete,
                      onPressed: (_) => onDelete(note),
                      backgroundColor: AppColors.redColor,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.standardSpacing),
                        child: Text(note.text, textAlign: TextAlign.justify),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return const SizedBox(height: Dimensions.standardSpacing);
        },
        childCount: max(0, notes.length * 2 - 1),
      ),
    );
  }
}

class _PlayerScoreTile extends StatefulWidget {
  const _PlayerScoreTile({
    Key? key,
    required this.playerScore,
    required this.playthroughId,
    required this.onItemTapped,
  }) : super(key: key);

  final PlayerScore playerScore;
  final String playthroughId;
  final Future<String?> Function(PlayerScore) onItemTapped;

  @override
  State<_PlayerScoreTile> createState() => _PlayerScoreTileState();
}

class _PlayerScoreTileState extends State<_PlayerScoreTile> {
  late String? score;

  @override
  void initState() {
    super.initState();

    score = widget.playerScore.score.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                child: PlayerAvatar(
                  player: widget.playerScore.player,
                  avatarImageSize: Dimensions.smallPlayerAvatarSize,
                  playerHeroIdSuffix: widget.playthroughId,
                ),
              ),
              const SizedBox(width: Dimensions.standardSpacing),
              Expanded(
                child: _PlayerScore(score: score),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    Key? key,
    required this.score,
  }) : super(key: key);

  final String? score;

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
              score ?? '-',
              style: AppStyles.playerScoreTextStyle,
            ),
            const SizedBox(height: Dimensions.halfStandardSpacing),
            Text(AppText.editPlaythroughScorePoints, style: AppTheme.theme.textTheme.bodyText2),
          ],
        ),
      ],
    );
  }
}

class _PlayDateTimeSection extends StatefulWidget {
  const _PlayDateTimeSection({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    playthroughDuration = widget.viewModel.playthoughDuration;
    playthroughDurationInSeconds = playthroughDuration.inSeconds;
    hoursPlayed = playthroughDuration.inHours;
    minutesPlyed = playthroughDuration.inMinutes - hoursPlayed * Duration.minutesPerHour;
  }

  @override
  Widget build(BuildContext context) {
    _setHourseAndMinutesRange();
    return SliverToBoxAdapter(
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
                  Text('h', style: AppTheme.theme.textTheme.bodyText2),
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
                  Text('min ', style: AppTheme.theme.textTheme.bodyText2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _updateDurationHours(num value) {
    setState(() {
      hoursPlayed = value.toInt();
      widget.viewModel.updateDuration(hoursPlayed, minutesPlyed);
    });
  }

  void _updateDurationMinutes(num value) {
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
