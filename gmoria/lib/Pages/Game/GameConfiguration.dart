import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Game/PersonGameCard.dart';
import 'package:gmoria/a%20jeter/data.dart';

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
  //List personsList = [];
  bool isSwitchedPlayOnlyWithMistakes = false;
  var _controller = TextEditingController();
  bool isCorrect;
  List listIsNotCorrect;
  List personsListTest = [];

  /*List test = <int>[
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20
  ];*/

  @override
  void initState() {
    //getRandomNumber();
    fillDropdown();
    super.initState();
  }

  List test = [];

  fillDropdown() {
    for (int i = 1; i < widget.personsList.length + 1; i++) {
      test.add(i);
    }
  }

  //var _controller = TextEditingController();

  //stream: FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).collection('lists').doc(widget.listId).collection('persons').snapshots(),

  int selectedNumber;

  List data = personsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game configuration - " + widget.listName),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Container(
            width: double.infinity,
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
                          print(isSwitchedPlayOnlyWithMistakes);
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    DropdownButton(
                      value: selectedNumber,
                      isDense: true,
                      hint: Text('Number of questions'),
                      onChanged: (value) {
                        setState(() {
                          selectedNumber = value;
                        });
                      },
                      items: test.map<DropdownMenuItem<int>>((e) {
                        return DropdownMenuItem<int>(
                          child: Text(e.toString()),
                          value: e,
                        );
                      }).toList(),
                    ),
                    /*Flexible(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(hintText: 'Number of questions'),
                        controller: _controller,
                      )),*/
                  ],
                ),
                Text(
                  "*If you don't choose a number of questions, you will play by default with all the list",
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(
                  height: 35,
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
                          nbQuestions: selectedNumber,
                          playWithMistakes: isSwitchedPlayOnlyWithMistakes,
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
