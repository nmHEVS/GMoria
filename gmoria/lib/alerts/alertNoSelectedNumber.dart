import 'package:flutter/material.dart';

Widget alertNoSelectedNumber(BuildContext context) {
  return new AlertDialog(
    title: const Text('Oups !'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Please select a number of question to play ! ",
          style: TextStyle(fontSize: 15),
        )
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Got it !'),
      ),
    ],
  );
}
