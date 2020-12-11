import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Game/PersonGameCard.dart';

class GameConfiguration extends StatefulWidget {
  static String routeName = '/gameConfig';
  final String appTitle = 'GMORIA';
  final personsList;
  final listName;
  final listId;

  GameConfiguration({this.listName, this.personsList, this.listId});

  @override
  _GameConfiguration createState() => _GameConfiguration();
}

class _GameConfiguration extends State<GameConfiguration> {
  List personsList = [];
  bool isSwitchedPlayOnlyWithMistakes = false;
  var _controller = TextEditingController();
  bool isCorrect;
  List listIsNotCorrect;
  List personsListTest = [];

  //var _controller = TextEditingController();

  //stream: FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).collection('lists').doc(widget.listId).collection('persons').snapshots(),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game configuration - " + widget.listName),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Play only with mistakes'),
                    Switch(
                      value: isSwitchedPlayOnlyWithMistakes,
                      onChanged: (value) {
                        setState(() {
                          isSwitchedPlayOnlyWithMistakes = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: TextField(
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(hintText: 'Number of questions'),
                      controller: _controller,
                    )),
                  ],
                ),
                FloatingActionButton(
                  heroTag: 'game',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonGameCard(
                          listName: widget.listName,
                          listId: widget.listId,
                          personsList: widget.personsList,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.play_arrow),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
