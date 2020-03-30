import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hackermans/pages/ownerpages/scanQRCode_page.dart';
import 'package:hackermans/src/HTTPRequests.dart';
import 'package:hackermans/styles/styles.dart';
import 'package:hackermans/styles/waitingScreen.dart';


class StorePage extends StatefulWidget{
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  HTTPRequest request = HTTPRequest();
  Duration refreshRate = Duration(seconds: 5);
  Timer timer;

  int storeId = 1;
  int currentUser = 1;
  int maxUser = 200;
  bool loading = true;

  @override
  initState(){
    super.initState();
    getCurrentCount(storeId);
    timer = Timer.periodic(refreshRate, (Timer t) => getCurrentCount(storeId));
  }

  @override
  dispose(){
    super.dispose();
    timer.cancel();
    //getCurrentCount(storeId);
  }

  void getCurrentCount(int storeId) async {
    print("Get count for store: $storeId");
    await request.getCounter(storeId)
      .then((value) {
        setState(() {
          this.currentUser = value;
          loading = false;
        });
      })
      .catchError((e) {
        print(e.toString());
    });                       
  }

  void counterDown(int storeId) async {
    print("Counter Down, storeId: $storeId");
    await request.counterDown(storeId)
      .then((value) {
        print("Successfull: $value");
        if (value) {
          setState(() {
            currentUser -= 1;
          });
        }        
      })
      .catchError((e) {
        print(e.toString());
    });                       
  }

  void counterUp(int storeId) async {
    print("Counter Up, storeId: $storeId");
    await request.counterUp(storeId)
      .then((value) {
        print("Successfull: $value");
        if (value) {
          setState(() {
            currentUser += 1;
          });
        }        
      })
      .catchError((e) {
        print(e.toString());
    });                       
  }

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
                      if (currentUser > 0){
                        counterDown(storeId);
                      }
                    },  
                  child: Card(
                      color: !(currentUser == maxUser) ? Colors.grey : Colors.blue,
                      child: Center(child: Text('-', style: Styles.bigInfoWhite,)),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        if (currentUser < maxUser){
                          counterUp(storeId);
                        }
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: (currentUser >= maxUser) ? Colors.red : Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Migros Zürich HB', style: Styles.headerLight,),
                      Spacer(),
                      Text('Logout', style: Styles.smalltext,),
                    ],
                  ),
                  (loading) ? WaitingBody() : _counterBody(context),
                ],
              ),
            ),
          ),
        ),
        //_maintainState(context),
      ]
    );
  }
}

