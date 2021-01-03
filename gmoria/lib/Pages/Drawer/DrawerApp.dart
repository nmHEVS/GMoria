import 'package:flutter/material.dart';
import 'package:gmoria/auth/Auth.dart';
import 'package:gmoria/auth/AuthProvider.dart';
import 'package:gmoria/auth/RootPage.dart';

import '../../Applocalizations.dart';

class DrawerApp extends StatelessWidget {
  final VoidCallback onSignedOut;
  final String appTitle;
  DrawerApp({this.appTitle, this.onSignedOut});

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
            title:
                Text(AppLocalizations.of(context).translate('labelMyProfile')),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title:
                Text(AppLocalizations.of(context).translate('labelSettings')),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(AppLocalizations.of(context).translate('labelAbout')),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppLocalizations.of(context).translate('labelLogout')),
            onTap: () {
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
