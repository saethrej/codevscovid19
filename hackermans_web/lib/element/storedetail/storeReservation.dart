
import 'package:flutter/material.dart';

import '../../styles.dart';
import 'package:table_calendar/table_calendar.dart';

class StoreReservation extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Reservation', style: Styles.headline,),
          CalendarBody(),
        ],
      ),
    );
  }
}

class CalendarBody extends StatefulWidget{
  @override
  _CalendarBodyState createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController(
    );
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Set to todays day and set controller to week
    return TableCalendar(
      calendarController: _calendarController,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blue,
        todayColor: Colors.grey,
      ),
      startingDayOfWeek: StartingDayOfWeek.saturday, 
    );
  }
}