import 'package:flutter/material.dart';
import 'package:gmoria/models/PersonModel.dart';

class PersonLearnCard extends StatefulWidget {
  static String routeName = '/learn';
  final String appTitle = 'GMORIA';

  @override
  _PersonLearnCardState createState() => _PersonLearnCardState();
}

class _PersonLearnCardState extends State<PersonLearnCard> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    final List<Person> persons = ModalRoute.of(context).settings.arguments;

    void _incrementCounter() {
      if (_i == persons.length - 1) {
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
          _i = persons.length - 1;
        });
      } else {
        setState(() {
          _i--;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("List"),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(persons.elementAt(_i).image),
                  radius: 180,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  persons.elementAt(_i).firstname +
                      ' ' +
                      persons.elementAt(_i).name,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 30,
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildAboutDialog(context),
                    );
                    // Perform some action
                  },
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

//Pop-up infos of the person when click on (i)
Widget _buildAboutDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Infos'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Infos here bla bla bla',
          style: TextStyle(fontSize: 30),
        ),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Okay, got it!'),
      ),
    ],
  );
}
