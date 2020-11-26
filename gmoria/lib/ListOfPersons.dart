import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';
import 'package:gmoria/PersonCard.dart';
import 'package:gmoria/models/PersonModel.dart';

import './datas/data.dart' as list;

class PersonList extends StatelessWidget {
  final String appTitle = 'GMORIA';
  final List<Person> persons = list.personsList;
  static String routeName = '/listContent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      drawer: DrawerApp(
        appTitle: appTitle,
      ),
      body: ListView(
        children: persons.map((person) => PersonCard(person: person)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/learn', arguments: persons);
        },
        child: Icon(Icons.book),
      ),
    );
  }
}
