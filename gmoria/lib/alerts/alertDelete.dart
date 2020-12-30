import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Applocalizations.dart';

var firestoreInstance = FirebaseFirestore.instance;
var firebaseUser = FirebaseAuth.instance.currentUser;

void deleteList(String listId) async {
  await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('lists')
      .doc(listId)
      .delete();
}

void deletePerson(String listId, String personId) async {
  if (listId == '') {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .doc(personId)
        .delete();
  } else {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .doc(personId)
        .update({
      'listIds': FieldValue.arrayRemove([listId])
    });
  }
}

Widget alertDelete(BuildContext context, String name, String listId,
    String personId, String objectToDelete) {
  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelDelete')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        objectToDelete == 'list'
            ? Text(
                AppLocalizations.of(context).translate('alertDeleteList') +
                    "$name ?",
                style: TextStyle(fontSize: 15),
              )
            : Text(
                AppLocalizations.of(context).translate('alertDeletePerson') +
                    "$name ?",
                style: TextStyle(fontSize: 15),
              ),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          if (objectToDelete == 'list') {
            deleteList(listId);
          } else {
            deletePerson(listId, personId);
          }
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: Text(AppLocalizations.of(context).translate('labelDelete')),
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
