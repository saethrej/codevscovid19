import 'dart:convert';
import 'dart:core';

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
      numPeople: json['numPeople'],
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude']
    );
  }
}



class HTTPRequest {

  Map coordToID = new Map<int, Information>();
  
  Future<Map<int, Information>> sendCoordinates(String server, Tuple2<double, double> position, Tuple2<double, double> left, Tuple2<double, double> right, Tuple2<double, double> up, Tuple2<double, double> down) async{
    var jsonString = json.encode([{
      "position": position,
      "up": up,
      "down": down,
      "right": right,
      "left": left
    }]);
    final http.Response response = await http.post(server, headers: <String, String> {
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
      throw Exception("Failed to connect to server")
    }
    void parseList(http.Response){
      
    }



  }
}