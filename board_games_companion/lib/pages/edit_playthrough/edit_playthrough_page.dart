import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/strings.dart';
import '../../models/hive/playthrough.dart';
import '../../models/player_score.dart';
import '../../stores/playthrough_store.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';

class EditPlaythoughPage extends StatefulWidget {
  const EditPlaythoughPage({
    @required this.playthroughStore,
    Key key,
  }) : super(key: key);

  final PlaythroughStore playthroughStore;
  Playthrough get playthrough => playthroughStore.playthrough;

  @override
  _EditPlaythoughPageState createState() => _EditPlaythoughPageState();
}

class _EditPlaythoughPageState extends State<EditPlaythoughPage> {
  static const int _daysInYear = 365;
  static const int _daysInTenYears = _daysInYear * 10;

  DateTime _startDateTime;
  DateTime _endDateTime;

  @override
  void initState() {
    super.initState();

    _startDateTime = widget.playthrough.startDate;
    _endDateTime = widget.playthrough.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _handleOnWillPop(context, widget.playthrough);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Playthrough'),
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: const <Widget>[
                    ItemPropertyTitle('Start time'),
                    Expanded(
                      child: SizedBox.shrink(),
                    ),
                    ItemPropertyTitle('Duration'),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.halfStandardSpacing,
                ),
                _Duration(
                  startDateTime: _startDateTime,
                  endDateTime: _endDateTime,
                  onPickStartDateTime: _pickStartDateTime,
                  onDurationChanged: _updatePlaythroughDuration,
                ),
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
                    itemCount: widget.playthroughStore.playerScores?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: Dimensions.doubleStandardSpacing,
                      );
                    },
                    itemBuilder: (context, index) {
                      return _PlayerScore(
                        playerScore: widget.playthroughStore.playerScores[index],
                        playthroughId: widget.playthroughStore.playthrough.id,
                      );
                    },
                  ),
                ),
                _ActionButtons(
                  onSave: _save,
                  onCancel: () async {
                    if (await _handleOnWillPop(context, widget.playthrough)) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickStartDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime newStartDate = await showDatePicker(
      context: context,
      initialDate: widget.playthrough.startDate,
      firstDate: now.add(const Duration(days: -_daysInTenYears)),
      lastDate: now,
      currentDate: now,
      helpText: 'Pick a playthrough date',
      builder: (_, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.accentColor,
                ),
          ),
          child: child,
        );
      },
    );

    if (newStartDate == null) {
      return;
    }

    _startDateTime = newStartDate;
  }

  void _updatePlaythroughDuration(Duration playthroughDuration) {
    _endDateTime = _startDateTime.add(playthroughDuration);
  }

  Future<void> _save() async {}

  Future<bool> _handleOnWillPop(BuildContext context, Playthrough playthrough) async {
    if (_startDateTime != playthrough.startDate || _endDateTime != playthrough.endDate) {
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
              FlatButton(
                child: const Text(
                  Strings.Cancel,
                  style: TextStyle(
                    color: AppTheme.defaultTextColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Navigate away'),
                color: Colors.red,
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

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    Key key,
    @required this.playerScore,
    @required this.playthroughId,
  }) : super(key: key);

  final PlayerScore playerScore;
  final String playthroughId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: Dimensions.smallPlayerAvatarSize,
          width: Dimensions.smallPlayerAvatarSize,
          child: Stack(
            children: [
              PlayerAvatar(
                playerScore.player,
                playerHeroIdSuffix: playthroughId,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: Dimensions.standardSpacing,
        ),
        Column(
          children: <Widget>[
            ChangeNotifierProvider<PlayerScore>.value(
              value: playerScore,
              child: Consumer<PlayerScore>(
                builder: (_, PlayerScore playerScoreConsumer, __) {
                  return NumberPicker.horizontal(
                    listViewHeight: 46,
                    initialValue: int.tryParse(playerScoreConsumer.score?.value ?? '0') ?? 0,
                    minValue: 0,
                    maxValue: 10000,
                    onChanged: (num value) async {
                      final String valueText = value.toString();
                      if (playerScoreConsumer.score?.value == valueText) {
                        return;
                      }

                      await playerScoreConsumer.updatePlayerScore(valueText);
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: Dimensions.halfStandardSpacing,
            ),
            Text(
              'points',
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
    @required this.startDateTime,
    @required this.endDateTime,
    @required this.onPickStartDateTime,
    @required this.onDurationChanged,
    Key key,
  }) : super(key: key);

  final DateTime startDateTime;
  final DateTime endDateTime;
  final VoidCallback onPickStartDateTime;
  final Function(Duration) onDurationChanged;

  @override
  _DurationState createState() => _DurationState();
}

class _DurationState extends State<_Duration> {
  Duration playthroughDuration;
  int playthroughDurationInSeconds;
  int hoursPlayed;
  int minutesPlyed;

  @override
  void initState() {
    super.initState();

    playthroughDuration = (widget.endDateTime ?? DateTime.now()).difference(widget.startDateTime);
    playthroughDurationInSeconds = playthroughDuration.inSeconds;
    hoursPlayed = playthroughDuration.inHours;
    minutesPlyed = playthroughDuration.inMinutes - hoursPlayed * Duration.minutesPerHour;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: CalendarCard(
            widget.startDateTime,
            onTap: widget.onPickStartDateTime,
          ),
        ),
        const Expanded(child: SizedBox.shrink()),
        Row(
          children: <Widget>[
            NumberPicker.integer(
              initialValue: math.min(hoursPlayed, 99),
              minValue: 0,
              maxValue: 99,
              onChanged: (num value) => setState(() => hoursPlayed = value.toInt()),
              listViewWidth: 46,
            ),
            Text(
              'h',
              style: AppTheme.theme.textTheme.bodyText2,
            ),
            const SizedBox(width: Dimensions.halfStandardSpacing),
            NumberPicker.integer(
              initialValue: minutesPlyed,
              minValue: 0,
              maxValue: Duration.minutesPerHour - 1,
              onChanged: (num value) => setState(() => minutesPlyed = value.toInt()),
              listViewWidth: 46,
            ),
            Text(
              'min ',
              style: AppTheme.theme.textTheme.bodyText2,
            ),
          ],
        )
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    this.onSave,
    this.onCancel,
    Key key,
  }) : super(key: key);

  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconAndTextButton(
            title: Strings.Cancel,
            icon: const DefaultIcon(
              Icons.remove_circle_outline,
            ),
            color: Colors.red,
            splashColor: AppTheme.white,
            onPressed: onCancel,
          ),
          const SizedBox(
            width: Dimensions.standardSpacing,
          ),
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
