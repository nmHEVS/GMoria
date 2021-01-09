import 'package:flutter/material.dart';
import 'package:gmoria/Applocalizations.dart';

//Created by GF
//Alert message to notify the user that he didn't select a correct number of questions

Widget alertNoSelectedNumber(BuildContext context) {
  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelOups')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('labelNoSelectedNumber'),
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
