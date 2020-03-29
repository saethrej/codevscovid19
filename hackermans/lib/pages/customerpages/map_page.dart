

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackermans/pages/customerpages/storeCustomer_page.dart';
import 'package:hackermans/pages/ownerpages/storeOwner_page.dart';

import 'package:hackermans/src/locations.dart' as locations;


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

  Future<void> _onMapCreated(GoogleMapController controller) async {
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
    return GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: const LatLng(0, 0),
        zoom: 2,
      ),
      markers: _markers.values.toSet(),
    );
  }
}