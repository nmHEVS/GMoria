import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Add%20Edit/AddExistingPerson.dart';
import 'package:gmoria/Pages/Add%20Edit/EditListPage.dart';
import 'package:gmoria/Pages/Drawer/DrawerApp.dart';
import 'package:gmoria/Pages/Game/GameConfiguration.dart';
import 'package:gmoria/Pages/Home.dart';
import 'package:gmoria/Pages/Learn/PersonLearnCard.dart';
import 'package:gmoria/Pages/Person/PersonDetailsPage.dart';
import 'package:gmoria/alerts/alertDelete.dart';
import 'package:gmoria/alerts/alertNoPeople.dart';

//Created by GF
//Class to display the contact of a selected list

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

  var lists;
  List personsList = [];
  List personsMistakes = [];
  var listId;
  var image;
  String search = '';

  //GF
  //Display the contact with the name and the picture of the contact
  fetchData() {
    personsList = [];
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
                      .where('listIds', arrayContains: widget.idList)
                      .where('searchKeyword', arrayContains: search)
                      .snapshots()
                  : firestoreInstance
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .collection('persons')
                      .orderBy('name')
                      .where('listIds', arrayContains: widget.idList)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var doc = snapshot.data.docs;
                  return new ListView.builder(
                    itemCount: doc.length,
                    itemBuilder: (context, index) {
                      personsList.add(doc[index]);
                      listId = doc[index].id;
                      image = doc[index]['image'].toString();
                      if (doc[index]['isCorrect'] == false) {
                        personsMistakes.add(doc[index]);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: Image.file(File(image)).image,
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
                                          alertDelete(
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
                                    image: image,
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

  //Page to display the contact of a list
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle + " - " + widget.listName),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          },
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
                if (personsList.length == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => alertNoPeople(
                        context, 'learn', widget.listName, widget.idList),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonLearnCard(
                          personsList: personsList, listName: widget.listName),
                    ),
                  );
                }
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
                if (personsList.length == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => alertNoPeople(
                        context, 'play', widget.listName, widget.idList),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameConfiguration(
                          personsList: personsList,
                          listName: widget.listName,
                          listMistakes: personsMistakes,
                          listId: widget.idList),
                    ),
                  );
                }
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
                    builder: (context) => AddExistingPerson(
                      listId: widget.idList,
                      listName: widget.listName,
                    ),
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
