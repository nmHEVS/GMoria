import 'package:flutter/material.dart';
import 'package:gmoria/datas/FetchDataPersonToAdd.dart';

class AddExistingPerson extends StatefulWidget {
  final String appTitle = 'GMORIA';
  @override
  _AddExistingPersonState createState() => _AddExistingPersonState();
}

class _AddExistingPersonState extends State<AddExistingPerson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.appTitle + ' - Add an existing contact'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: FetchDataPersonToAdd(),
    );
  }
}
