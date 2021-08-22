import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/widgets/common/text/item_property_title_widget.dart';
import 'package:flutter/material.dart';

import '../../common/dimensions.dart';
import '../../models/hive/playthrough.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                widget.playthrough.startDate,
                onTap: _pickStartDateTime,
              ),
            ],
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
                  onSurface: AppTheme.inverterTextColor,
                ),
          ),
          child: child,
        );
      },
    );
    if (newStartDate != null) {
      final TimeOfDay newStartTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
        helpText: 'Pick a playthough time',
        builder: (_, Widget child) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColorLight: Colors.black,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppTheme.accentColor,
                  ),
            ),
            child: child,
          );
        },
      );
    }
  }
}
