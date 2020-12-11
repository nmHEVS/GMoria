import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Add%20Edit/EditPersonPage.dart';

class PersonDetailsPage extends StatefulWidget {
  final idList;
  final idPerson;
  final listName;
  final image;

  PersonDetailsPage({this.idList, this.idPerson, this.listName, this.image});

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final String appTitle = 'GMORIA';
  var firestoreInstance = FirebaseFirestore.instance;
  DocumentReference documentReference;
  Map data;

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
            CircleAvatar(
              backgroundImage: AssetImage(data['image']),
              radius: 50,
            ),
            Container(
              child: Text('Name : ' + data['name']),
            ),
            Container(
              child: Text('Firstame : ' + data['firstname']),
            ),
            Container(
              child: Text('Notes : ' + data['notes']),
            ),
          ],
        ),
      ),
    );
  }
}
