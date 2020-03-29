
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackermans/pages/customerpages/storeCustomerReservation_page.dart';
import 'package:hackermans/styles/styles.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class StoreCustomerPage extends StatefulWidget{
  @override
  _StoreCustomerPageState createState() => _StoreCustomerPageState();
}

class _StoreCustomerPageState extends State<StoreCustomerPage> {
  int currentUser = 23;
  int maxUser = 30;

  Widget _storeInfoBody(BuildContext context){
    return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Information', style: Styles.textBold,),
      ],
       ),
   ); 
  }


  Widget _reservationButton(BuildContext context){
    return FlatButton(
      onPressed: () {
         Navigator.push(
            context, 
            MaterialPageRoute(builder: (BuildContext context) => StoreCustomerReservationPage())
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CupertinoNavigationBarBackButton(color: Colors.black),
                  Text('Migros Rapperswil', style: Styles.header,),
                ],
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _counterBody(context)
                  ] 
                ),
              ),
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
