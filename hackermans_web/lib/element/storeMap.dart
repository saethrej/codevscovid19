
import 'package:flutter/material.dart';

import 'package:mapbox_gl_dart/mapbox_gl_dart.dart';


class StoreMap extends StatelessWidget{  
  var map = MapboxMap(
    MapOptions(
      container: 'map',
      style: 'mapbox://styles/mapbox/dark-v10',
      center: LngLat(7.68227, 45.06755),
      zoom: 12,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.blue,
        child: Container(height: 0, width: 0,)
      ),
    );
  }}