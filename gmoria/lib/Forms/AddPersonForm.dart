import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

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

  PickedFile _image;
  final _picker = ImagePicker();
  File file;

  void _imgFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _imgFromGallery() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

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
              children: <Widget>[
                SizedBox(
                  height: 32,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Color(0xFF1A237E),
                        child: _image == null
                            ? _image != null
                                ? CircleAvatar(
                                    backgroundImage: Image.file(
                                      file = File(_image.path),
                                    ).image,
                                    radius: 65,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(65)),
                                    width: 110,
                                    height: 110,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  )
                            : CircleAvatar(
                                backgroundImage: Image.file(
                                  file = File(_image.path),
                                ).image,
                                radius: 65,
                              )),
                  ),
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
                          peopleImageController.text = _image.path);
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
