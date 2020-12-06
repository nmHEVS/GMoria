import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Home.dart';

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

  @override
  void initState() {
    super.initState();
    addListController = TextEditingController(text: widget.listName);
  }

  @override
  void dispose() {
    addListController.dispose();
    super.dispose();
  }

  void updateList(String listName) async {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .doc(widget.listId)
        .update({'name': listName});
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
              decoration: InputDecoration(labelText: 'List\'s name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please fill this field';
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
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
