import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hackermans/pages/home_page.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }

}