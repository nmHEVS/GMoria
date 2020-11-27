import 'package:flutter/material.dart';
import 'package:gmoria/models/PersonModel.dart';

class PersonCard extends StatefulWidget {
  final Person person;

  PersonCard({Key key, this.person}) : super(key: key);

  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  @override
  Widget build(BuildContext context) {
    Person person = widget.person;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(widget.person.image),
        ),
        title: Text(person.name + ' ' + person.firstname),
        onTap: () {
          Navigator.pushNamed(context, '/personInfo', arguments: person);
        },
      ),
    );
  }
}
