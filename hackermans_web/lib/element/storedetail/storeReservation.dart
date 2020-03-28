
import 'package:flutter/material.dart';

class StoreInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                Text('Store Reservation'),
                Spacer(),
              ],
            ),
          )
        ),
      ),
    );
  }
}