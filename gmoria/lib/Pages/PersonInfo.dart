import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';

import '../models/PersonModel.dart';

class PersonInfo extends StatefulWidget {
  static String routeName = '/personInfo';
  final String appTitle = 'GMORIA';

  @override
  _PersonInfoState createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  @override
  Widget build(BuildContext context) {
    final Person person = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.appTitle),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(person.image),
              radius: 50,
            ),
            Container(
              child: Text('Name : ' + person.name),
            ),
            Container(
              child: Text('Firstame : ' + person.firstname),
            ),
            Container(
              child: Text('Notes : ' + person.notes),
            ),
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              },
            )
          ],
        ),
      ),
    );
  }
}
