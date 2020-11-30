import 'package:flutter/material.dart';
import 'auth/Auth.dart';
import 'auth/AuthProvider.dart';

class DrawerApp extends StatelessWidget {
  final Function onSignedOut;
  final String appTitle;
  DrawerApp({this.appTitle, this.onSignedOut});

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
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              appTitle,
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My profile'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About us'),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
