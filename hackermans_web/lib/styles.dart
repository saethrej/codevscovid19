import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const TextStyle headline = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headlineLight = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );


  static const TextStyle text = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle textGrey = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle textBold = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textBoldWhite = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold
  );
  
  static const TextStyle smalltext = TextStyle(
    color: Colors.black,
    fontSize: 9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle header = TextStyle(
    color: Colors.black,
    fontSize: 21,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headerLight = TextStyle(
    color: Colors.black,
    fontSize: 21,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle bigInfo = TextStyle(
    color: Colors.black,
    fontSize: 80,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle bigInfoWhite = TextStyle(
    color: Colors.white,
    fontSize: 80,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static const Color searchIconColor = Color.fromRGBO(128, 128, 128, 1);
}