import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Home.dart';

class EditPersonForm extends StatefulWidget {
  final name;
  final firstname;
  final image;
  final notes;
  final personId;

  EditPersonForm(
      {this.name, this.firstname, this.notes, this.image, this.personId});
  @override
  _EditPersonFormState createState() => _EditPersonFormState();
}

class _EditPersonFormState extends State<EditPersonForm> {
  final _formKey = GlobalKey<FormState>();
  var addNameController = TextEditingController();
  var addImageController = TextEditingController();
  var addFirstnameController = TextEditingController();
  var addNotesController = TextEditingController();
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    addNameController = TextEditingController(text: widget.name);
    addFirstnameController = TextEditingController(text: widget.firstname);
    addNotesController = TextEditingController(text: widget.notes);
    addImageController = TextEditingController(text: widget.image);
  }

  @override
  void dispose() {
    addNameController.dispose();
    addNotesController.dispose();
    addFirstnameController.dispose();
    addImageController.dispose();
    super.dispose();
  }

  void updateList(
      String name, String firstname, String notes, String image) async {
    if (image == '') {
      image = 'assets/images/person2.PNG';
    }
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .doc(widget.personId)
        .update({
      'name': name,
      'firstname': firstname,
      'notes': notes,
      'image': image
    });
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
                  controller: addNameController,
                  decoration: InputDecoration(labelText: 'Name'),
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
                TextFormField(
                  controller: addFirstnameController,
                  decoration: InputDecoration(labelText: 'Firstname'),
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
                TextFormField(
                  controller: addNotesController,
                  decoration: InputDecoration(labelText: 'Notes'),
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
                      updateList(
                          addNameController.text,
                          addFirstnameController.text,
                          addNotesController.text,
                          addImageController.text);
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
        ),
      ),
    );
  }
}
