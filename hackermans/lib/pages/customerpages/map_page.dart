

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackermans/data/appData.dart';
import 'package:hackermans/pages/customerpages/storeCustomer_page.dart';

import 'package:hackermans/src/locations.dart' as locations;
import 'package:hackermans/styles/customMarke.dart';
import 'package:provider/provider.dart';


class MapPage extends StatefulWidget{
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return FullMap();
  }
}

class FullMap extends StatefulWidget{
  @override
  _FullMapState createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  List<Marker> markers = [];
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();

    MarkerGenerator(markerWidgets(), (bitmaps) {
      setState(() {
        markers = mapBitmapsToMarkers(bitmaps);
      });
    }).generate(context);
  }

  List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final city = cities[i];
      markersList.add(
        Marker(
          markerId: MarkerId(city.name),
          position: city.position,
          icon: BitmapDescriptor.fromBytes(bmp),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (BuildContext context) => StoreCustomerPage())
            );
          }
        )
      );
    });
    return markersList;
  }


  Widget _updateController(BuildContext context){
    final appData = Provider.of<AppData>(context);

    if(appData.setCameraUpdate) {
      _controller.moveCamera(appData.cameraUpdate);
      appData.setCameraUpdate = false;
    }
    return Container(height: 0, width: 0);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    this._controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[ 
        GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: markers.toSet(),
          onMapCreated: _onMapCreated,
        ),
        _updateController(context)
      ]
    );
  }

  // Example of backing data
  List<City> cities = [
    City("Zagreb", LatLng(45.792565, 15.995832)),
    City("Ljubljana", LatLng(46.037839, 14.513336)),
    City("Novo Mesto", LatLng(45.806132, 15.160768)),
    City("Varaždin", LatLng(46.302111, 16.338036)),
    City("Maribor", LatLng(46.546417, 15.642292)),
    City("Rijeka", LatLng(45.324289, 14.444480)),
    City("Karlovac", LatLng(45.489728, 15.551561)),
    City("Klagenfurt", LatLng(46.624124, 14.307974)),
    City("Graz", LatLng(47.060426, 15.442028)),
    City("Celje", LatLng(46.236738, 15.270346))
  ];

  List<Widget> markerWidgets() {
    return cities.map((c) => _getMarkerWidget(c.name)).toList();
  }


  // Example of marker widget
  Widget _getMarkerWidget(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.blue,
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: SizedBox(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Migros',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  '35', 
                  style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class City {
    final String name;
    final LatLng position;

    City(this.name, this.position);
}

