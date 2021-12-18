import 'dart:math' as math;

import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/strings.dart';
import '../../models/player_score.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';
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

class _EditPlaythoughPageState extends State<EditPlaythoughPage> {
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
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: const <Widget>[
                    ItemPropertyTitle('Played on'),
                    Expanded(
                      child: SizedBox.shrink(),
                    ),
                    ItemPropertyTitle('Duration')
                  ],
                ),
                const SizedBox(
                  height: Dimensions.halfStandardSpacing,
                ),
                _Duration(viewModel: widget.viewModel),
                const SizedBox(
                  height: Dimensions.standardSpacing,
                ),
                Divider(
                  thickness: 1,
                  color: AppTheme.accentColor.withOpacity(0.2),
                ),
                const ItemPropertyTitle('Scores'),
                const SizedBox(
                  height: Dimensions.halfStandardSpacing,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.viewModel.playerScores.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: Dimensions.doubleStandardSpacing);
                    },
                    itemBuilder: (context, index) {
                      return _PlayerScoreTile(
                        playerScore: widget.viewModel.playerScores[index],
                        playthroughId: widget.viewModel.playthrough.id,
                      );
                    },
                  ),
                ),
                _ActionButtons(
                  viewModel: widget.viewModel,
                  onSave: () async => _save(),
                  onStop: () async => _stopPlaythrough(),
                  onDelete: () async => _showDeletePlaythroughDialog(context),
                )
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
                Strings.Cancel,
                style: TextStyle(color: AppTheme.accentColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                Strings.Delete,
                style: TextStyle(color: AppTheme.defaultTextColor),
              ),
              style: TextButton.styleFrom(backgroundColor: AppTheme.redColor),
              onPressed: () async {
                await widget.viewModel.deletePlaythrough();

                // MK Close dialog
                Navigator.of(context).pop();
                // MK Close popup
                Navigator.of(context).pop();
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
                  Strings.Cancel,
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
                  // MK Pop the dialog
                  Navigator.of(context).pop();
                  // MK Go back
                  Navigator.of(context).pop();
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

class _PlayerScoreTile extends StatelessWidget {
  const _PlayerScoreTile({
    Key? key,
    required this.playerScore,
    required this.playthroughId,
  }) : super(key: key);

  final PlayerScore playerScore;
  final String playthroughId;

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
            child: _PlayerScore(playerScore: playerScore),
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
  }) : super(key: key);

  final PlayerScore playerScore;

  @override
  State<_PlayerScore> createState() => _PlayerScoreState();
}

class _PlayerScoreState extends State<_PlayerScore> {
  static const double _scorePointsFontSize = 22;

  bool useKeyboardToEnterScore = false;
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
      children: <Widget>[
        SizedBox(
          width: 140,
          child: Column(
            children: <Widget>[
              if (useKeyboardToEnterScore)
                Form(
                  child: SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: playerScoreEditingController,
                      focusNode: playerScoreFocusNode,
                      style: AppTheme.defaultTextFieldStyle.copyWith(fontSize: _scorePointsFontSize),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onFieldSubmitted: (String? text) async {
                        if (text?.isNotBlank ?? false) {
                          await _updatePlayerScore(int.tryParse(text!)!);
                        }

                        setState(() {
                          useKeyboardToEnterScore = false;
                        });
                      },
                    ),
                  ),
                )
              else
                NumberPicker(
                  value: widget.playerScore.score.valueInt,
                  axis: Axis.horizontal,
                  itemWidth: 48,
                  minValue: 0,
                  maxValue: 10000,
                  onChanged: (num score) async {
                    await _updatePlayerScore(score);
                  },
                  selectedTextStyle: const TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: _scorePointsFontSize,
                  ),
                ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: useKeyboardToEnterScore
                        ? null
                        : () async {
                            await _updatePlayerScore(widget.playerScore.score.valueInt - 1);
                          },
                    color: AppTheme.accentColor,
                  ),
                  Text(
                    'points',
                    style: AppTheme.theme.textTheme.bodyText2,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: useKeyboardToEnterScore
                        ? null
                        : () async {
                            await _updatePlayerScore(widget.playerScore.score.valueInt + 1);
                          },
                    color: AppTheme.accentColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: Dimensions.standardSpacing),
        IconButton(
          onPressed: useKeyboardToEnterScore
              ? null
              : () {
                  setState(() {
                    playerScoreEditingController.text = widget.playerScore.score.value ?? '';
                    // TODO Work out why when selecting text in the text field the text field is not scrolled into the screen (i.e. keyboard overflows it)
                    // if (playerScoreEditingController.text.isNotBlank) {
                    //   playerScoreEditingController.selection = TextSelection(
                    //     baseOffset: 0,
                    //     extentOffset: playerScoreEditingController.text.length,
                    //   );
                    // }
                    useKeyboardToEnterScore = true;
                    playerScoreFocusNode.requestFocus();
                  });
                },
          icon: const Icon(Icons.keyboard_alt_outlined),
          color: AppTheme.accentColor,
          iconSize: 32,
        ),
      ],
    );
  }

  Future<void> _updatePlayerScore(num score) async {
    if (score < 0) {
      return;
    }

    final String scoreText = score.toString();
    if (widget.playerScore.score.value == scoreText) {
      return;
    }

    await widget.playerScore.updatePlayerScore(scoreText);

    setState(() {});
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
    return Row(
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
          IconAndTextButton(
            title: 'Delete',
            icon: const DefaultIcon(Icons.delete),
            color: AppTheme.redColor,
            onPressed: onDelete,
          ),
          const Expanded(child: SizedBox.shrink()),
          if (!viewModel.playthoughEnded) ...[
            IconAndTextButton(
              title: Strings.Stop,
              icon: const DefaultIcon(
                Icons.stop,
              ),
              color: AppTheme.blueColor,
              splashColor: AppTheme.whiteColor,
              onPressed: onStop,
            ),
            const SizedBox(
              width: Dimensions.standardSpacing,
            ),
          ],
          IconAndTextButton(
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
