import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Applocalizations.dart';

//Created by GF
//Alert message to confirm the deletion of a contact or a list

var firestoreInstance = FirebaseFirestore.instance;
var firebaseUser = FirebaseAuth.instance.currentUser;

//GF
//Method to delete the list of Firestore
void deleteList(String listId) async {
  await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('lists')
      .doc(listId)
      .delete();
}

//GF
//Method to delete the contact of Firestore or delete of the selected list
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

//GF
//Widget alert
Widget alertDelete(BuildContext context, String name, String listId,
    String personId, String objectToDelete) {
  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelDelete')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //GF
        //The alert message depends on if we delete a list or a contact
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
      //GF
      //Two buttons : one to confirm the deletion and one to cancel
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
