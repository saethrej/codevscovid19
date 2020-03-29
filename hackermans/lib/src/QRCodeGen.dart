import 'package:hackermans/src/UtilClasses.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import '../data/appData.dart';


class QRCodeGen{

  ReservationInformation generateCode(int storeID, String storeName, String date, String time, json) {
    Uuid uuid = Uuid();
    String hash = uuid.toString();
    return ReservationInformation(storeID, storeName, hash, date, time);
  }

  

}
