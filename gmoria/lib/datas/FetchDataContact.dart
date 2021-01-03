import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Person/PersonDetailsPage.dart';
import 'package:gmoria/alerts/alertDelete.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FetchDataContact extends StatefulWidget {
  @override
  _FetchDataContactState createState() => _FetchDataContactState();
}

class _FetchDataContactState extends State<FetchDataContact> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  TextEditingController _searchController = TextEditingController();
  Future resultsLoaded;

  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getPeople();
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

  List _allResults = [];
  List _resultsList = [];
  var lists;

  getPeople() async {
    lists = await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .orderBy('name')
        .get();

    setState(() {
      _allResults = lists.docs;
    });
    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: Image.file(
                          File(_resultsList[index]['image'].toString()),
                          fit: BoxFit.fitHeight,
                        ).image,
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
                                    '',
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
                              idList: '',
                              idPerson: _resultsList[index].id,
                              listName: '',
                              image: _resultsList[index]['image'],
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
}
