import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../Applocalizations.dart';

//Created by GF & MF
//Class to edit a contact

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
  var keywords = [];

  PickedFile _imagePicked;
  final _picker = ImagePicker();
  File file;
  File fileSaved;

//MF
//Pick an Image from the Camera (Take a picture)
  void _imgFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _imagePicked = image;
    });
  }

//MF
//Pick an image from the Gallery
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
                      title: new Text(AppLocalizations.of(context)
                          .translate('labelPhotoLibrary')),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(
                        AppLocalizations.of(context).translate('labelCamera')),
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

  //GF
  //When this class is initiated, we add the listeners on the controllers of form
  @override
  void initState() {
    super.initState();
    addNameController = TextEditingController(text: widget.name);
    addFirstnameController = TextEditingController(text: widget.firstname);
    addNotesController = TextEditingController(text: widget.notes);
    addImageController = TextEditingController(text: widget.image);
  }

  //GF
  //When this class is disposed, we remove the listeners on the controllers of form
  @override
  void dispose() {
    addNameController.dispose();
    addNotesController.dispose();
    addFirstnameController.dispose();
    addImageController.dispose();
    super.dispose();
  }

  //GF
  //Method to create the keyword for search function
  createKeywords(name, firstname) {
    for (int i = 1; i < name.length + 1; i++) {
      keywords.add(name.substring(0, i));
    }
    for (int i = 1; i < firstname.length + 1; i++) {
      keywords.add(firstname.substring(0, i));
    }
  }

  //GF
  //Method to update the contact in Firestore
  void updatePerson(
      String name, String firstname, String notes, String image) async {
    createKeywords(name, firstname);
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .doc(widget.personId)
        .update({
      'name': name,
      'firstname': firstname,
      'notes': notes,
      'image': image,
      'searchKeyword': FieldValue.arrayUnion(keywords),
    });
  }

  //GF
  //Display the form
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
                                  file = File(_imagePicked.path),
                                ).image,
                                radius: 65,
                              )),
                  ),
                ),
                TextFormField(
                  controller: addNameController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate('labelName')),
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
                TextFormField(
                  controller: addFirstnameController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                          .translate('labelFirstname')),
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
                TextFormField(
                  controller: addNotesController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate('labelNotes')),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (_imagePicked == null) {
                        addImageController.text = widget.image;
                      } else {
                        addImageController.text = _imagePicked.path;
                      }
                      updatePerson(
                        addNameController.text,
                        addFirstnameController.text,
                        addNotesController.text,
                        addImageController.text,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child:
                      Text(AppLocalizations.of(context).translate('labelSave')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
