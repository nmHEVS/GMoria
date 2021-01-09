import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Applocalizations.dart';

//Created by GF
//Class to add a new list in the app

class AddListForm extends StatefulWidget {
  @override
  _AddListFormState createState() => _AddListFormState();
}

class _AddListFormState extends State<AddListForm> {
  final _formKey = GlobalKey<FormState>();
  final addListController = TextEditingController();

  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  var validate;
  var keywords = [];
  var _allLists;
  var list;

  //GF
  //When this class is initiated, we fill a list with all the contact to compare with the new contact
  @override
  void initState() {
    super.initState();
    getAllLists();
  }

  //GF
  //Method to check if a list with the same name already exists
  checkIfAlreadyExist(listName) {
    if (_allLists.length == 0) {
      validate = true;
    }
    for (int i = 0; i < _allLists.length; i++) {
      print(_allLists[i]['name']);
      if (listName == _allLists[i]['name']) {
        validate = false;
        return;
      } else {
        validate = true;
      }
    }
  }

  //GF
  //Method to create the keyword for search function
  createKeywords(name) {
    for (int i = 1; i < name.length + 1; i++) {
      keywords.add(name.substring(0, i));
    }
  }

  //GF
  //Method to add the list in Firestore
  void addList(String listName) async {
    checkIfAlreadyExist(listName);

    if (validate) {
      createKeywords(listName);
      await firestoreInstance
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('lists')
          .add({
        'name': listName,
        'score': 0,
        'searchKeyword': FieldValue.arrayUnion(keywords),
        'persons': FieldValue.arrayUnion([]),
      });
    } else {
      validate = false;
    }
  }

  getAllLists() async {
    list = await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .orderBy('name')
        .get();

    setState(() {
      _allLists = list.docs;
    });
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
                  addList(addListController.text);
                  if (validate == false) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                      content: Text(AppLocalizations.of(context)
                          .translate('alertListAlreadyExist')),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    Navigator.of(context).pop();
                  }
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
