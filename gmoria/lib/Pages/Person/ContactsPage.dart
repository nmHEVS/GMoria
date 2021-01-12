import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Add%20Edit/AddPersonPage.dart';
import 'package:gmoria/Pages/Drawer/DrawerApp.dart';
import 'package:gmoria/alerts/alertDelete.dart';
import 'package:gmoria/datas/FetchDataContact.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../../Applocalizations.dart';

//Created by GF
//Class to display all the existing contact of a user

class ContactsPage extends StatefulWidget {
  final String appTitle = 'GMORIA';
  final firestoreInstance = FirebaseFirestore.instance;
  //final firebaseUser = FirebaseAuth.instance.currentUser;
  final userRef = FirebaseFirestore.instance.collection('users');

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: FetchDataContact(),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            top: 30.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'addPeople',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPersonPage(
                      listName: '',
                      listId: '',
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            right: 80.0,
            child: FloatingActionButton(
              heroTag: '1',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Import a list of contact from a .csv"),
                    content: Text("Form must be : "
                        "Name"
                        ", "
                        "Lastname"
                        ", "
                        "Notes"
                        ""),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          pickCsv();
                        },
                        child: Text("Ok"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("CSV"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> pickCsv() async {
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );
  if (result != null) {
    PlatformFile file = result.files.first;
    final input = new File(file.path).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    print(fields);

    List contact = new List();
    for (int i = 0; i < fields.length; i++) {
      contact.add(fields[i]);

      print(contact);
      print(contact[0][0]);
      print(contact[0][1]);
      print(contact[0][2]);

      addPeople(contact[0][1], contact[0][0], contact[0][2]);
      contact.clear();
    }
  }
}

void addPeople(String name, String firstname, String notes) async {
  await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('persons')
      .add({
    'name': name,
    'firstname': firstname,
    'notes': notes,
    'isCorrect': false,
    'image': null,
    'listIds': FieldValue.arrayUnion([]),
  });
}
