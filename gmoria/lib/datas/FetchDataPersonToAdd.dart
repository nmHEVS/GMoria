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
    fetchData2();
  }

  var all;
  fetchData2() {
    all = firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .snapshots();
    //.where('listIds', arrayContains: widget.listId);
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
                    //color: Colors.red[100],
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(doc[index]['image']),
                      ),
                      title: Text(doc[index]['name'].toString() +
                          ' ' +
                          doc[index]['firstname'].toString()),
                      //subtitle: Text('Already in this list'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              addPeople(widget.listId, doc[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // _buildChild(doc, index, addPeople, widget.listId, ids),
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

Widget _buildChild(doc, index, addPeople, listId, ids) {
  if (doc[index]['listIds[0]'] == listId) {
    return Card(
      color: Colors.red[100],
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(doc[index]['image']),
        ),
        title: Text(doc[index]['name'].toString() +
            ' ' +
            doc[index]['firstname'].toString()),
        subtitle: Text('Already in this list'),
      ),
    );
  } else {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(doc[index]['image']),
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
                  addPeople(listId, doc[index].id);
                }),
          ],
        ),
      ),
    );
  }
}
