import 'package:flutter/material.dart';
import 'package:gmoria/auth/Auth.dart';

//MF
//Class that allows to notify the changes coming to the Account
class AuthProvider extends InheritedWidget {
  const AuthProvider({Key key, Widget child, this.auth})
      : super(key: key, child: child);
  final BaseAuth auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }
}
