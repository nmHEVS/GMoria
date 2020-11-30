import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Map data;

  fetchData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .doc(widget.idList)
        .collection('persons')
        .doc(widget.idPerson);

    documentReference.snapshots().listen((snapshot) {
      setState(() {
        data = snapshot.data();
        print('+++++++++++' + data.toString());
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
        title: Text(appTitle + ' - ' + widget.listName),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
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
