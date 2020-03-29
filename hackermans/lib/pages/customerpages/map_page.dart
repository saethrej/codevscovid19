

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackermans/data/appData.dart';
import 'package:hackermans/pages/customerpages/storeCustomer_page.dart';
import 'package:hackermans/pages/ownerpages/storeOwner_page.dart';

import 'package:hackermans/src/locations.dart' as locations;
import 'package:provider/provider.dart';


class MapPage extends StatelessWidget{
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
  final Map<String, Marker> _markers = {};
  GoogleMapController _controller;

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
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (BuildContext context) => StoreCustomerPage())
            );
          }
        );
        _markers[office.name] = marker;
      }
    });
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
          markers: _markers.values.toSet(),
          onMapCreated: _onMapCreated,
        ),
        _updateController(context)
      ]
    );
  }
}