

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackermans/data/appData.dart';
import 'package:hackermans/pages/customerpages/storeCustomer_page.dart';
import 'package:hackermans/src/HTTPRequests.dart';
import 'package:hackermans/src/UtilClasses.dart';

import 'package:hackermans/styles/customMarker.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';


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
  GoogleMapController _controller;

  HTTPRequest request = HTTPRequest();
  Duration refreshRate = Duration(seconds: 5);
  Timer timer;

  List<Marker> markers = [];
  List<StoreInformation> currentShops;

  bool loading = false;
  LatLng curPosition;
  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(47.379220, 8.53702),
    zoom: 15.5,
  );

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(refreshRate, (Timer t) {loading = false;});

  }

  void _getStoreData(LatLng position) async {
    print("Get store data based on LatLng: $position");
    loading = true;

    var requestPosition = Tuple2<double, double>(position.longitude, position.latitude);
    var requestLeft = Tuple2<double, double>(position.longitude-5, position.latitude);
    var requestRight = Tuple2<double, double>(position.longitude+5, position.latitude);
    var requestUp = Tuple2<double, double>(position.longitude, position.latitude+5);
    var requestDown = Tuple2<double, double>(position.longitude, position.latitude-5);

   
    // request store information
    await request.sendCoordinates(requestPosition, requestLeft, requestRight, requestUp, requestDown)
      .then((value) {
        setState(() {
          print('Updated current store list');
          currentShops = value;
        });
      })
      .catchError((e) {
        print(e.toString());
    }); 

    print('Received shops $currentShops');

    // build markers, set state  
    print("Building markers");
    if (currentShops.isNotEmpty){
      MarkerGenerator(markerWidgets(), (bitmaps) {
        setState(() {
          markers = mapBitmapsToMarkers(bitmaps);
        });
      }).generate(context);                    
    }
  }

  List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final shop = currentShops[i];
      print('Build marker of store ${shop.id}');
      print('Build marker of store ${shop.latitude}');
      print('Build marker of store ${shop.longitude}');
      markersList.add(
        Marker(
          markerId: MarkerId(shop.id.toString()),
          position: LatLng(shop.latitude, shop.longitude),
          icon: BitmapDescriptor.fromBytes(bmp),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (BuildContext context) => StoreCustomerPage(shop.id))
            );
          }
        )
      );
    });
    return markersList;
  }

  Widget _updateController(BuildContext context){

    
    return Container(height: 0, width: 0);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    this._controller = controller;
  }

  Future<void> _onCameraMove(CameraPosition position) async {
    this.curPosition = position.target;
    if (!loading){
      _getStoreData(position.target);
    } else {
      print('sleeping');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    if(appData.setCameraUpdate) {
      setState(() {
        this.initialCameraPosition = appData.cameraUpdate;
        appData.setCameraUpdate = false;
        _controller.moveCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
      }); 
    }

    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: initialCameraPosition,
      markers: markers.toSet(),
      onMapCreated: _onMapCreated,
      onCameraMove: _onCameraMove,
    );
  }

  List<Widget> markerWidgets() {
    return currentShops.map((c) => _getMarkerWidget(c.numPeople, c.maxPeople)).toList();
  }

  // Example of marker widget
  Widget _getMarkerWidget(int numPeople, int maxPeople) {
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
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Migros',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  '$numPeople/$maxPeople', 
                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w800)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}