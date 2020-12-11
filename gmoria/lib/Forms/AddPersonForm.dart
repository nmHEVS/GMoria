import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPersonForm extends StatefulWidget {
  final listName;
  final listId;

  @override
  AddPersonForm({this.listName, this.listId});

  _AddPersonFormState createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<AddPersonForm> {
  final _formKey = GlobalKey<FormState>();
  final peopleNameController = TextEditingController();
  final peopleFirstnameController = TextEditingController();
  final peopleNotesController = TextEditingController();
  final peopleImageController = TextEditingController();

  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    peopleNameController.dispose();
    super.dispose();
  }

  void addPeople(
      String name, String firstname, String notes, String image) async {
    if (image == '') {
      image = 'assets/images/person2.PNG';
    }

    if (widget.listId == '') {
      await firestoreInstance
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('persons')
          .add({
        'name': name,
        'firstname': firstname,
        'notes': notes,
        'isCorrect': false,
        'image': image,
        'listIds': FieldValue.arrayUnion([]),
      });
    } else {
      await firestoreInstance
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('persons')
          .add({
        'name': name,
        'firstname': firstname,
        'notes': notes,
        'isCorrect': false,
        'image': image,
        'listIds': FieldValue.arrayUnion([widget.listId]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {},
                  iconSize: 110,
                ),
                TextFormField(
                  controller: peopleNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill this field';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: peopleFirstnameController,
                  decoration: InputDecoration(labelText: 'Firstname'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill this field';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: peopleNotesController,
                  decoration: InputDecoration(labelText: 'Notes '),
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
                      addPeople(
                          peopleNameController.text,
                          peopleFirstnameController.text,
                          peopleNotesController.text,
                          '');
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Create'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
