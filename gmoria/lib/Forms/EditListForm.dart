import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Home.dart';
import '../Applocalizations.dart';

//Created by GF
//Class to edit the name of the selected list

class EditListForm extends StatefulWidget {
  final listId;
  final listName;

  EditListForm({this.listId, this.listName});

  @override
  _EditListFormState createState() => _EditListFormState();
}

class _EditListFormState extends State<EditListForm> {
  final _formKey = GlobalKey<FormState>();
  var addListController = TextEditingController();
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  //GF
  //When this class is initiated, we add the listener on the controller of form
  @override
  void initState() {
    super.initState();
    addListController = TextEditingController(text: widget.listName);
  }

  //GF
  //When this class is disposed, we remove the listener on the controller of form
  @override
  void dispose() {
    addListController.dispose();
    super.dispose();
  }

  //GF
  //Method to update the list in Firestore
  void updateList(String listName) async {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .doc(widget.listId)
        .update({'name': listName});
  }

  //GF
  //Display the form
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
                  updateList(addListController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context).translate('labelSave')),
            )
          ],
        ),
      ),
    );
  }
}
