import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Person/PersonListPage.dart';
import 'package:gmoria/alerts/alertDelete.dart';

class FetchDataList extends StatefulWidget {
  @override
  _FetchDataListState createState() => _FetchDataListState();
}

class _FetchDataListState extends State<FetchDataList> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  TextEditingController _searchController = TextEditingController();
  Future resultsLoaded;

  @override
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
    resultsLoaded = getList();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  var showResults;
  searchResultsList() {
    showResults = [];
    if (_searchController.text != "") {
      for (int i = 0; i < _allResults.length; i++) {
        var title = _allResults[i]['name'].toString().toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
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

  getList() async {
    lists = await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('lists')
        .orderBy('name')
        .get();

    setState(() {
      _allResults = lists.docs;
    });
    searchResultsList();
    return "complete";
  }

  var idList;

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
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(_resultsList[index]['name'].toString()),
                      subtitle:
                          Text(_resultsList[index]['score'].toString() + "%"),
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => alertDelete(
                                    context,
                                    _resultsList[index]['name'].toString(),
                                    _resultsList[index].id,
                                    '',
                                    'list'),
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        idList = _resultsList[index].id;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonListPage(
                                idList: _resultsList[index].id,
                                listName:
                                    _resultsList[index]['name'].toString()),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              itemCount: _resultsList.length,
            ),
          ),
        ],
      ),
    );
  }
}
