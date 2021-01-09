import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Add%20Edit/AddPersonPage.dart';
import 'package:gmoria/Pages/Drawer/DrawerApp.dart';
import 'package:gmoria/datas/FetchDataContact.dart';

//Created by GF
//Class to display all the existing contact of a user

class ContactsPage extends StatefulWidget {
  final String appTitle = 'GMORIA';

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: FetchDataContact(),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          heroTag: 'addPeople',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPersonPage(
                  listName: '',
                  listId: '',
                ),
              ),
            );
          },
          child: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
