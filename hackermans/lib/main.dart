import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hackermans/pages/customerpages/bookedReservations_page.dart';
import 'package:hackermans/pages/customerpages/map_page.dart';
import 'package:hackermans/pages/customerpages/search_page.dart';
import 'package:hackermans/styles.dart';
import 'package:provider/provider.dart';

import 'data/appData.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
      child: 
      MaterialApp(
        home: HomePage()
      )
    );
  }
}

class HomePage extends StatefulWidget{
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _searchButton(BuildContext context){
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (BuildContext context) => SearchPage())
        );
      }, 
      child: Card(
        elevation: 50,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Expanded(
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                SizedBox(width: 10),
                Text('Search location', style: Styles.headlineLightGrey)
              ],
            ),
          )
        )
      )
    );
  }

  Widget _bookedReservationsButton(BuildContext context){
      return FlatButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (BuildContext context) => BookedReservationPage())
          );
        }, 
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Card(
            elevation: 10,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text('Booked reservations', style: Styles.textBoldWhite))
                ],
              )
            )
          ),
        )
      );
    }


  Widget _buttonLayer(BuildContext context){
    final appData = Provider.of<AppData>(context);

    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 60),
              _searchButton(context),
              (!appData.listQRCode.isEmpty) ? Container(height: 0, width: 0) : _bookedReservationsButton(context),
              Spacer()
            ]
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapPage(),
        _buttonLayer(context),
      ]
    );
  }
}