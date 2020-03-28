import 'package:flutter/material.dart';
import 'package:hackermans/pages/scanQRCode_page.dart';
import 'package:hackermans/styles.dart';


class StorePage extends StatefulWidget{
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int currentUser = 23;
  int maxUser = 30;

  Widget _scanQRCodeButton(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: (currentUser == maxUser) ? null : () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (BuildContext context) => ScanQRCodePage())
              );
            },
            child: Card(
              color: (currentUser == maxUser) ? Colors.grey : Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth_searching, color: Colors.white,),
                    SizedBox(width: 10),
                    Text('Scan QR code', style: Styles.textBoldWhite,)
                  ]
                ),
              )
            ),
          )
        )
      ]
    );
  }

  Widget _counterBody(context){
    return Expanded(
      child: Column(
        children: <Widget>[
          Spacer(),
          Center(child: Text(currentUser.toString(), style: Styles.bigInfo,)),
          Center(child: Text('Customers', style: Styles.text,)),
          Padding(
            padding: const EdgeInsets.all(26.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Expanded(
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        if (currentUser > 0) currentUser -= 1;
                      });
                    },                    child: Card(
                      color: !(currentUser == maxUser) ? Colors.grey : Colors.blue,
                      child: Center(child: Text('-', style: Styles.bigInfoWhite,)),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        if (currentUser < maxUser) currentUser += 1;
                      });
                    },
                    child: Card(
                      color: (currentUser == maxUser) ? Colors.grey : Colors.blue,
                      child: Center(child: Text('+', style: Styles.bigInfoWhite,)),
                    ),
                  ),
                )
              ]
            ),
          ),
          Spacer(),
          _scanQRCodeButton(context)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (currentUser == maxUser) ? Colors.red : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Migros Rapperswil', style: Styles.headerLight,),
                  Spacer(),
                  Text('Logout', style: Styles.smalltext,),
                ],
              ),
              _counterBody(context),
            ],
          ),
        ),
      ),
    );
  }
}
