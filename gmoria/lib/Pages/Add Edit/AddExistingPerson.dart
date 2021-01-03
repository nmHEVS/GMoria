import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Add%20Edit/AddPersonPage.dart';
import 'package:gmoria/Pages/Person/PersonListPage.dart';
import 'package:gmoria/datas/FetchDataPersonToAdd.dart';

import '../../Applocalizations.dart';

class AddExistingPerson extends StatefulWidget {
  final String appTitle = 'GMORIA';
  final listId;
  final listName;

  AddExistingPerson({this.listId, this.listName});

  @override
  _AddExistingPersonState createState() => _AddExistingPersonState();
}

class _AddExistingPersonState extends State<AddExistingPerson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate('labelAddExistingContact')),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: FetchDataPersonToAdd(
        listId: widget.listId,
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            top: 110.0,
            right: 0.0,
            child: FloatingActionButton(
              heroTag: 'save',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonListPage(
                        listName: widget.listName, idList: widget.listId),
                  ),
                );
              },
              child: Icon(Icons.save),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          Positioned(
            top: 110.0,
            right: 65.0,
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPersonPage(
                        listName: widget.listName, listId: widget.listId),
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
