import 'package:flutter/material.dart';
import 'package:gmoria/Forms/AddListForm.dart';

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
          title: Text(widget.appTitle + ' - Add a new list'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: AddListForm(),
    );
  }
}
