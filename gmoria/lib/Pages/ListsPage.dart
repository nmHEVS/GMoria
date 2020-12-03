import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/PersonListPage.dart';

class ListsPage extends StatefulWidget {
  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  void deleteList(String listId) async {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .doc(listId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 70),
      child: StreamBuilder<QuerySnapshot>(
        stream: firestoreInstance
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('lists')
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
                        subtitle: Text(doc[index]['score'].toString() + "%"),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 20.0,
                                  color: Colors.brown[900],
                                ),
                                onPressed: () {
                                  deleteList(doc[index].id);
                                },
                              ),
                            ]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonListPage(
                                  idList: doc[index].id,
                                  name: doc[index]['name'].toString()),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                });
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
