
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackermans/src/UtilClasses.dart';


class AppData with ChangeNotifier{
  int storeID = 1;
  String storeName = 'Migros Rapperswil';
  GoogleMapController controller;
  CameraPosition cameraUpdate;
  bool setCameraUpdate = false;
  List<ReservationInformation> storedReservations = List<ReservationInformation>();

  void setID(int storeID) {
    this.storeID = storeID;
    notifyListeners();
  }

  List<ReservationInformation> updateReservations(List<ReservationInformation> updatedReservations){
    storedReservations = updatedReservations;
    notifyListeners();
  }


  void setSearchedLocation(LatLng newPosition){ 
    print('update GoogleMapsController');
    setCameraUpdate = true;
    cameraUpdate = CameraPosition(
      target: newPosition,
      zoom: 13.0,
    );
    notifyListeners();
  }
}
  