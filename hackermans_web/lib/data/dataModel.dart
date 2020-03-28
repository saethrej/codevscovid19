
import 'package:flutter/material.dart';

class PageData with ChangeNotifier{
  bool storeSelected = false;
  int storeID = 0;

  int setID(int storeID) {
    this.storeID = storeID;
    notifyListeners();
  }
}
  