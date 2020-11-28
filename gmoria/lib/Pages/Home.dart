import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';
import 'package:gmoria/ListOfLists.dart';
import 'package:gmoria/models/ListModel.dart';
import 'package:gmoria/auth/Auth.dart';
import 'package:gmoria/auth/AuthProvider.dart';
import '../datas/dataList.dart' as dataList;

class Home extends StatelessWidget {
  final VoidCallback onSignedOut;
  Home({this.onSignedOut});
  final List<ListApp> lists = dataList.list;
  final String appTitle = 'GMORIA';
  static String routeName = '/home';

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.appTitle),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      drawer: DrawerApp(
        appTitle: this.appTitle,
      ),
      body: Container(
        child: ListOfList(
          lists: lists,
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
