

import 'package:flutter/material.dart';

class StoreDetail extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Spacer(),
              Text('data'),
              Spacer(),
            ],
          ),
        )
      ),
    );
  }
}