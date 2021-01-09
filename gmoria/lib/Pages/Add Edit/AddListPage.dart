import 'package:flutter/material.dart';
import 'package:gmoria/Forms/AddListForm.dart';
import '../../Applocalizations.dart';

//Created by GF
//Page to add a list, calls AddListForm()

class AddListPage extends StatefulWidget {
  final String appTitle = 'GMORIA';

  @override
  _AddListPageState createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('labelAddList')),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: AddListForm(),
    );
  }
}
