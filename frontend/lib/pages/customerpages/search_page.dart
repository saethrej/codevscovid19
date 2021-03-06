import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hackermans/data/appData.dart';
import 'package:hackermans/pages/ownerpages/login_page.dart';
import 'package:hackermans/styles/styles.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:tuple/tuple.dart';

import '../../src/HTTPRequests.dart';


class SearchPage extends StatefulWidget{
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {  
  TextEditingController controller = TextEditingController();
  
  Duration refreshRate = Duration(seconds: 1);
  Future<List<MapBoxPlace>> places;
  bool searching = false;
  Timer timer;

  //Places search sample call
  Future placesSearch() async {
    if (controller.text.isNotEmpty){
      searching = true;
      var placesService = PlacesSearch(
        apiKey: "pk.eyJ1IjoibGl2aW9zIiwiYSI6ImNrNDdmdHJvNzBheGYza3BhejFkdGk0eG8ifQ.qG49BQpVKLCJWf7N-cMLHQ",
        country: "CH",
        limit: 5,
      );
      setState(() {
        places = placesService.getPlaces(
          controller.text,
        );
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controller.dispose();
    //timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    //controller.addListener(() {placesSearch();});
    timer = Timer.periodic(refreshRate, (Timer t) => placesSearch());
    super.initState();
  }

  Widget buildAutocompleteList(BuildContext context){
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: places,
          builder: (context, AsyncSnapshot snapshot){
            if (!snapshot.hasData){
              return Container(height: 0, width: 0);
            } else {
              var content = snapshot.data;
              print(content);
              return Container(
                width: 300,
                height: 300,
                color: Colors.white,
                child: ListView.builder(
                  // Let the ListView know how many items it needs to build.
                  itemCount: content.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (BuildContext context, int index) {
                    final appData = Provider.of<AppData>(context);

                    return GestureDetector(  
                      onTap: () {
                        var coord = content[index].center;
                        appData.setSearchedLocation(maps.LatLng(coord[1], coord[0]));
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${content[index].text}', style: Styles.textBold,), 
                              Text('${content[index].placeName}', style: Styles.smalltext,), 
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              );
            }
          }
        ),
      ],
    );
  }

  Widget pageBody(BuildContext context){
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoTextField(
          controller: controller,
          autofocus: true,
          autocorrect: false,
          decoration: null,
          prefix: Icon(Icons.search, color: Colors.black),
          placeholder: 'Enter location',
          clearButtonMode: OverlayVisibilityMode.editing,
          showCursor: true,
          style: Styles.headlineLight,
          onSubmitted: (text) {
            if (text == 'loginStoreUser'){
              timer.cancel();
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (BuildContext context) => LoginPage())
              );
            } else if (text == 'counterup'){
              HTTPRequest req = HTTPRequest();
              print('here');
              req.counterUp(1);
              //req.requestTimes(1, '2020-03-30', '1125');
              req.sendCoordinates(Tuple2(47.233738, 8.832623), Tuple2(47.232497, 8.818969),  Tuple2(47.229899, 8.836188), Tuple2(47.235714, 8.826012), Tuple2(47.220021, 8.830000));
              }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  CupertinoNavigationBarBackButton(
                    onPressed: () {Navigator.pop(context);},
                    color: Colors.black,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Search location' , style: Styles.header)
                    ],
                  )
                ],
              ),
              SizedBox(height:40),
              pageBody(context),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: buildAutocompleteList(context),
              )
            ]
          ),
        ),
      )
    );
  }
}