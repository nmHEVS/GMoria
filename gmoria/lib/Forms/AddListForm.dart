import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Applocalizations.dart';

class AddListForm extends StatefulWidget {
  @override
  _AddListFormState createState() => _AddListFormState();
}

class _AddListFormState extends State<AddListForm> {
  final _formKey = GlobalKey<FormState>();
  final addListController = TextEditingController();
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    addListController.dispose();
    super.dispose();
  }

  void addList(String listName) async {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .add({'name': listName, 'score': 0});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: addListController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context).translate('labelListName')),
              validator: (value) {
                if (value.isEmpty) {
                  return AppLocalizations.of(context)
                      .translate('alertPleaseFill');
                }
                return null;
              },
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  addList(addListController.text);
                  Navigator.of(context).pop();
                }
              },
              child:
                  Text(AppLocalizations.of(context).translate('labelCreate')),
            )
          ],
        ),
      ),
    );
  }
}
