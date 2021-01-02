import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FetchDataPersonToAdd extends StatefulWidget {
  final listId;

  FetchDataPersonToAdd({this.listId});

  @override
  _FetchDataPersonToAddState createState() => _FetchDataPersonToAddState();
}

class _FetchDataPersonToAddState extends State<FetchDataPersonToAdd> {
  @override
  void initState() {
    super.initState();
    getPeople();
  }

  var all;
  getPeople() {
    all = firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .orderBy('name')
        .snapshots();
  }

  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  bool isChecked = false;

  void addPeople(String listId, String personId) async {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .doc(personId)
        .update({
      'listIds': FieldValue.arrayUnion([widget.listId]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 70),
      child: StreamBuilder<QuerySnapshot>(
        stream: all,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var doc = snapshot.data.docs;
            return new ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            Image.file(File(doc[index]['image'])).image,
                      ),
                      title: Text(doc[index]['name'].toString() +
                          ' ' +
                          doc[index]['firstname'].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              addPeople(widget.listId, doc[index].id);
                              final snackBar = SnackBar(
                                backgroundColor: Colors.indigo,
                                duration: Duration(seconds: 2),
                                content: Text('Added to the list !'),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
