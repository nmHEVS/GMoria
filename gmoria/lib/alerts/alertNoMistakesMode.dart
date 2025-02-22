import 'package:flutter/material.dart';
import 'package:gmoria/Applocalizations.dart';

//Created by GF
//Alert message to notify the user that the mode Mistake only is not available because the list score is 100%

Widget alertNoMistakesMode(BuildContext context) {
  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelOups')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('labelNoMistakes'),
          style: TextStyle(fontSize: 15),
        ),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: Text(
          AppLocalizations.of(context).translate('labelGotIt'),
        ),
      ),
    ],
  );
}
