import 'package:flutter/material.dart';
import 'package:gmoria/Home.dart';
import 'package:gmoria/ListOfPersons.dart';
import 'package:gmoria/PersonGameCard.dart';
import 'package:gmoria/PersonLearnCard.dart';
import 'package:gmoria/ScorePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        }
      },
    );
  }
}
