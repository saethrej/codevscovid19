
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AppData with ChangeNotifier{
  int storeID = 0;
  GoogleMapController controller;
  CameraUpdate cameraUpdate;
  bool setCameraUpdate = false;

  // TODO: List of QR code object
  List<int> listQRCode = List<int>();

  int setID(int storeID) {
    this.storeID = storeID;
    notifyListeners();
  }

  void setSearchedLocation(LatLng newPosition){ 
    print('update GoogleMapsController');
    setCameraUpdate = true;
    cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: newPosition,
        zoom: 13.0,
      )
    );
    notifyListeners();
  }
}
  