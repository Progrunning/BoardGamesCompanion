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

  @override
  void initState() {
    super.initState();

    _startDateTime = widget.playthrough.startDate;
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
                const ItemPropertyTitle('Start time'),
                const SizedBox(
                  height: Dimensions.halfStandardSpacing,
                ),
                CalendarCard(
                  _startDateTime,
                  onTap: _pickStartDateTime,
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

  Future<void> _save() async {}

  Future<bool> _handleOnWillPop(BuildContext context, Playthrough playthrough) async {
    if (_startDateTime != playthrough.startDate) {
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
