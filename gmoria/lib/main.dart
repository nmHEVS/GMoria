import 'package:flutter/material.dart';
import 'Pages/About.dart';
import 'Pages/Home.dart';
import 'Pages/ListOfPersons.dart';
import 'Pages/PersonGameCard.dart';
import 'Pages/PersonInfo.dart';
import 'Pages/PersonLearnCard.dart';
import 'Pages/ScorePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
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
    );
  }
}
