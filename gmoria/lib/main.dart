import 'package:flutter/material.dart';
import 'package:gmoria/auth/AuthProvider.dart';
import 'package:gmoria/auth/RootPage.dart';
import 'Pages/About.dart';
import 'Pages/Home.dart';
import 'Pages/ListOfPersons.dart';
import 'Pages/PersonGameCard.dart';
import 'Pages/PersonInfo.dart';
import 'Pages/PersonLearnCard.dart';
import 'Pages/ScorePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/Auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          home: RootPage(),
          routes: {
            PersonList.routeName: (context) {
              return PersonList();
            },
            PersonLearnCard.routeName: (context) {
              return PersonLearnCard();
            },
            PersonGameCard.routeName: (context) {
              return PersonGameCard();
            },
            ScorePage.routeName: (context) {
              return ScorePage();
            },
            Home.routeName: (context) {
              return Home();
            },
            PersonInfo.routeName: (context) {
              return PersonInfo();
            },
            About.routeName: (context) {
              return About();
            }
          },
        ));
  }
}
