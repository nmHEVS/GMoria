import 'package:flutter/material.dart';
import 'package:gmoria/a%20jeter/PersonCard.dart';
import 'package:gmoria/models/PersonModel.dart';

import '../datas/data.dart' as list;

class PersonList extends StatelessWidget {
  final String appTitle = 'GMORIA';
  final List<Person> persons = list.personsList;

  static String routeName = '/listContent';

  @override
  Widget build(BuildContext context) {
    String listName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
          title: Text(listName),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: ListView(
        children: persons.map((person) => PersonCard(person: person)).toList(),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            top: 115.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'learn',
              onPressed: () {
                Navigator.pushNamed(context, '/learn', arguments: persons);
              },
              child: Icon(Icons.book),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          Positioned(
            top: 190.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'game',
              onPressed: () {
                Navigator.pushNamed(context, '/game', arguments: persons);
              },
              child: Icon(Icons.play_arrow),
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
