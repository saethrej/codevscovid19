import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hackermans/pages/ownerpages/login_page.dart';
import 'package:hackermans/styles.dart';

class SearchPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SearchPageBody();
  }
}

class SearchPageBody extends StatefulWidget {

  @override
  _SearchPageBodyState createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  TextEditingController _controllerSearchField;

  @override
  void initState(){
    _controllerSearchField = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerSearchField.dispose();
    super.dispose();
  }

  Widget _searchField(BuildContext context){
    return TextField(
      controller: _controllerSearchField,
      onChanged: (string) {
        setState(() {});
      },
      decoration: InputDecoration(
        icon: Icon(Icons.search),
        labelText: 'Search store or location',
        suffixIcon: (_controllerSearchField.text.isEmpty) ? null : IconButton(
          icon: Icon(Icons.clear), 
          onPressed: () => _controllerSearchField.clear()
        )
      ),
      keyboardType: TextInputType.text,
      style: Styles.headerLight,
      onSubmitted: (text) {
        if (text == 'loginStoreUser'){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (BuildContext context) => LoginPage())
          );
        }
      },
    );
  }

  Widget _listBody(BuildContext context){
    return Expanded(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index){
          return Card(
            elevation: 2,
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('500m', style: Styles.smalltext),
                  Text('Migros Rapperswil', style: Styles.headline),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Slots', style: Styles.smalltext),
                  Text('20', style: Styles.headline),
                ],
              ),
            )
          );
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CupertinoNavigationBarBackButton(color: Colors.black,),
                  Text('Hackermans', style: Styles.header,),
                ],
              ),
              SizedBox(height: 30),
              _searchField(context),
              SizedBox(height: 20),
              _listBody(context),
            ],
          ),
        )
      )
    );
  }
}