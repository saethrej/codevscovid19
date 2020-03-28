

import 'package:flutter/material.dart';
import 'package:hackermans_web/data/dataModel.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

class SearchList extends StatefulWidget{
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
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
          icon: Icon(Icons.cancel), 
          onPressed: () => _controllerSearchField.clear()
        )
      ),
      keyboardType: TextInputType.text,
      style: Styles.headlineLight,
    );
  }

  Widget _listBody(BuildContext context){
    final pageData = Provider.of<PageData>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () {
              pageData.toggleStoreDetail();
            },
            child: Card(
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
            ),
          );
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Container(
          width: (MediaQuery.of(context).size.width / 5 < 300) ? 300 : MediaQuery.of(context).size.width / 5 ,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0,left: 16.0,right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hackermans', style: Styles.header,),
                SizedBox(height: 30),
                _searchField(context),
                SizedBox(height: 20),
                _listBody(context),
              ],
            ),
          )
        ),
      ),
    );
  }
}