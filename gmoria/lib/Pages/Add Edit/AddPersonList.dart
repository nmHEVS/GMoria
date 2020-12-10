import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Add%20Edit/AddExistingPerson.dart';
import 'package:gmoria/Pages/Add%20Edit/AddPersonPage.dart';

class AddPersonList extends StatefulWidget {
  final String appTitle = 'GMORIA';
  final listName;
  final listId;

  AddPersonList({this.listId, this.listName});

  @override
  _AddPersonListState createState() => _AddPersonListState();
}

class _AddPersonListState extends State<AddPersonList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.appTitle + ' - Add people'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            FlatButton(
              minWidth: 200,
              color: Colors.indigo[100],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddExistingPerson(listId: widget.listId),
                  ),
                );
              },
              child: Text('Add an existing contact'),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              minWidth: 200,
              color: Colors.indigo[200],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPersonPage(
                        listName: widget.listName, listId: widget.listId),
                  ),
                );
              },
              child: Text('Create a new contact'),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              minWidth: 200,
              color: Colors.indigo[300],
              onPressed: () {},
              child: Text('Import a list of contact'),
            ),
          ],
        ),
      ),
    );
  }
}
