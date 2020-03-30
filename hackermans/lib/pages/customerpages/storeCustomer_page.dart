
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackermans/data/appData.dart';
import 'package:hackermans/pages/customerpages/storeCustomerReservation_page.dart';
import 'package:hackermans/src/HTTPRequests.dart';
import 'package:hackermans/src/UtilClasses.dart';
import 'package:hackermans/styles/styles.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hackermans/styles/waitingScreen.dart';
import 'package:provider/provider.dart';


class StoreCustomerPage extends StatefulWidget{
  int storeId;

  StoreCustomerPage(this.storeId);

  @override
  _StoreCustomerPageState createState() => _StoreCustomerPageState();
}

class _StoreCustomerPageState extends State<StoreCustomerPage> {
  HTTPRequest request = HTTPRequest();
  Duration refreshRate = Duration(seconds: 4);
  Timer timer;

  bool loading = true;
  FullStoreInformation storeInfo;
  int currentUser = 0;
  int maxUser = 1;

  @override
  initState(){
    super.initState();
    getStoreInformation(widget.storeId);
    timer = Timer.periodic(refreshRate, (Timer t) => getCurrentCount(widget.storeId));
  }

  @override
  dispose(){
    super.dispose();
    timer.cancel();
    //getCurrentCount(storeId);
  }

  void getStoreInformation(int storeId) async {
    //Future<FullStoreInformation> getStoreData (int storeID) async{

    print("Get information for store: $storeId");
    await request.getStoreData(storeId)
      .then((value) {
        setState(() {
          storeInfo = value;
          maxUser = storeInfo.max_people;
          currentUser = storeInfo.people_in_store;
          loading = false;
        });
      })
      .catchError((e) {
        print(e.toString());
    });                       
  }

  void getCurrentCount(int storeId) async {
    print("Get count for store: $storeId");
    await request.getCounter(storeId)
      .then((value) {
        setState(() {
          this.currentUser = value;
          loading = false;
        });
      })
      .catchError((e) {
        print(e.toString());
    });                       
  }

  Widget _storeInfoBody(BuildContext context){
    return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Opening Hours', style: Styles.textBold,),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            children:[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Monday', style: Styles.text,),
                  SizedBox(height: 8),
                  Text('Tuesday', style: Styles.text,),
                  SizedBox(height: 8),
                  Text('Wednesday', style: Styles.text,),
                  SizedBox(height: 8),
                  Text('Thursday', style: Styles.text,),
                  SizedBox(height: 8),
                  Text('Friday', style: Styles.text,),
                  SizedBox(height: 8),
                  Text('Saturday', style: Styles.text,),
                  SizedBox(height: 8),
                  Text('Sunday', style: Styles.text,),
                ],
              ),
              SizedBox(width: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(storeInfo.mon_open.substring(0,5), style: Styles.text,),
                      Text(' to ', style: Styles.text,),
                      Text(storeInfo.mon_close.substring(0,5), style: Styles.text,),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(storeInfo.tue_open.substring(0,5), style: Styles.text,),
                      Text(' to ', style: Styles.text,),
                      Text(storeInfo.tue_close.substring(0,5), style: Styles.text,),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(storeInfo.wed_open.substring(0,5), style: Styles.text,),
                      Text(' to ', style: Styles.text,),
                      Text(storeInfo.wed_close.substring(0,5), style: Styles.text,),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(storeInfo.thu_open.substring(0,5), style: Styles.text,),
                      Text(' to ', style: Styles.text,),
                      Text(storeInfo.thu_close.substring(0,5), style: Styles.text,),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(storeInfo.mon_open.substring(0,5), style: Styles.text,),
                      Text(' to ', style: Styles.text,),
                      Text(storeInfo.thu_close.substring(0,5), style: Styles.text,),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(storeInfo.sun_open.substring(0,5), style: Styles.text,),
                      Text(' to ', style: Styles.text,),
                      Text(storeInfo.sun_close.substring(0,5), style: Styles.text,),
                    ],
                  ),  
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(storeInfo.sun_open.substring(0,5), style: Styles.text,),
                      Text(' to ', style: Styles.text,),
                      Text(storeInfo.sun_close.substring(0,5), style: Styles.text,),
                    ],
                  ),                  
                ],
              )
            ]
          ),
        )
        
      ],
       ),
   ); 
  }

  Widget _reservationButton(BuildContext context){
    return FlatButton(
      onPressed: () {
         Navigator.push(
            context, 
            MaterialPageRoute(builder: (BuildContext context) => StoreCustomerReservationPage(widget.storeId))
          );
      },
      child: Card(
        elevation: 5,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Reservation', style: Styles.textBoldWhite),
            ),
          ],
        )
      )
    );
  }

  Widget _counterBody(context){
    return Expanded(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Text(currentUser.toString(), style: Styles.bigInfo,)),
              Center(child: Text('/${maxUser.toString()}', style: Styles.bigInfo,)),
            ],
          ),
          Center(child: Text('Available entries', style: Styles.text,)),
          SizedBox(height: 20),
          _reservationButton(context),
          SizedBox(height: 50),
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: StoreCustomerPrediction()
          ),
          _storeInfoBody(context)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    appData.storeInfo = this.storeInfo;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: (loading) ? WaitingBody() : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CupertinoNavigationBarBackButton(color: Colors.black),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(storeInfo.city, style: Styles.headerLight,),
                      Text('Migros ${storeInfo.address}', style: Styles.header,),
                    ],
                  ),
                ],
              ),
              _counterBody(context),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class StoreCustomerPrediction extends StatelessWidget{
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      OrdinalSales('17:00', 20),
      OrdinalSales('17:30', 20),
      OrdinalSales('18:00', 20),
      OrdinalSales('18:30', 80),
      OrdinalSales('19:00', 70),
      OrdinalSales('19:30', 70),
      OrdinalSales('20:00', 50),
      OrdinalSales('20:30', 10),
    ];

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Rush hour', style: Styles.textBold,),
        Expanded(
          child: charts.BarChart(
            _createSampleData(),
            animate: false,
          ),
        ),
      ],
       ),
   );
  }
}
