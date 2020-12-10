import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        .update({'idList': ''});
  }
}

Widget alertDelete(BuildContext context, String name, String listId,
    String personId, String objectToDelete) {
  print("--------------------");
  print(listId);
  print(personId);
  return new AlertDialog(
    title: const Text('Delete'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        objectToDelete == 'list'
            ? Text(
                "Do you want to delete this list : $name ?",
                style: TextStyle(fontSize: 15),
              )
            : Text(
                "Do you want to delete this person : $name ?",
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
        child: const Text('Delete it'),
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
