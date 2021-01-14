import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Drawer/About.dart';
import 'package:gmoria/Pages/Drawer/Profile.dart';
import 'package:gmoria/Pages/Learn/PersonLearnCard.dart';
import 'package:gmoria/Pages/Person/PersonListPage.dart';
import 'package:gmoria/auth/AuthProvider.dart';
import 'package:gmoria/auth/RootPage.dart';
import 'Applocalizations.dart';
import 'Pages/Drawer/Settings.dart';
import 'Pages/Home.dart';
import 'Pages/Game/GameConfiguration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/Auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MyApp(),
  );
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
          //list of supported languages
          supportedLocales: [
            Locale('en', 'US'),
            Locale('fr', 'CH'),
            Locale('de', 'CH'),
          ],
          //Delegates make sure the proper localization data is loaded for the proper language
          localizationsDelegates: [
            //loads translations from JSON files
            AppLocalizations.delegate,
            //Built-in localization of basic test for material widgets
            GlobalMaterialLocalizations.delegate,
            //Built-in localization for text direction (right to left / left to right)
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          //return the local wich will be used by the app
          localeResolutionCallback: (locale, supportedLocales) {
            //Check if the current device locale is suported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            //If the locale language of phone is not supported by the app, use the first (En)
            return supportedLocales?.first;
          },
          //Routes for every page displayed in the app
          routes: {
            PersonListPage.routeName: (context) {
              return PersonListPage();
            },
            PersonLearnCard.routeName: (context) {
              return PersonLearnCard();
            },
            Home.routeName: (context) {
              return Home();
            },
            About.routeName: (context) {
              return About();
            },
            Settings.routeName: (context) {
              return Settings();
            },
            GameConfiguration.routeName: (context) {
              return GameConfiguration();
            },
            Profile.routeName: (context) {
              return Profile();
            },
          },
        ));
  }
}
