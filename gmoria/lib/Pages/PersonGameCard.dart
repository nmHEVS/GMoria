import 'package:flutter/material.dart';
import 'package:gmoria/DrawerApp.dart';
import 'package:gmoria/models/PersonModel.dart';

class PersonGameCard extends StatefulWidget {
  static String routeName = '/game';
  final String appTitle = 'GMORIA';

  @override
  _PersonGameCardState createState() => _PersonGameCardState();
}

class _PersonGameCardState extends State<PersonGameCard> {
  int _i = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    final List<Person> persons = ModalRoute.of(context).settings.arguments;
    var _controller = TextEditingController();

    void _randomQuestion() {
      if (_controller.text ==
          (persons.elementAt(_i).firstname +
              ' ' +
              persons.elementAt(_i).name)) {
        score++;
      }

      if (_i == persons.length - 1) {
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
      drawer: DrawerApp(
        appTitle: widget.appTitle,
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
                  backgroundImage: AssetImage(persons.elementAt(_i).image),
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
