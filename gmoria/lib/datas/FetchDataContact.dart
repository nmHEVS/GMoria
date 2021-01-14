import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Person/PersonDetailsPage.dart';
import 'package:gmoria/alerts/alertDelete.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Created by GF
//Class to fetch data from Firebase
//Fech all the people created by a user to do the contact list

class FetchDataContact extends StatefulWidget {
  @override
  _FetchDataContactState createState() => _FetchDataContactState();
}

class _FetchDataContactState extends State<FetchDataContact> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  //GF
  //variable for the search bar
  String search = '';

//GF
//Display the contact with the name and the picture of the contact
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                search = val;
              });
            },
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (search != "" && search != null)
                  ? firestoreInstance
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .collection('persons')
                      .where('searchKeyword', arrayContains: search)
                      .snapshots()
                  : firestoreInstance
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .collection('persons')
                      .orderBy('name')
                      .snapshots(),
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
                              backgroundImage: Image.file(
                                      File(doc[index]['image'].toString()))
                                  .image,
                            ),
                            title: Text(doc[index]['name'].toString() +
                                ' ' +
                                doc[index]['firstname'].toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20.0,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    var name = doc[index]['name'].toString() +
                                        ' ' +
                                        doc[index]['firstname'].toString();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          alertDelete(context, name, '',
                                              doc[index].id, 'person'),
                                    );
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonDetailsPage(
                                    listId: '',
                                    idPerson: doc[index].id,
                                    listName: '',
                                    image: doc[index]['image'],
                                  ),
                                ),
                              );
                            },
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
          ),
        ],
      ),
    );
  }
}
