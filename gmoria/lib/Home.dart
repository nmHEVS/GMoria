import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';
import 'package:gmoria/ListOfLists.dart';
import 'package:gmoria/models/ListModel.dart';

import './datas/dataList.dart' as dataList;

class Home extends StatefulWidget {
  final List<ListApp> lists = dataList.list;
  final String appTitle = 'GMORIA';
  static String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: Container(
        child: ListOfList(
          lists: widget.lists,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
