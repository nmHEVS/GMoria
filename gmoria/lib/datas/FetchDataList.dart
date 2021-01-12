import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Person/PersonListPage.dart';
import 'package:gmoria/alerts/alertDelete.dart';

//Created by GF
//Class to fetch data from Firebase
//Fech all the list created by a user

class FetchDataList extends StatefulWidget {
  @override
  _FetchDataListState createState() => _FetchDataListState();
}

class _FetchDataListState extends State<FetchDataList> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  //GF
  //variable for the search bar
  String search = '';

  //GF
  //Display the list with the name and the picture of the contact
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
                      .collection('lists')
                      .where('searchKeyword', arrayContains: search)
                      .snapshots()
                  : firestoreInstance
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .collection('lists')
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
                            title: Text(doc[index]['name'].toString()),
                            subtitle:
                                Text(doc[index]['score'].toString() + "%"),
                            trailing:
                                //GF
                                //icon to delete the list
                                Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20.0,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    //GF
                                    //Alert to confirm the deletion
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          alertDelete(
                                              context,
                                              doc[index]['name'].toString(),
                                              doc[index].id,
                                              '',
                                              'list'),
                                    );
                                  },
                                ),
                              ],
                            ),
                            //GF
                            //Tap on the list to see the contact
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonListPage(
                                      listId: doc[index].id,
                                      listName: doc[index]['name'].toString()),
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
