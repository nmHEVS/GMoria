import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Home.dart';
import 'package:image_picker/image_picker.dart';

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
  PickedFile _imagePicked;
  final _picker = ImagePicker();
  File file;
  File fileSaved;

  void _imgFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _imagePicked = image;
    });
  }

  void _imgFromGallery() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _imagePicked = image;
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
                        child: _imagePicked == null
                            ? widget.image != null
                                ? CircleAvatar(
                                    backgroundImage: Image.file(
                                      file = File(widget.image),
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
                                  file = File(widget.image),
                                ).image,
                                radius: 65,
                              )),
                  ),
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
                        addImageController.text = _imagePicked.path,
                      );
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
