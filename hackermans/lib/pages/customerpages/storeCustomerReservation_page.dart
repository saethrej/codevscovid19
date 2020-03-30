import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackermans/data/appData.dart';
import 'package:hackermans/pages/ownerpages/scanQRCode_page.dart';
import 'package:hackermans/src/HTTPRequests.dart';
import 'package:hackermans/src/UtilClasses.dart';
import 'package:hackermans/styles/styles.dart';
import 'package:hackermans/styles/waitingScreen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';

List<Tuple2<String, int>> reservationSlots = List<Tuple2<String, int>>();
bool loading = true;
String selectedDate;
int storeId;
String storeName;

class StoreCustomerReservationPage extends StatefulWidget{
  @override
  _StoreCustomerReservationPageState createState() => _StoreCustomerReservationPageState();
}

class _StoreCustomerReservationPageState extends State<StoreCustomerReservationPage> {
  HTTPRequest request = HTTPRequest();
  Duration refreshRate = Duration(seconds: 4);
  Timer timer;

  bool success = false;
  bool newReservation = false;
  List<ReservationInformation> storedReservations;


  @override
  initState(){
    super.initState();
    timer = Timer.periodic(refreshRate, (Timer t) => setState((){success = false;}));
  }

  @override
  dispose(){
    super.dispose();
    timer.cancel();
    //getCurrentCount(storeId);
  }

  void _resetSnackBar(){
    setState(() {
      print('Snackbar deactivated');
      sleep(Duration(seconds: 3));
      success = false;
    });
  }
  // get available slots based on slected date
  Future<void> _getAvailableSlots({String date}) async {
    print("Get Reservations for store $storeId at $date");
    setState(() {
      loading = true;
    });
    await request.requestTimes(storeId, date)
      .then((value) {
        setState(() {
          reservationSlots = value;
          loading = false;
        });
      })
      .catchError((e) {
        print(e.toString());
    });               
  }

  Future<void> postReservation({String date, String time}) async {
    TemporaryReservationObject cur;
    print("Get Reservations for store $storeId at $date");
    await request.preReserve(storeId, date, time)
      .then((value) {
        setState(() {
          cur = value;
        });
      })
      .catchError((e) {
        print(e.toString());
    });   

    //create reservations object
    // TODO: randomize qrcode
    var rng = Random();
    var curReservation  =  ReservationInformation(cur.storeID, storeName, rng.nextInt(20000).toString() , cur.date, cur.time);

    storedReservations.add(curReservation);
    newReservation = true;

    await request.reserve(cur.storeID, cur.reservationID, curReservation.qrHash , cur.date, cur.time)
      .then((value) {
        print('Reservation succeeded: $value');
        if (value) {
          setState(() {
            success = true;
            _getAvailableSlots();
          });
        }
      })
      .catchError((e) {
        print(e.toString());
    });   
  }

  Widget _reservationSlotRecord(BuildContext context, int index){
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          (reservationSlots[index].item1.toString().length != 4) ? '${reservationSlots[index].item1.toString().substring(reservationSlots[index].item1.toString().length-3,reservationSlots[index].item1.toString().length-2 )}' :'${reservationSlots[index].item1.toString().substring(reservationSlots[index].item1.toString().length-4,reservationSlots[index].item1.toString().length-2 )}', 
                          style: Styles.headline,
                          ),
                        Text(':', style: Styles.headline,),
                        Text('${reservationSlots[index].item1.toString().substring(reservationSlots[index].item1.toString().length-2)}', style: Styles.headline,),
                      ],
                    ),
                    Text('     ', style: Styles.headline,),
                    Text('${reservationSlots[index].item2.toString()} slots open', style: Styles.textBold,),
                  ],
                ),
              ],
            ),
            FlatButton(
              onPressed: () {
                postReservation(date: selectedDate, time: reservationSlots[index].item1.toString());
              },
              child: Card(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Reserve', style: Styles.textBoldWhite),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listBody(BuildContext context){
    return Expanded(
      child: ListView.builder(
        itemCount: reservationSlots.length,
        itemBuilder: (context, index) {
          return _reservationSlotRecord(context, index);
        }
      ),
    );
  }

  Widget _pageBody(BuildContext context){
    return Expanded(
      child: Column(
        children: <Widget>[
          CalendarBody(),
          SizedBox(height: 20),
          (loading) ? WaitingBody() : _listBody(context)
        ],
      ),
    );
  }

  Widget _snackBar(BuildContext context){
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: success ? 1 : 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            color: Colors.greenAccent,
            height: 100,
            child: Center(child: 
              Text('Reservation succeeded', style: Styles.headline,)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    storeName = appData.storeName;
    storeId = appData.storeID;
    if (newReservation) {
      appData.updateReservations(storedReservations);

    } else {
      storedReservations = appData.storedReservations;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
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
                          Text('Reservations', style: Styles.headerLight,),
                          Text('Migros Zürich HB', style: Styles.header,),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  _pageBody(context),
                ],
              ),
            ),
          ),
          _snackBar(context)
        ]
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
  HTTPRequest request = HTTPRequest();
  Duration refreshRate = Duration(seconds: 2);
  Timer timer;

  // TODO: insert list for returned reservation slots

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

  // get available slots based on slected date
  Future<void> _getAvailableSlots({String date}) async {
    print("Get Reservations for store $storeId at $date");
    await request.requestTimes(storeId, date)
      .then((value) {
        setState(() {
          reservationSlots = value;
          loading = false;
        });
      })
      .catchError((e) {
        print(e.toString());
    });                     
  }

  @override
  Widget build(BuildContext context) {
    Function(DateTime, DateTime, CalendarFormat) onCalendarCreated = (DateTime day, DateTime endDay, CalendarFormat format){
      //_getAvailableSlots(date: day.toString().substring(0, 10));
      selectedDate = DateTime.now().toString().substring(0, 10);
      _getAvailableSlots(date: DateTime.now().toString().substring(0, 10));
    };

    Function(DateTime, List) onDaySelected = (DateTime day, List events) {
      selectedDate = day.toString().substring(0, 10);
      _getAvailableSlots(date: day.toString().substring(0, 10));
    };

    return TableCalendar(
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.week,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blue,
        todayColor: Colors.grey,
      ),
      startDay: DateTime.now(),
      startingDayOfWeek: StartingDayOfWeek.saturday, 
      endDay: DateTime(2020, 13, 14),
      onCalendarCreated: onCalendarCreated,
      onDaySelected: onDaySelected,
    );
  }
}
