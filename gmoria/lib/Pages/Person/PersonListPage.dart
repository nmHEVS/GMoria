import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Add%20Edit/AddExistingPerson.dart';
import 'package:gmoria/Pages/Add%20Edit/EditListPage.dart';
import 'package:gmoria/Pages/Drawer/DrawerApp.dart';
import 'package:gmoria/Pages/Game/GameConfiguration.dart';
import 'package:gmoria/Pages/Learn/PersonLearnCard.dart';
import 'package:gmoria/Pages/Person/PersonDetailsPage.dart';
import 'package:gmoria/alerts/alertDelete.dart';
import 'package:gmoria/alerts/alertNoPeople.dart';

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
  @override
  void initState() {
    super.initState();
    getPeopleOfTheList();
    _searchController.addListener(_onSearchChanged);
  }

  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  TextEditingController _searchController = TextEditingController();
  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  var lists;

  List personsList = [];
  List personsMistakes = [];
  var listId;
  var image;

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getPeopleOfTheList();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  var showResults;
  searchResultsList() {
    showResults = [];
    if (_searchController.text != "") {
      for (int i = 0; i < _allResults.length; i++) {
        var name = _allResults[i]['name'].toString().toLowerCase();
        var firstname = _allResults[i]['firstname'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase()) ||
            firstname.contains(_searchController.text.toLowerCase())) {
          showResults.add(_allResults[i]);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultsList = showResults;
    });
  }

  getPeopleOfTheList() async {
    lists = await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .orderBy('name')
        .where('listIds', arrayContains: widget.idList)
        .get();

    setState(() {
      _allResults = lists.docs;
    });
    searchResultsList();
    return "complete";
  }

  fetchData() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _resultsList.length,
              itemBuilder: (context, index) {
                personsList.add(_resultsList[index]);
                listId = _resultsList[index].id;
                image = _resultsList[index]['image'].toString();
                if (_resultsList[index]['isCorrect'] == false) {
                  personsMistakes.add(_resultsList[index]);
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: Image.file(File(image)).image,
                      ),
                      title: Text(_resultsList[index]['name'].toString() +
                          ' ' +
                          _resultsList[index]['firstname'].toString()),
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
                              var name = _resultsList[index]['name']
                                      .toString() +
                                  ' ' +
                                  _resultsList[index]['firstname'].toString();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => alertDelete(
                                    context,
                                    name,
                                    widget.idList,
                                    _resultsList[index].id,
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
                              idPerson: _resultsList[index].id,
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
            ),
          ),
        ],
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
          onPressed: () => Navigator.pop(context),
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
