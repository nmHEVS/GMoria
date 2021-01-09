import 'package:flutter/material.dart';
import 'package:gmoria/Forms/AddPersonForm.dart';
import '../../Applocalizations.dart';

//Created by GF
//Page to add a new contact, calls AddPersonForm()

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
          title: Text(AppLocalizations.of(context).translate('labelAddPeople')),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: AddPersonForm(listName: widget.listName, listId: widget.listId),
    );
  }
}
