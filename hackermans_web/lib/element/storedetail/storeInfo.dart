

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../styles.dart';

class StoreInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Center(child: StoreCustomerInfo())
        ],
      ),
    );
  }
}

class StoreCustomerInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('45/50', style: Styles.bigInfo),
              Text('Customers'),
            ],
          ),
          SizedBox(height: 20),
          StoreCustomerPrediction()
        ],
      )
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
      new OrdinalSales('17:00', 20),
      new OrdinalSales('17:30', 20),
      new OrdinalSales('18:00', 20),
      new OrdinalSales('18:30', 80),
      new OrdinalSales('19:00', 70),
      new OrdinalSales('19:30', 70),
      new OrdinalSales('20:00', 50),
      new OrdinalSales('20:30', 10),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
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
         Container(
           height: 150 ,
           width: 500,
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
