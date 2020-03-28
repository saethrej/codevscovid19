import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hackermans/pages/customerpages/map_page.dart';
import 'package:hackermans/pages/customerpages/search_page.dart';
import 'package:hackermans/styles.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget{
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _searchButton(BuildContext context){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (BuildContext context) => SearchPage())
                );
              }, 
              child: Card(
                elevation: 10,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Expanded(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search),
                            SizedBox(width: 10),
                            Text('Search location', style: Styles.text)
                          ],
                        ),
                      )
                    ),
                  ],
                )
              )
            ),
            Spacer()
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapPage(),
        _searchButton(context),
      ]
    );
  }
}