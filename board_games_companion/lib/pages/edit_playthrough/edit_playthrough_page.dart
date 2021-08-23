import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/strings.dart';
import '../../models/hive/playthrough.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/playthrough/calendar_card.dart';

class EditPlaythoughPage extends StatefulWidget {
  const EditPlaythoughPage({
    @required this.playthrough,
    Key key,
  }) : super(key: key);

  final Playthrough playthrough;

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
                const ItemPropertyTitle('Start time & duration'),
                const SizedBox(
                  height: Dimensions.halfStandardSpacing,
                ),
                _Duration(
                  startDateTime: _startDateTime,
                  endDateTime: _endDateTime,
                  onPickStartDateTime: _pickStartDateTime,
                  onDurationChanged: _updatePlaythroughDuration,
                ),
                const Expanded(
                  child: SizedBox.shrink(),
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

    final TimeOfDay newStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
      helpText: 'Pick a playthough time',
      builder: (_, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.white, // hour/minute & AM/PM selected color
                  surface: AppTheme.primaryColorLight, // AM/PM border
                  onSurface:
                      AppTheme.white.withOpacity(0.2), // hour/minute & AM/PM unselected color
                ),
          ),
          child: child,
        );
      },
    );

    if (newStartTime == null) {
      _startDateTime = newStartDate;
      return;
    }

    _startDateTime =
        newStartDate.add(Duration(hours: newStartTime.hour, minutes: newStartTime.minute));
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
  int playthroughDurationInSeconds;
  int hoursPlayed;
  int minutesPlyed;

  @override
  void initState() {
    super.initState();
    final Duration playthroughDuration =
        (widget.endDateTime ?? DateTime.now()).difference(widget.startDateTime);
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
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hours',
                style: AppTheme.theme.textTheme.bodyText2,
              ),
              _DurationTextField(
                value: hoursPlayed,
                onDurationChanged: (int duration) {
                  widget.onDurationChanged(
                    Duration(
                      seconds: playthroughDurationInSeconds +
                          (duration - hoursPlayed).abs() * Duration.secondsPerHour,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: Dimensions.doubleStandardSpacing,
              ),
              Text(
                'Minutes',
                style: AppTheme.theme.textTheme.bodyText2,
              ),
              _DurationTextField(
                value: minutesPlyed,
                minValue: 1,
                maxValue: 59,
                step: 10,
                onDurationChanged: (int duration) {
                  widget.onDurationChanged(
                    Duration(
                      seconds: playthroughDurationInSeconds +
                          (duration - minutesPlyed).abs() * Duration.secondsPerMinute,
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _DurationTextField extends StatefulWidget {
  const _DurationTextField({
    @required this.value,
    @required this.onDurationChanged,
    this.minValue = 0,
    this.maxValue,
    this.step = 1,
    Key key,
  }) : super(key: key);

  final int value;
  final Function(int) onDurationChanged;
  final int minValue;
  final int maxValue;
  final int step;

  @override
  _DurationTextFieldState createState() => _DurationTextFieldState();
}

class _DurationTextFieldState extends State<_DurationTextField> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.value.toString());
    controller.addListener(() {
      final int newDuration = int.tryParse(controller.text);
      if (newDuration != null) {
        widget.onDurationChanged(newDuration);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          color: AppTheme.accentColor,
          onPressed: () {
            final int duration = int.tryParse(controller.value.text);
            if (duration == null) {
              return;
            }

            if ((duration - widget.step) < widget.minValue) {
              if (duration > widget.minValue) {
                setState(() {
                  controller.text = widget.minValue.toString();
                });
              }

              return;
            }

            setState(() {
              controller.text = (duration - widget.step).toString();
            });
          },
        ),
        const SizedBox(
          width: Dimensions.standardSpacing,
        ),
        SizedBox(
          width: 60,
          child: TextFormField(
            enableInteractiveSelection: false,
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: AppTheme.theme.textTheme.subtitle1.copyWith(
              color: AppTheme.defaultTextColor,
              fontSize: Dimensions.largeFontSize,
            ),
            decoration: const InputDecoration(),
          ),
        ),
        const SizedBox(
          width: Dimensions.standardSpacing,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          color: AppTheme.accentColor,
          onPressed: () {
            final int duration = int.tryParse(controller.value.text);
            if (duration == null) {
              return;
            }

            if (widget.maxValue != null && (duration + widget.step) > widget.maxValue) {
              if (duration < widget.maxValue) {
                setState(() {
                  controller.text = widget.maxValue.toString();
                });
              }

              return;
            }

            setState(() {
              controller.text = (duration + widget.step).toString();
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
