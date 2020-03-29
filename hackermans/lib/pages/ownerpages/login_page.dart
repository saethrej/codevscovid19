import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hackermans/pages/ownerpages/storeOwner_page.dart';

import '../../styles.dart';



class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  initState(){
    _controllerUsername.addListener(() {setState(() {});});
    _controllerPassword.addListener(() {setState(() {});});
    super.initState();
  }

  @override
  dispose(){
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  Widget _formBody(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _controllerUsername,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
              labelStyle: Styles.text
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter username';
              }
              return null;
            },
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _controllerPassword,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              labelStyle: Styles.text
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 60,),
              Text('Sign in', style: Styles.header,),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: _formBody(context)),
                ],
              ),
              Spacer(),
              RaisedButton(
                onPressed: !(_controllerUsername.text.isNotEmpty &&_controllerPassword.text.isNotEmpty ) ? null : () {
                  if (_formKey.currentState.validate()) {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (BuildContext context) => StorePage())
                    );
                  }
                },
                disabledColor: Colors.grey,
                color: Colors.blue,
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Sign in'),
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}