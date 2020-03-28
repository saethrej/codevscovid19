

import 'package:flutter/material.dart';
import 'package:hackermans_web/element/storedetail/storeInfo.dart';
import 'package:hackermans_web/element/storedetail/storeReservation.dart';
import 'package:hackermans_web/styles.dart';

class StoreDetail extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Migros Rapperswil', style: Styles.header,),
                    Spacer(),
                    Icon(Icons.cancel)
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StoreInfo(),
                    StoreReservation(),
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