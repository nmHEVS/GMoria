import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria/alerts/alertDelete.dart';
import 'package:gmoria/auth/Auth.dart';
import 'package:gmoria/auth/AuthProvider.dart';
import 'package:gmoria/auth/RootPage.dart';

import '../../Applocalizations.dart';

class Profile extends StatefulWidget {
  static String routeName = '/profile';
  final String appTitle = 'GMORIA';
  final firestoreInstance = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final userRef = FirebaseFirestore.instance.collection('users');
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.appTitle),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text(
                AppLocalizations.of(context).translate('labelMyProfile'),
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    color: Colors.red,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildDeleteDialog(context),
                      );
                    },
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('labelDeleteAccount')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void deleteList(String listId) async {
  await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('lists')
      .doc(listId)
      .delete();
}

void deletePerson(String personId) async {
  await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('persons')
      .doc(personId)
      .delete();
}

void deleteListData() async {
  //Delete lists
  QuerySnapshot querySnapshotList = await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('lists')
      .get();

  querySnapshotList.docs.forEach((element) {
    print(element.id);
    deleteList(element.id);
  });
}

void deletePersonData() async {
  //Delete persons
  QuerySnapshot querySnapshotPerson = await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('persons')
      .get();

  querySnapshotPerson.docs.forEach((element) {
    print(element.id);
    deletePerson(element.id);
  });
}

void _signOut(BuildContext context) async {
  try {
    final BaseAuth auth = AuthProvider.of(context).auth;
    deleteListData();
    deletePersonData();
    await auth.deleteAccount();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RootPage(),
      ),
    );
  } catch (e) {
    print(e);
  }
}

Widget _buildDeleteDialog(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text(AppLocalizations.of(context).translate('labelCancel')),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(AppLocalizations.of(context).translate('labelDelete')),
    onPressed: () {
      _signOut(context);
    },
  );

  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelDeleteAccount')),
    content: Text(AppLocalizations.of(context).translate('alertDeleteAccont')),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
}
