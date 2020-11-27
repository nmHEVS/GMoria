import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';

class PersonInfo extends StatefulWidget {
  static String routeName = '/personInfo';
  final String appTitle = 'GMORIA';

  @override
  _PersonInfoState createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  @override
  Widget build(BuildContext context) {
    final String name = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text(
                'Name : $name',
              ),
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
