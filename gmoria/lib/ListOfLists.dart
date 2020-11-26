import 'package:flutter/material.dart';
import 'package:gmoria/ListCard.dart';
import 'package:gmoria/models/ListModel.dart';

class ListOfList extends StatelessWidget {
  final List<ListApp> lists;

  ListOfList({this.lists});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
          children: lists
              .map(
                (list) => ListCard(
                  //key: ValueKey(list.id),
                  listApp: list,
                ),
              )
              .toList()),
    );
  }
}
