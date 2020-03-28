
import 'package:flutter/material.dart';


class StoreMap extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Text('data')
        )
      ),
    );
  }}