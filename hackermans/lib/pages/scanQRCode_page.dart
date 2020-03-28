import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackermans/styles.dart';
import 'package:flutter/rendering.dart';


import 'package:qr_mobile_vision/qr_camera.dart';


class ScanQRCodePage extends StatefulWidget{
  @override
  _ScanQRCodePageState createState() => _ScanQRCodePageState();
}

class _ScanQRCodePageState extends State<ScanQRCodePage> {
  String qr;
  bool camState = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CupertinoNavigationBarBackButton(color: Colors.black,),
                  Text('Scan QR Code', style: Styles.headerLight),
                ],
              ),
              new Expanded(
                  child: camState
                      ? new Center(
                          child: new SizedBox(
                            width: 300.0,
                            height: 600.0,
                            child: new QrCamera(
                              notStartedBuilder: (BuildContext context){return CircularProgressIndicator();},
                              onError: (context, error) => Text(
                                    error.toString(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                              qrCodeCallback: (code) {
                                setState(() {
                                  qr = code;
                                });
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.orange, width: 10.0, style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                        )
                      : new Center(child: CircularProgressIndicator())),
              new Text("QRCODE: $qr"),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Text(
            "press me",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            setState(() {
              camState = !camState;
            });
          }),
    );
  }
}