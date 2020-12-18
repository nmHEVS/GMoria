import 'package:flutter/material.dart';
import 'package:gmoria/auth/Auth.dart';
import 'package:gmoria/auth/AuthProvider.dart';
import 'package:gmoria/auth/RootPage.dart';

class DrawerApp extends StatelessWidget {
  final String appTitle;
  DrawerApp({this.appTitle});

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RootPage(),
        ),
      );
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
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
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
            onTap: () {
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
