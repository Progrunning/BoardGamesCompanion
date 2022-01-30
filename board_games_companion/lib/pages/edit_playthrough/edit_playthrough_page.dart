import 'dart:math' as math;

import 'package:board_games_companion/pages/enter_score/enter_score_view_model.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../mixins/enter_score_dialog.dart';
import '../../models/player_score.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../playthroughs/playthroughs_page.dart';
import 'edit_playthrouhg_view_model.dart';

class EditPlaythoughPage extends StatefulWidget {
  const EditPlaythoughPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/editPlaythrough';

  final EditPlaythoughViewModel viewModel;

  @override
  _EditPlaythoughPageState createState() => _EditPlaythoughPageState();
}

class _EditPlaythoughPageState extends State<EditPlaythoughPage> with EnterScoreDialogMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _handleOnWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Edit Playthrough'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _close(context),
            ),
          ],
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                  child: Row(
                    children: const <Widget>[
                      ItemPropertyTitle('Played on'),
                      Expanded(child: SizedBox.shrink()),
                      ItemPropertyTitle('Duration')
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _Duration(viewModel: widget.viewModel),
                const SizedBox(height: Dimensions.standardSpacing),
                const SizedBox(height: Dimensions.standardSpacing),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                  child: ItemPropertyTitle('Scores'),
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                Expanded(
                  child: _ScoresSection(
                    viewModel: widget.viewModel,
                    onItemTapped: (PlayerScore playerScore) async {
                      final int? score =
                          await showEnterScoreDialog(context, EnterScoreViewModel(playerScore));
                    },
                  ),
                ),
                ChangeNotifierProvider<EditPlaythoughViewModel>.value(
                  value: widget.viewModel,
                  child: Consumer<EditPlaythoughViewModel>(
                    builder: (_, viewModel, __) {
                      return _ActionButtons(
                        viewModel: viewModel,
                        onSave: () async => _save(),
                        onStop: () async => _stopPlaythrough(),
                        onDelete: () async => _showDeletePlaythroughDialog(context),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    await widget.viewModel.saveChanges();
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
          title: const Text('Are you sure you want to delete this playthrough?'),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(
                AppText.Cancel,
                style: TextStyle(color: AppTheme.accentColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                AppText.Delete,
                style: TextStyle(color: AppTheme.defaultTextColor),
              ),
              style: TextButton.styleFrom(backgroundColor: AppTheme.redColor),
              onPressed: () async {
                await widget.viewModel.deletePlaythrough();
                Navigator.of(context).popUntil(ModalRoute.withName(PlaythroughsPage.pageRoute));
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _handleOnWillPop(BuildContext context) async {
    if (widget.viewModel.isDirty()) {
      await showDialog<AlertDialog>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "You didn't save your changes.",
            ),
            content: const Text(
              'Are you sure you want to navigate away?',
            ),
            elevation: Dimensions.defaultElevation,
            actions: <Widget>[
              TextButton(
                child: const Text(
                  AppText.Cancel,
                  style: TextStyle(
                    color: AppTheme.accentColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Navigate away',
                  style: TextStyle(color: AppTheme.defaultTextColor),
                ),
                style: TextButton.styleFrom(backgroundColor: AppTheme.redColor),
                onPressed: () async {
                  Navigator.of(context).popUntil(ModalRoute.withName(PlaythroughsPage.pageRoute));
                },
              ),
            ],
          );
        },
      );

      return false;
    }

    return true;
  }
}

class _ScoresSection extends StatefulWidget {
  const _ScoresSection({
    Key? key,
    required this.viewModel,
    required this.onItemTapped,
  }) : super(key: key);

  final EditPlaythoughViewModel viewModel;
  final void Function(PlayerScore) onItemTapped;

  @override
  State<_ScoresSection> createState() => _ScoresSectionState();
}

class _ScoresSectionState extends State<_ScoresSection> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.viewModel.playerScores.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: Dimensions.doubleStandardSpacing);
      },
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => widget.onItemTapped(widget.viewModel.playerScores[index]),
          child: ChangeNotifierProvider<EditPlaythoughViewModel>.value(
            value: widget.viewModel,
            child: Consumer<EditPlaythoughViewModel>(
              builder: (_, viewModel, __) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                  child: _PlayerScoreTile(
                    playerScore: viewModel.playerScores[index],
                    playthroughId: viewModel.playthrough.id,
                    onUpdatePlayerScore: (num score) async {
                      await _updatePlayerScore(viewModel.playerScores[index], score);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _updatePlayerScore(PlayerScore playerScore, num newScore) async {
    if (newScore < 0) {
      return;
    }

    final String scoreText = newScore.toString();
    if (playerScore.score.value == scoreText) {
      return;
    }

    await playerScore.updatePlayerScore(scoreText);

    setState(() {});
  }
}

class _PlayerScoreTile extends StatelessWidget {
  const _PlayerScoreTile({
    Key? key,
    required this.playerScore,
    required this.playthroughId,
    required this.onUpdatePlayerScore,
  }) : super(key: key);

  final PlayerScore playerScore;
  final String playthroughId;
  final Future<void> Function(num) onUpdatePlayerScore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.smallPlayerAvatarSize,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: Dimensions.smallPlayerAvatarSize,
            width: Dimensions.smallPlayerAvatarSize,
            child: PlayerAvatar(
              playerScore.player,
              playerHeroIdSuffix: playthroughId,
            ),
          ),
          const SizedBox(width: Dimensions.standardSpacing),
          Expanded(
            child: _PlayerScore(
              playerScore: playerScore,
              onUpdatePlayerScore: onUpdatePlayerScore,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerScore extends StatefulWidget {
  const _PlayerScore({
    Key? key,
    required this.playerScore,
    required this.onUpdatePlayerScore,
  }) : super(key: key);

  final PlayerScore playerScore;
  final Future<void> Function(num) onUpdatePlayerScore;

  @override
  State<_PlayerScore> createState() => _PlayerScoreState();
}

class _PlayerScoreState extends State<_PlayerScore> {
  late TextEditingController playerScoreEditingController;
  late FocusNode playerScoreFocusNode;

  @override
  void initState() {
    super.initState();

    playerScoreEditingController = TextEditingController(text: widget.playerScore.score.value);
    playerScoreFocusNode = FocusNode();
  }

  @override
  void dispose() {
    playerScoreEditingController.dispose();
    playerScoreFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(width: Dimensions.standardSpacing),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${widget.playerScore.score.valueInt}', style: Styles.playerScoreTextStyle),
            const SizedBox(height: Dimensions.halfStandardSpacing),
            Text(
              AppText.editPlaythroughScorePoints,
              style: AppTheme.theme.textTheme.bodyText2,
            ),
          ],
        ),
      ],
    );
  }
}

class _Duration extends StatefulWidget {
  const _Duration({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final EditPlaythoughViewModel viewModel;

  @override
  _DurationState createState() => _DurationState();
}

class _DurationState extends State<_Duration> {
  static const int _maxHours = 99;

  late DateTime startDateTime;
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

    startDateTime = widget.viewModel.playthrough.startDate;
    playthroughDuration = widget.viewModel.playthoughDuration;
    playthroughDurationInSeconds = playthroughDuration.inSeconds;
    hoursPlayed = playthroughDuration.inHours;
    minutesPlyed = playthroughDuration.inMinutes - hoursPlayed * Duration.minutesPerHour;
  }

  @override
  Widget build(BuildContext context) {
    _setHourseAndMinutesRange();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: Row(
        children: [
          Center(
            child: CalendarCard(
              widget.viewModel.playthrough.startDate,
              onTap: () async => _pickStartDate(),
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
                    color: AppTheme.accentColor,
                    fontSize: Dimensions.doubleExtraLargeFontSize,
                  ),
                ),
                Text(
                  'h',
                  style: AppTheme.theme.textTheme.bodyText2,
                ),
                const SizedBox(width: Dimensions.halfStandardSpacing),
                NumberPicker(
                  value: minutesPlyed,
                  infiniteLoop: true,
                  minValue: minMinutes,
                  maxValue: maxMinutes,
                  onChanged: (num value) => _updateDurationMinutes(value),
                  itemWidth: 46,
                  selectedTextStyle: const TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: Dimensions.doubleExtraLargeFontSize,
                  ),
                ),
                Text(
                  'min ',
                  style: AppTheme.theme.textTheme.bodyText2,
                ),
              ],
            ),
          )
        ],
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
      initialDate: startDateTime,
      firstDate: now.add(const Duration(days: -Constants.DaysInTenYears)),
      lastDate: now,
      currentDate: now,
      helpText: 'Pick a playthrough date',
      builder: (_, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.accentColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (newStartDate == null) {
      return;
    }

    setState(() {
      final Duration playthroughDuration = widget.viewModel.playthoughDuration;
      widget.viewModel.playthrough.startDate = startDateTime = newStartDate;
      widget.viewModel.playthrough.endDate = newStartDate.add(playthroughDuration);
    });
  }

  void _setHourseAndMinutesRange() {
    minHours = 0;
    maxHours = _maxHours;
    minMinutes = 0;
    maxMinutes = Duration.minutesPerHour - 1;
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.viewModel,
    this.onSave,
    this.onStop,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  final EditPlaythoughViewModel viewModel;
  final VoidCallback? onSave;
  final VoidCallback? onStop;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          IconAndElevatedButton(
            title: 'Delete',
            icon: const DefaultIcon(Icons.delete),
            color: AppTheme.redColor,
            onPressed: onDelete,
          ),
          const Expanded(child: SizedBox.shrink()),
          if (!viewModel.playthoughEnded) ...[
            IconAndElevatedButton(
              title: AppText.Stop,
              icon: const DefaultIcon(
                Icons.stop,
              ),
              color: AppTheme.blueColor,
              onPressed: onStop,
            ),
            const SizedBox(
              width: Dimensions.standardSpacing,
            ),
          ],
          IconAndElevatedButton(
            title: 'Save',
            icon: const DefaultIcon(
              Icons.save,
            ),
            color: AppTheme.accentColor,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}
