import 'package:flutter/material.dart';
import 'package:gmoria/datas/FetchDataPersonToAdd.dart';

class AddExistingPerson extends StatefulWidget {
  final String appTitle = 'GMORIA';
  final listId;
  AddExistingPerson({this.listId});

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
                Navigator.pushNamed(context, '/home');
              },
              child: Icon(Icons.save),
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
