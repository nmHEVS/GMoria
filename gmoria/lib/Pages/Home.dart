import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';
import 'package:gmoria/Pages/AddListPage.dart';
import 'package:gmoria/Pages/EditListPage.dart';
import 'package:gmoria/Pages/ListsPage.dart';
import 'package:gmoria/models/ListModel.dart';
import 'package:gmoria/auth/Auth.dart';
import 'package:gmoria/auth/AuthProvider.dart';
import '../datas/dataList.dart' as dataList;

class Home extends StatefulWidget {
  final VoidCallback onSignedOut;
  Home({this.onSignedOut});
  final List<ListApp> lists = dataList.list;
  final String appTitle = 'GMORIA';
  static String routeName = '/home';

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Map data;

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: ListsPage(),
      floatingActionButton: Stack(
        children: <Widget>[
          /*Positioned(
            top: 110.0,
            right: 0.0,
            child: FloatingActionButton(
              heroTag: 'editList',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditListPage(),
                  ),
                );
              },
              child: Icon(Icons.edit),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),*/
          Positioned(
            top: 110.0,
            right: 0.0,
            child: FloatingActionButton(
              heroTag: 'addList',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddListPage(),
                  ),
                );
              },
              child: Icon(Icons.add),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
