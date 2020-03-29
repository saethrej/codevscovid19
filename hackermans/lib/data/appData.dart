
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackermans/src/UtilClasses.dart';


class AppData with ChangeNotifier{
  int storeID = 0;
  GoogleMapController controller;
  CameraUpdate cameraUpdate;
  bool setCameraUpdate = false;

  // TODO: List of QR code object
  Map <String, ReservationInformation> QRCodeMap = Map <String, ReservationInformation>();

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
  