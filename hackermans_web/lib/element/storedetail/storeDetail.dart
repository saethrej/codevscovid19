

import 'package:flutter/material.dart';
import 'package:hackermans_web/element/storedetail/storeInfo.dart';

class StoreDetail extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text('data'),
                Row(
                  children: <Widget>[
                    StoreDetail(),
                    StoreInfo(),
                  ],
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}