
import 'dart:convert';

class StoreInformation{
  double longitude;
  double latitude;
  int numPeople;
  int maxPeople;
  int id;

  StoreInformation({this.longitude, this.latitude, this.numPeople, this.maxPeople, this.id});

  factory StoreInformation.fromJson(Map<String, dynamic> json){
    return StoreInformation(
      longitude: json['longitude'],
      latitude: json['latitude'],
      numPeople: json['people_in_store'],
      maxPeople: json['max_people'],
      id: json['store_id'],
    );
  }
}


class FullStoreInformation{
    int store_id;
    String address;
    String city;
    int zip_code;
    String canton;
    String country;
    double latitude;
    double longitude;
    int max_people;
    int people_in_store;
    int avg_time_in_store;
    String mon_open;
    String mon_close;
    String tue_open;
    String tue_close;
    String wed_open;
    String wed_close;
    String thu_open;
    String thu_close;
    String fri_open;
    String fri_close;
    String sat_open;
    String sat_close;
    String sun_open;
    String sun_close;

    FullStoreInformation({this.store_id,
    this.address,
    this.city,
    this.zip_code,
    this.canton,
    this.country,
    this.latitude,
    this.longitude,
    this.max_people,
    this.people_in_store,
    this.avg_time_in_store,
    this.mon_open,
    this.mon_close,
    this.tue_open,
    this.tue_close,
    this.wed_open,
    this.wed_close,
    this.thu_open,
    this.thu_close,
    this.fri_open,
    this.fri_close,
    this.sat_open,
    this.sat_close,
    this.sun_open,
    this.sun_close});

    factory FullStoreInformation.fromJson(Map<String, dynamic> json){
      return FullStoreInformation( store_id : json['store_id'],
    address: json['address'],
     city: json['city'],
     zip_code: json['zip_code'],
     canton: json['canton'],
     country: json['country'],
     latitude: json['latitude'].toDouble(),
     longitude: json['longitutde'].toDouble(),
     max_people: json['max_people'],
     people_in_store : json ['people_in_store'],
     avg_time_in_store: json['avg_time_in_store'],
     mon_open : json['mon_open'].toString(),
     mon_close: json['mon_close'].toString(),
     tue_open: json['tue_open'].toString(),
     tue_close: json['tue_close'].toString(),
     wed_open: json['wed_open'].toString(),
     wed_close: json['wed_close'].toString(),
     thu_open: json['thu_open'].toString(),
     thu_close: json['thu_close'].toString(),
     fri_open: json['fri_open'].toString(),
     fri_close: json['fri_close'].toString(),
     sat_open: json['sat_open'].toString(),
     sat_close: json ['sat_close'].toString(),
     sun_open: json ['sun_open'].toString(),
     sun_close: json['sun_close'].toString(),
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

class TemporaryReservationObject {
  int storeID;
  int reservationID;
  String date;
  String time;
  bool isValid;

  TemporaryReservationObject(this.storeID, this.reservationID,  this.date,  this. time, this.isValid);

}

class PersistenJSONConverter {

  PersistenJSONConverter._privateConstructor(){
  }
  static final PersistenJSONConverter instance = PersistenJSONConverter._privateConstructor();

  factory PersistenJSONConverter(){
    return instance;
  }

  Map<int, ReservationInformation> jsonToMap(String jsonobj){
    Map<int, ReservationInformation> res = Map<int, ReservationInformation>();
    var map = jsonDecode(jsonobj);
    for(var i = 0; i < map.length; i++){
      int storeID = map[i]['storeID'];
      String storeName = map[i]['storeName'];
      String qrHash = map[i]['qrHash'];
      String date = map[i]['date'];
      String time = map[i]['time'];
      ReservationInformation inf = ReservationInformation(storeID,
      storeName,qrHash,date,time);
      res.putIfAbsent(map[i]['storeID'], () => inf);
    }
    return res;
  }

  dynamic mapToJSON(Map<int, ReservationInformation> map){
    List res= List();
    map.forEach((k,v) {
      var obj = {
        'storeID': v.storeID,
        'storeName': v.storeName,
        'qrHash': v.qrHash,
        'date' : v.date,
        'time' : v.time
      };
      res.add(obj);
    });
    return res;
  }


}


