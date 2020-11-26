import 'package:flutter/material.dart';
import 'package:gmoria/models/ListModel.dart';

class ListCard extends StatefulWidget {
  final ListApp listApp;

  ListCard({Key key, this.listApp}) : super(key: key);

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.listApp.name),
        subtitle: Text(widget.listApp.score.toString() + "%"),
        onTap: () {
          Navigator.pushNamed(context, '/listContent');
        },
      ),
    );
  }
}
