import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackermans/pages/ownerpages/scanQRCode_page.dart';
import 'package:hackermans/styles.dart';
import 'package:table_calendar/table_calendar.dart';


class StoreCustomerReservationPage extends StatefulWidget{
  @override
  _StoreCustomerReservationPageState createState() => _StoreCustomerReservationPageState();
}

class _StoreCustomerReservationPageState extends State<StoreCustomerReservationPage> {
  int currentUser = 23;
  int maxUser = 30;

  Widget _reservationSlotRecord(BuildContext context){
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('17:00', style: Styles.headline,),
                Text('Shopping slot for direct access.', style: Styles.text,),
              ],
            ),
            Card(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('5 slots', style: Styles.textBoldWhite,),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _reservationSlots(BuildContext context){
    return Column(
      children: <Widget>[
        _reservationSlotRecord(context),
        _reservationSlotRecord(context),
        _reservationSlotRecord(context),
        _reservationSlotRecord(context),        
        _reservationSlotRecord(context),
        _reservationSlotRecord(context)
      ],
    );
  }

  Widget _pageBody(BuildContext context){
    return ListView(
      children: <Widget>[
        CalendarBody(),
        SizedBox(height: 20),
        _reservationSlots(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CupertinoNavigationBarBackButton(color: Colors.black),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Migros Rapperswil', style: Styles.header,),
                      Text('Reservation', style: Styles.headerLight,),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              Expanded(child: _pageBody(context)),
            ],
          ),
        ),
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
    _calendarController = CalendarController();
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
      initialCalendarFormat: CalendarFormat.week,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blue,
        todayColor: Colors.grey,
      ),
      startingDayOfWeek: StartingDayOfWeek.saturday, 
    );
  }
}
