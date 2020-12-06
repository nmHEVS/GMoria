import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/AddPersonPage.dart';
import 'package:gmoria/Pages/EditListPage.dart';
import 'package:gmoria/Pages/PersonDetailsPage.dart';
import 'package:gmoria/Pages/PersonGameCard.dart';
import 'package:gmoria/Pages/PersonLearnCard.dart';
import 'package:gmoria/alerts/alertDelete.dart';

class PersonListPage extends StatefulWidget {
  final idList;
  final listName;
  final String appTitle = 'GMORIA';
  static String routeName = '/listContent';

  PersonListPage({this.idList, this.listName});

  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  List personsList = [];
  var listId;

  fetchData() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 70),
      child: StreamBuilder<QuerySnapshot>(
        stream: firestoreInstance
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('lists')
            .doc(widget.idList)
            .collection('persons')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var doc = snapshot.data.docs;
            return new ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                personsList.add(doc[index]);
                listId = doc[index].id;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(doc[index]['image']),
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
                              color: Colors.brown[900],
                            ),
                            onPressed: () {
                              var name = doc[index]['name'].toString() +
                                  ' ' +
                                  doc[index]['firstname'].toString();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => alertDelete(
                                    context,
                                    name,
                                    widget.idList,
                                    doc[index].id,
                                    'person'),
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
                              idList: widget.idList,
                              idPerson: doc[index].id,
                              listName: widget.listName,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle + " - " + widget.listName),
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
                  builder: (context) => EditListPage(
                      listId: widget.idList, listName: widget.listName),
                ),
              );
            },
          ),
        ],
      ),
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: fetchData(),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            top: 110.0,
            right: 65.0,
            child: FloatingActionButton(
              heroTag: 'learn',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonLearnCard(
                        personsList: personsList, listName: widget.listName),
                  ),
                );
              },
              child: Icon(Icons.book),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          Positioned(
            top: 110.0,
            right: 130.0,
            child: FloatingActionButton(
              heroTag: 'game',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonGameCard(
                        personsList: personsList,
                        listName: widget.listName,
                        listId: listId),
                  ),
                );
              },
              child: Icon(Icons.play_arrow),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          Positioned(
            top: 110.0,
            right: 0.0,
            child: FloatingActionButton(
              heroTag: 'addPeople',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPersonPage(
                        listName: widget.listName, listId: widget.idList),
                  ),
                );
              },
              child: Icon(Icons.add),
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
