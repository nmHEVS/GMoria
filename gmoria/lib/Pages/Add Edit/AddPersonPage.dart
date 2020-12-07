import 'package:flutter/material.dart';
import 'package:gmoria/Forms/AddPersonForm.dart';

class AddPersonPage extends StatefulWidget {
  final String appTitle = 'GMORIA';
  final listName;
  final listId;

  AddPersonPage({this.listName, this.listId});

  @override
  _AddPersonPageState createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
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
      body: AddPersonForm(listName: widget.listName, listId: widget.listId),
    );
  }
}
