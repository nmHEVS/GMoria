import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Add%20Edit/AddPersonList.dart';

import '../Applocalizations.dart';

Widget alertNoPeople(
    BuildContext context, String origin, String listName, String idList) {
  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelStop')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
      new FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddPersonList(listName: listName, listId: idList),
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
