import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Add%20Edit/AddPersonList.dart';

Widget alertNoPeople(
    BuildContext context, String origin, String listName, String idList) {
  return new AlertDialog(
    title: const Text('Stop !'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        origin == 'play'
            ? Text(
                "Your list is empty ! Please add some contact before playing !",
                style: TextStyle(fontSize: 15),
              )
            : Text(
                "Your list is empty ! Please add some contact before learning !",
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
        child: const Text('Add contact'),
      ),
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Cancel'),
      ),
    ],
  );
}
