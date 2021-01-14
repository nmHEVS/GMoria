import 'package:flutter/material.dart';
import 'package:gmoria/Applocalizations.dart';

//Created by GF
//Alert message to help the user to undertand the quiz game

Widget alertHelpQuizGame(BuildContext context) {
  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelQuizGame')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('labelHelpQuizGame'),
          style: TextStyle(fontSize: 15),
        ),
      ],
    ),
    actions: <Widget>[
      //GF
      //One button to pop the message
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: Text(AppLocalizations.of(context).translate('labelGotIt')),
      ),
    ],
  );
}
