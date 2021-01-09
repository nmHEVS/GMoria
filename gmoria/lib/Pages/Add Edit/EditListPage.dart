import 'package:flutter/material.dart';
import 'package:gmoria/Forms/EditListForm.dart';
import '../../Applocalizations.dart';

//Created by GF
//Page to edit a list, calls EditListForm()

class EditListPage extends StatefulWidget {
  final String appTitle = 'GMORIA';
  final listId;
  final listName;

  EditListPage({this.listId, this.listName});

  @override
  _EditListPageState createState() => _EditListPageState();
}

class _EditListPageState extends State<EditListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('labelEditList')),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: EditListForm(listId: widget.listId, listName: widget.listName),
    );
  }
}
