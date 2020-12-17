import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Game/Game.dart';
import 'package:gmoria/a%20jeter/data.dart';

class GameConfiguration extends StatefulWidget {
  static String routeName = '/gameConfig';
  final String appTitle = 'GMORIA';
  final personsList;
  final listName;
  final listId;
  final listMistakes;

  GameConfiguration(
      {this.listName, this.personsList, this.listMistakes, this.listId});

  @override
  _GameConfiguration createState() => _GameConfiguration();
}

class _GameConfiguration extends State<GameConfiguration> {
  //List personsList = [];
  bool isSwitchedPlayOnlyWithMistakes = false;
  bool isCorrect;
  List listIsNotCorrect;
  List personsListTest = [];

  @override
  void initState() {
    fillDropdown();

    super.initState();
  }

  List test = [];

  fillDropdown() {
    for (int i = 1; i < widget.personsList.length + 1; i++) {
      test.add(i);
    }
  }

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
                      items: isSwitchedPlayOnlyWithMistakes
                          ? null
                          : test.map<DropdownMenuItem<int>>((e) {
                              return DropdownMenuItem<int>(
                                child: Text(e.toString()),
                                value: e,
                              );
                            }).toList(),
                    ),
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
                        builder: (context) => Game(
                          listName: widget.listName,
                          listId: widget.listId,
                          personsMistakesList: widget.listMistakes,
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
