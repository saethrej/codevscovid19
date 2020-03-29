import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackermans/pages/ownerpages/scanQRCode_page.dart';
import 'package:hackermans/styles/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';



class BookedReservationPage extends StatefulWidget{
  @override
  _BookedReservationPageState createState() => _BookedReservationPageState();
}

class _BookedReservationPageState extends State<BookedReservationPage> {


  Widget _buildQRCode(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Expanded(
        child: Container(
          height: 200,
          width: 200,
          child: QrImage(
            data: "1234567890",
            version: QrVersions.auto,
          ),
        ),
      ),
    );
  }

  Widget _pageBody(BuildContext context){
    return Expanded(
      child: PageView.builder(
      controller: PageController(viewportFraction: 0.8),
        itemCount: 2,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 200),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Migros Rapperswil', style: Styles.headline),
                      ],
                    ),
                    Text('17:00', style: Styles.headerLight),
                    _buildQRCode(context)
                  ],
                ),
              )
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: <Widget>[
                  CupertinoNavigationBarBackButton(color: Colors.black,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Booked', style: Styles.headerLight,),
                      Text('Reservations', style: Styles.header,),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            _pageBody(context)
          ],
        ),
      ),
    );
  }
}
