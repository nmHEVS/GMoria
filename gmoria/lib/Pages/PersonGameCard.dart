import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';
import 'package:gmoria/models/PersonModel.dart';

class PersonGameCard extends StatefulWidget {
  static String routeName = '/game';
  final String appTitle = 'GMORIA';
  final personsList;
  final listName;

  PersonGameCard({this.listName, this.personsList});

  @override
  _PersonGameCardState createState() => _PersonGameCardState();
}

class _PersonGameCardState extends State<PersonGameCard> {
  int _i = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    void _randomQuestion() {
      if (_controller.text ==
          (widget.personsList.elementAt(_i)['firstname'] +
              ' ' +
              widget.personsList.elementAt(_i)['name'])) {
        score++;
      }

      if (_i == widget.personsList.length - 1) {
        Navigator.pushNamed(context, '/score', arguments: score);
      } else {
        setState(() {
          _i++;
          _controller.clear();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                ),
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  backgroundImage:
                      AssetImage(widget.personsList.elementAt(_i)['image']),
                  radius: 180,
                ),
                SizedBox(
                  height: 30,
                ),
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: _randomQuestion,
                  iconSize: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
