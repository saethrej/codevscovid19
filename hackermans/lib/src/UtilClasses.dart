
import 'dart:convert';

class StoreInformation{
  double longitude;
  double latitude;
  double numPeople;
  int id;

  StoreInformation({this.longitude, this.latitude, this.numPeople, this.id});

  factory StoreInformation.fromJson(Map<String, dynamic> json){
    return StoreInformation(
      longitude: json['longitude'],
      latitude: json['latitude'],
        numPeople: json['people_in_store'],
      id: json['id'],
    );
  }
}


class ReservationInformation {
  int storeID;
  String qrHash;
  String storeName;
  String date;
  String time;
  bool isValid;

  ReservationInformation(this.storeID, this.storeName, this.qrHash,  this.date,  this. time);


}

class PersistenJSONConverter {

  static Map<int, ReservationInformation> JSONToMap(String jsonobj){
    Map res = Map<int, ReservationInformation>();
    var map = jsonDecode(jsonobj)['map'];
    for(var i = 0; i < map.length; i++){
      int storeID = map[i].storeID;
      String storeName = map[i].storeName;
      String qrHash = map[i].qrHash;
      String date = map[i].date;
      String time = map[i].time;
      ReservationInformation inf = ReservationInformation(storeID,
      storeName,qrHash,date,time);
      res.putIfAbsent(map[i].storeID, () => inf);
    }
  }


}


