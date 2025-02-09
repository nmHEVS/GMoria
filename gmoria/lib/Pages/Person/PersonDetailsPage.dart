import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Add%20Edit/EditPersonPage.dart';
import '../../Applocalizations.dart';

//Created by NM & GF
//Class to display details of a selected contact

class PersonDetailsPage extends StatefulWidget {
  final listId;
  final idPerson;
  final listName;
  final image;

  PersonDetailsPage({this.listId, this.idPerson, this.listName, this.image});

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final String appTitle = 'GMORIA';
  var firestoreInstance = FirebaseFirestore.instance;
  DocumentReference documentReference;
  Map data;

  //GF
  //fetch data
  fetchData() {
    documentReference = firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .doc(widget.idPerson);

    documentReference.snapshots().listen((snapshot) {
      setState(() {
        data = snapshot.data();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //NM
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.listName == ''
            ? Text(appTitle + ' - Contact\'s details')
            : Text(appTitle + ' - ' + widget.listName),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPersonPage(
                    name: data['name'],
                    firstname: data['firstname'],
                    notes: data['notes'],
                    image: data['image'],
                    personId: widget.idPerson,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            //NM
            //Photo
            Padding(
              padding: EdgeInsets.all(30.0),
              child: CircleAvatar(
                backgroundImage:
                    Image.file(File(data['image'].toString())).image,
                radius: 100,
              ),
            ),
            //NM
            //Name title
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('labelName') + ' :',
                  style: TextStyle(fontSize: 20, color: Colors.indigo),
                ),
              ),
            ),
            //NM
            //Name
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data['name'],
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            //NM
            //Firstname title
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('labelFirstname') +
                      ' :',
                  style: TextStyle(fontSize: 20, color: Colors.indigo),
                ),
              ),
            ),
            //NM
            //Firstname
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data['firstname'],
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            //NM
            //Notes title
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('labelNotes') + ' :',
                  style: TextStyle(fontSize: 20, color: Colors.indigo),
                ),
              ),
            ),
            //NM
            //Notes
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data['notes'],
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
