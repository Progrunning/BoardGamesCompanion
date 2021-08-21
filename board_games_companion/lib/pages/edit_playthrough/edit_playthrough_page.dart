import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/app_theme.dart';
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
  CalendarController calendarController;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  static const int _daysInYear = 365;
  static const int _daysInTenYears = _daysInYear * 10;

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
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
            children: <Widget>[
              InkWell(
                child: CalendarCard(widget.playthrough.startDate),
                onTap: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (_) {
                      return SimpleDialog(
                        title: const Text(
                          'Pick a playthrough date',
                          style: TextStyle(color: AppTheme.defaultTextColor),
                        ),
                        backgroundColor: AppTheme.primaryColorLight,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.height * 0.8,
                            child: Column(
                              children: [
                                TableCalendar(
                                  calendarController: calendarController,
                                  startDay:
                                      DateTime.now().add(const Duration(days: -_daysInTenYears)),
                                  endDay: DateTime.now(),
                                  initialSelectedDay: widget.playthrough.startDate,
                                  initialCalendarFormat: _calendarFormat,
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  calendarStyle: const CalendarStyle(
                                    // weekdayStyle: TextStyle(color: Colors.black),
                                    selectedColor: AppTheme.accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
