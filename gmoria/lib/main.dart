import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Drawer/About.dart';
import 'package:gmoria/Pages/Game/PersonGameCard.dart';
import 'package:gmoria/Pages/Game/ScorePage.dart';
import 'package:gmoria/Pages/Learn/PersonLearnCard.dart';
import 'package:gmoria/Pages/Person/PersonInfo.dart';
import 'package:gmoria/Pages/Person/PersonListPage.dart';
import 'package:gmoria/auth/AuthProvider.dart';
import 'package:gmoria/auth/RootPage.dart';
import 'Pages/Home.dart';
import 'Pages/Game/GameConfiguration.dart';
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
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          home: RootPage(),
          routes: {
            PersonListPage.routeName: (context) {
              return PersonListPage();
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
            },
            GameConfiguration.routeName: (context) {
              return GameConfiguration();
            }
          },
        ));
  }
}
