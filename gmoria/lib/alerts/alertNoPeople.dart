import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Add%20Edit/AddExistingPerson.dart';
import '../Applocalizations.dart';

//Created by GF
//Alert message to notify the user that he can't play or learn an empty list

Widget alertNoPeople(
    BuildContext context, String origin, String listName, String idList) {
  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelStop')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //GF
        //The alert message depends on if we try to play or to learn the empty list
        origin == 'play'
            ? Text(
                AppLocalizations.of(context).translate('alertEmptyListPlay'),
                style: TextStyle(fontSize: 15),
              )
            : Text(
                AppLocalizations.of(context).translate('alertEmptyListLearn'),
                style: TextStyle(fontSize: 15),
              ),
      ],
    ),
    actions: <Widget>[
      //GF
      //Two buttons : one to add people one to cancel
      new FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddExistingPerson(listName: listName, listId: idList),
            ),
          );
        },
        textColor: Theme.of(context).primaryColor,
        child: Text(AppLocalizations.of(context).translate('labelAddContact')),
      ),
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: Text(AppLocalizations.of(context).translate('labelCancel')),
      ),
    ],
  );
}
