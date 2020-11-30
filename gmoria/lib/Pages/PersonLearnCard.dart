import 'package:flutter/material.dart';
import 'package:gmoria/models/PersonModel.dart';

class PersonLearnCard extends StatefulWidget {
  static String routeName = '/learn';
  final String appTitle = 'GMORIA';
  final personsList;
  final listName;

  PersonLearnCard({this.listName, this.personsList});

  @override
  _PersonLearnCardState createState() => _PersonLearnCardState();
}

class _PersonLearnCardState extends State<PersonLearnCard> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    void _incrementCounter() {
      if (_i == widget.personsList.length - 1) {
        setState(() {
          _i = 0;
        });
      } else {
        setState(() {
          _i++;
        });
      }
    }

    void _decrementCounter() {
      if (_i == 0) {
        setState(() {
          _i = widget.personsList.length - 1;
        });
      } else {
        setState(() {
          _i--;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName + " - Learn"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage(widget.personsList.elementAt(_i)['image']),
                  radius: 180,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  widget.personsList.elementAt(_i)['firstname'] +
                      ' ' +
                      widget.personsList.elementAt(_i)['name'],
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: _decrementCounter,
                      iconSize: 80,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: _incrementCounter,
                      iconSize: 80,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
