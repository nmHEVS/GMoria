import 'package:flutter/material.dart';
import 'package:gmoria/Applocalizations.dart';
import 'package:gmoria/Pages/Drawer/DrawerApp.dart';
import 'package:gmoria/Pages/List/ListsPage.dart';
import 'package:gmoria/Pages/Person/ContactsPage.dart';
import 'package:gmoria/auth/Auth.dart';
import 'package:gmoria/auth/AuthProvider.dart';

class Home extends StatefulWidget {
  final VoidCallback onSignedOut;
  Home({this.onSignedOut});
  final String appTitle = 'GMORIA';
  static String routeName = '/home';

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Map data;
  int selectedIndex;
  final tabs = [ListsPage(), ContactsPage()];

  @override
  void initState() {
    super.initState();
    print('init state');
    selectedIndex = 0;
  }

  void switchIndex(newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

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
        title: selectedIndex == 0
            ? Text(widget.appTitle +
                " - " +
                AppLocalizations.of(context).translate('labelLists'))
            : Text(widget.appTitle +
                " - " +
                AppLocalizations.of(context).translate('labelContacts')),
      ),
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: AppLocalizations.of(context).translate('labelLists')),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_page),
              label: AppLocalizations.of(context).translate('labelContacts')),
        ],
        currentIndex: selectedIndex,
        onTap: switchIndex,
      ),
    );
  }
}
