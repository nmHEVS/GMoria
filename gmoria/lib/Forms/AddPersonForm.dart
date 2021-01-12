import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact_picker/contact_picker.dart';

import '../Applocalizations.dart';

//Created by GF & MF
//Class to add a new contact in the app

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
  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;

  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  var list;
  List _allPeople = [];
  var canBeAdded = true;
  var keywords = [];

  //GF
  //When this class is initiated, we fill a list with all the contact to compare with the new contact
  @override
  void initState() {
    super.initState();
    getAllPeople();
  }

  //MF
  PickedFile _image;
  final _picker = ImagePicker();
  File file;

  //MF
  void _imgFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  //MF
  void _imgFromGallery() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  //MF
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
  //When this class is disposed, we remove the listener on the controller of form
  @override
  void dispose() {
    peopleNameController.dispose();
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
  //Method to add a contact in Firestore
  //Either we specify a list Id and the contact will be aded in this list,
  //Either we don't specify anything and the contact will be aded in the global contact list
  void addPeople(
      String name, String firstname, String notes, String image) async {
    if (image == '') {
      image = 'assets/images/person2.PNG';
    }

    checkIfAlreadyExist(name, firstname);

    if (canBeAdded) {
      createKeywords(name, firstname);
      if (widget.listId == '') {
        addPeopleInContact(name, firstname, notes, image);
      } else {
        addPeopleInList(name, firstname, notes, image);
      }
    } else {
      canBeAdded = false;
    }
  }

  addPeopleInContact(name, firstname, notes, image) async {
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
      'searchKeyword': FieldValue.arrayUnion(keywords),
    });
  }

  addPeopleInList(name, firstname, notes, image) async {
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

  //GF
  //Method to check if a contact with the same name already exists
  checkIfAlreadyExist(name, firstname) {
    for (int i = 0; i < _allPeople.length; i++) {
      print(_allPeople[i]['name']);
      if (name == _allPeople[i]['name'] &&
          firstname == _allPeople[i]['firstname']) {
        canBeAdded = false;
        return;
      } else {
        canBeAdded = true;
      }
    }
  }

  getAllPeople() async {
    list = await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .orderBy('name')
        .get();

    setState(() {
      _allPeople = list.docs;
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
                TextFormField(
                  controller: peopleFirstnameController,
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
                TextFormField(
                  controller: peopleNotesController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate('labelNotes')),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () async {
                    //get contact from phone
                    Contact contact = await _contactPicker.selectContact();
                    setState(() {
                      _contact = contact;
                    });

                    //Separate firstname lastname
                    List<String> contactSplit = _contact.fullName.split(' ');
                    String lname = contactSplit.first;
                    String fname = contactSplit.last;

                    //fill the fields with info from contact selectionned
                    peopleFirstnameController.text = lname;
                    peopleNameController.text = fname;
                  },
                  child: Text(AppLocalizations.of(context)
                      .translate('labelImportContact')),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      addPeople(
                          peopleNameController.text,
                          peopleFirstnameController.text,
                          peopleNotesController.text,
                          peopleImageController.text = _image.path);
                      if (canBeAdded == false) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.indigo,
                          duration: Duration(seconds: 2),
                          content: Text(AppLocalizations.of(context)
                              .translate('alertContactAlreadyExist')),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      } else {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('labelCreate'),
                    style: TextStyle(fontSize: 40),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
