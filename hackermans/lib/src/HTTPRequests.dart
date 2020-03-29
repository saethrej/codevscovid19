import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import 'UtilClasses.dart';

class HTTPRequest {
  
  HTTPRequest._privateConstructor(){
  }
  static final HTTPRequest instance = HTTPRequest._privateConstructor();
  static String server = '10.0.2.2:8000';

  factory HTTPRequest(){
    return instance;
  }
  
  //@params tuple of latitude, longitude
  // return a mapping from store ID to its information
  Future<List<StoreInformation>> sendCoordinates(Tuple2<double, double> position, Tuple2<double, double> left, Tuple2<double, double> right, Tuple2<double, double> up, Tuple2<double, double> down) async{
    final uri = Uri.http('10.0.2.2:8000', '/getLocations');
    var jsonString = json.encode({
      "position": position.toList(),
      "up": up.toList(),
      "down": down.toList(),
      "right": right.toList(),
      "left": left.toList()
    });
    print('before');
    final http.Response response = await http.post(uri, headers: <String, String> {
      'Content-Type': 'application/json' },
      body: jsonString
    );
    print('after');
    if(response.statusCode == 200){
       List closeStores = List<StoreInformation>();
      var stores = jsonDecode(response.body)['stores'];
      for(var i =0; i<stores.length; i++){
        var inf = StoreInformation.fromJson(json.decode(stores[i]));
        closeStores.add(inf);
      }
      print(closeStores);
      return closeStores;
    }
    else {
      throw Exception("Failed to put current location");
    }
  }

    //@TODO Needs header completion
    Future<List<Tuple2<String, int>>> requestTimes(int storeID, String date, String time) async{
      final uri = Uri.http('10.0.2.2:8000', '/getavailableReservation');
      var jsonString = json.encode({'storeId': storeID, 'date': date,
      'time': time});
      final http.Response response = await http.post(uri, headers: <String, String> {
      'Content-Type': 'application/json' },
      body: jsonString);
      List<Tuple2<String, int>>  times = List<Tuple2<String, int>> ();
      if(response.statusCode == 200){
        var timesNoFormat = jsonDecode(response.body)['reservations'];
        //print(timesNoFormat);
        for(var i = 0; i<timesNoFormat.length; i++){
          times.add(Tuple2(timesNoFormat[i]['time'].toString(), timesNoFormat[i]['slots']));
        }
        return times;
      }

      else {
        print(response.statusCode);
        throw Exception ("Failed to request times");
      }
    }


    // update the store counter in the database
    Future<bool> counterUp(int storeID) async{
      final uri = Uri.http(server, '/counterup/' + storeID.toString());
      final http.Response response = await http.get(uri);
      if(response.statusCode == 200){
        print(jsonDecode(response.body)['success']);
        return jsonDecode(response.body)['success'];
      }
      else {
        print(response.statusCode);
        throw Exception("Failed to increase counter"); 
      }
    }  

    // update the store counter in the database
    Future<bool> counterDown(int storeID) async{
      final uri = Uri.http(server, '/counterdown/' + storeID.toString());
      final http.Response response = await http.get(uri);//, '/counterdown/' + storeID.toString());
      if(response.statusCode == 200){
        print(jsonDecode(response.body)['success']);
        return jsonDecode(response.body)['success'];
      }
      else {
        throw Exception("Failed to decrease counter"); 
      }
    }

    // get store counter in the database
    Future<int> getCounter(int storeID) async {
       final uri = Uri.http(server, '/getcounter/' + storeID.toString());
      final http.Response response = await http.get(uri, headers: {"Accept": "application/json"});
      if(response.statusCode == 200){
        print(jsonDecode(response.body)['people_in_store']);
        return jsonDecode(response.body)['people_in_store'];
      }
      else {
        throw Exception("Failed to get Counter"); 
      }
    }
  

  // call after scanning a qr code to check if reservation is valid
  Future<bool> checkReservationfromQRCode(int storeID, String reservationID, String date, String time) async {
    final uri = Uri.http(server, '/checkQRCode');
    var jsonString =  json.encode({'store_id': storeID, 'reservation_id': reservationID, 'date': date,
      'time': time});
      final http.Response response = await http.post(uri, headers: <String, String> {
      'Content-Type': 'application/json' },
      body: jsonString);
       if(response.statusCode == 200){
         print(jsonDecode(response.body)['success']);
        return jsonDecode(response.body)['success'];
      }
      else {
        throw Exception("Failed to increase counter"); 
      }

  }

  // reserve a slot for later reservation on success
  Future<TemporaryReservationObject> preReserve(int storeID, String date, String time) async {
    var jsonString =  json.encode({'storeId': storeID, 'date': date,
    'time': time});
    print(jsonString);
     final uri = Uri.http(server, '/reserveReservation');
    final http.Response response = await http.post(uri, headers: <String, String> {
    'Content-Type': 'application/json' },
    body: jsonString);
      if(response.statusCode == 200){
        print(response.body);
        var details = jsonDecode(response.body)['reservationDetails'][0];
        var time = details['time'].toString();
        TemporaryReservationObject inf = TemporaryReservationObject(storeID, details['reservation_id'], details['date'], details['time'].toString(), jsonDecode(response.body)['success']);
      return inf;
    }
    else {
      print(response.statusCode);
      throw Exception("Prereserve"); 
    }

  }

  // reserve your slot
  Future<bool> reserve(int storeID, int reservationID, String hash, String date, String time) async{
    var uri = Uri.http(server, '/confirmReservation');
     var jsonString =  json.encode({'storeId': storeID, 'reservationId': reservationID, 'code_hash': hash,  'date': date,
    'time': time});
    print(jsonString);
    final http.Response response = await http.post(uri, headers: <String, String> {
    'Content-Type': 'application/json' },
    body: jsonString);
      if(response.statusCode == 200){
        print(jsonDecode(response.body)['success']);
      return jsonDecode(response.body)['success'];
    }
    else {
      throw Exception("Reserve"); 
    }
  }
}