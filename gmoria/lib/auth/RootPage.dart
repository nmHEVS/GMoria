import 'package:flutter/material.dart';
import 'package:gmoria/auth/Auth.dart';
import 'package:gmoria/Pages/Home.dart';
import 'package:gmoria/Pages/LoginPage.dart';
import 'package:gmoria/auth/AuthProvider.dart';

//MF
//Root page that checks if the user is signed in or not and return the login page or the mainPage of the app according to it's status
class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  //MF
  //Sees if the userIsSignedIn or not and adapt the AuthStatus
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  //MF
  //If the user is signedIn the authStatus changes
  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  //MF
  //If the AuthStatus is signedIn it shows the mainPage, if it isn't signed in, it shows the loginPage
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return Home();
    }
    return null;
  }

  //MF
  //Waiting screen animation
  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
