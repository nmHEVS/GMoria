import 'package:flutter/material.dart';
import 'auth/Auth.dart';
import 'auth/AuthProvider.dart';

class DrawerApp extends StatelessWidget {
  const DrawerApp({this.appTitle, this.onSignedOut});
  final String appTitle;
  final VoidCallback onSignedOut;

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
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('assets/images/banner.png'),
                fit: BoxFit.cover,
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
            leading: Icon(Icons.info),
            title: Text('Logout'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
