import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class Information{
  double longitude;
  double latitude;
  double numPeople;
  int id;

  Information({this.numPeople, id, this.longitude, this.latitude});

  factory Information.fromJson(Map<String, dynamic> json){
    return Information(
      numPeople: json['people_in_store'],
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude']
    );
  }
}



class HTTPRequest {

  Map coordToID = new Map<int, Information>();
  String server;
  
  //@params tuple of latitude, longitude
  // return a mapping from store ID to its information
  Future<Map<int, Information>> sendCoordinates(Tuple2<double, double> position, Tuple2<double, double> left, Tuple2<double, double> right, Tuple2<double, double> up, Tuple2<double, double> down) async{
    var jsonString = json.encode({
      "position": position,
      "up": up,
      "down": down,
      "right": right,
      "left": left
    });
    final http.Response response = await http.post(server + '/getlocations', headers: <String, String> {
      'Content-Type': 'application/json' },
      body: jsonString
    );

    if(response.statusCode == 201){
      var stores = jsonDecode(response.body)['stores'];
      for(var i =0; i<stores.length; i++){
        var inf = Information.fromJson(json.decode(stores[i]));
        coordToID.putIfAbsent(inf.id, ()=> inf);
      }
      return coordToID;
    }
    else {
      throw Exception("Failed to put current location");
    }
  }

    //@TODO Needs header completion
    Future<List<String>> requestTimes(int id, String date, String time) async{
      var jsonString = json.encode({'store_id': id, 'date': date,
      'time': time});
      final http.Response response = await http.post(server, headers: <String, String> {
      'Content-Type': 'application/json' },
      body: jsonString);

      List<String> times = List();
      if(response.statusCode == 201){
        var timesNoFormat = jsonDecode(response.body)['times'];
        for(var i = 0; i<timesNoFormat.length; i++){
          times.add(timesNoFormat[i].time);
        }
        return times;
      }

      else {
        throw Exception ("Failed to request times");
      }
    }


    // update the store counter in the database
    Future<bool> counterUp(int storeID) async{
      final http.Response response = await http.get(server + '/counterup/' + storeID.toString());
      if(response.statusCode == 201){
        return jsonDecode(response.body).success;
      }
      else {
        throw Exception("Failed to increase counter"); 
      }
    }  

    // update the store counter in the database
    Future<bool> counterDown(int storeID) async{
      final http.Response response = await http.get(server + '/counterdown/' + storeID.toString());
      if(response.statusCode == 201){
        return jsonDecode(response.body).success;
      }
      else {
        throw Exception("Failed to decrease counter"); 
      }
    }

    // get store counter in the database
    Future<int> getCounter(int storeID) async {
      final http.Response response = await http.get(server + '/getcounter/' + storeID.toString());
      if(response.statusCode == 201){
        return jsonDecode(response.body).people_in_store;
      }
      else {
        throw Exception("Failed to get Counter"); 
      }
    }
  

  // call after scanning a qr code to check if reservation is valid
  Future<bool> checkReservationfromQRCode(int storeID, int reservationID, String date, String time) async {
    var jsonString =  json.encode({'store_id': storeID, 'reservation_id': reservationID, 'date': date,
      'time': time});
      final http.Response response = await http.post(server + '/checkQRCode', headers: <String, String> {
      'Content-Type': 'application/json' },
      body: jsonString);
       if(response.statusCode == 201){
        return jsonDecode(response.body).success;
      }
      else {
        throw Exception("Failed to increase counter"); 
      }

  }

  /*
  Future<bool> confirmWithQRHash(int storeID, int hash, String date, String time) async {
    var jsonString =  json.encode({'store_id': storeID, 'qr_hash': hash, 'date': date,
    'time': time});
    final http.Response response = await http.post(server + '/makeReservation', headers: <String, String> {
    'Content-Type': 'application/json' },
    body: jsonString);
      if(response.statusCode == 201){
      return jsonDecode(response.body).success;
    }
    else {
      throw Exception("Failed send QR code hash"); 
    }


  }
  */

  // reserve a slot for later reservation on success
  Future<bool> preReserve(int storeID, int hash, String date, String time) async {
    var jsonString =  json.encode({'store_id': storeID, 'qr_hash': hash, 'date': date,
    'time': time});
    final http.Response response = await http.post(server + '/preReservation', headers: <String, String> {
    'Content-Type': 'application/json' },
    body: jsonString);
      if(response.statusCode == 201){
      return jsonDecode(response.body).success;
    }
    else {
      throw Exception("Prereserve"); 
    }

  }

  // reserve your slot
  Future<bool> reserve(int storeID, int hash, String date, String time) async{
     var jsonString =  json.encode({'store_id': storeID, 'qr_hash': hash, 'date': date,
    'time': time});
    final http.Response response = await http.post(server + '/getReservation', headers: <String, String> {
    'Content-Type': 'application/json' },
    body: jsonString);
      if(response.statusCode == 201){
      return jsonDecode(response.body).success;
    }
    else {
      throw Exception("Prereserve"); 
    }
  }



}