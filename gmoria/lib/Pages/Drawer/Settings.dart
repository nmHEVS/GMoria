import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Applocalizations.dart';

class Settings extends StatefulWidget {
  static String routeName = '/settings';
  final String appTitle = 'GMORIA';

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.appTitle),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Text(
                AppLocalizations.of(context).translate('labelLanguageInUse'),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context).translate('languageInUse'),
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context).translate('labelLanguageList'),
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context).translate('labelFrench'),
                style: TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context).translate('labelEnglish'),
                style: TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context).translate('labelGerman'),
                style: TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
