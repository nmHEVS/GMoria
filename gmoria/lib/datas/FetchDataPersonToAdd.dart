import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Applocalizations.dart';

class FetchDataPersonToAdd extends StatefulWidget {
  final listId;

  FetchDataPersonToAdd({this.listId});

  @override
  _FetchDataPersonToAddState createState() => _FetchDataPersonToAddState();
}

class _FetchDataPersonToAddState extends State<FetchDataPersonToAdd> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future resultsLoaded;
  var test;
  var list;
  var _allPeopleInList;
  var snackBar;

  String search = '';

//GF
  //When this class is initiated, we fill a list with all the contact to compare with the new contact
  @override
  void initState() {
    super.initState();
    getPeopleAlreadyInTheList();
  }

  getPeopleAlreadyInTheList() async {
    list = await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .get();

    setState(() {
      _allPeopleInList = list.docs;
    });
  }

  //GF
  //Method to add a contact in te current list
  void addPeople(String listId, String personId) async {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .doc(personId)
        .update({
      'listIds': FieldValue.arrayUnion([widget.listId]),
    });

    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .doc(widget.listId)
        .update({
      'persons': FieldValue.arrayUnion([personId])
    });
  }

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
                              backgroundImage:
                                  Image.file(File(doc[index]['image'])).image,
                            ),
                            title: Text(doc[index]['name'].toString() +
                                ' ' +
                                doc[index]['firstname'].toString()),
                            trailing:

                                //GF
                                //icon to add the contact
                                Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    snackBar = null;
                                    if (doc[index]['listIds'].length == 0) {
                                      addPeople(widget.listId, doc[index].id);
                                      snackBar = SnackBar(
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                            AppLocalizations.of(context)
                                                .translate('alertAddedToList')),
                                      );
                                    }
                                    for (int i = 0;
                                        i < doc[index]['listIds'].length;
                                        i++) {
                                      if (doc[index]['listIds'][i] ==
                                          widget.listId) {
                                        snackBar = SnackBar(
                                          backgroundColor: Colors.yellow[800],
                                          duration: Duration(seconds: 2),
                                          content: Text(
                                            AppLocalizations.of(context)
                                                .translate('alertAlreadyAdded'),
                                          ),
                                        );
                                      } else {
                                        addPeople(widget.listId, doc[index].id);
                                        snackBar = SnackBar(
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                          content: Text(AppLocalizations.of(
                                                  context)
                                              .translate('alertAddedToList')),
                                        );
                                      }
                                    }

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
          ),
        ],
      ),
    );
  }
}
