import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Game/AutoCheckGame.dart';
import 'package:gmoria/Pages/Game/Game.dart';
import 'package:gmoria/a%20jeter/data.dart';
import 'package:gmoria/alerts/alertNoMistakesMode.dart';
import 'package:gmoria/alerts/alertNoSelectedNumber.dart';

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

class _GameConfiguration extends State<GameConfiguration>
    with SingleTickerProviderStateMixin {
  bool isSwitchedPlayOnlyWithMistakes = false;
  final List<Widget> myTabs = [
    Tab(text: 'Self-Check Game'),
    Tab(text: 'Quiz Game'),
  ];
  TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    listNumbers = [];
    fillDropdown();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List listNumbers = [];

  fillDropdown() {
    for (int i = 1; i < widget.personsList.length + 1; i++) {
      listNumbers.add(i);
    }
  }

  int selectedNumber;

  List data = personsList;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Game configuration - " + widget.listName),
          ),
          resizeToAvoidBottomInset: false,
          body: ListView(
            children: [
              TabBar(
                tabs: myTabs,
                indicatorColor: Colors.indigo,
                labelStyle: TextStyle(fontSize: 16),
                unselectedLabelStyle: TextStyle(fontSize: 14),
                labelColor: Colors.black,
                controller: _tabController,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Play only with mistakes',
                        ),
                        Switch(
                          value: isSwitchedPlayOnlyWithMistakes,
                          onChanged: (value) {
                            if (widget.listMistakes.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    alertNoMistakesMode(context),
                              );
                            } else {
                              setState(() {
                                isSwitchedPlayOnlyWithMistakes = value;
                              });
                            }
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
                          hint: Text('Number of questions *'),
                          onChanged: (value) {
                            setState(() {
                              selectedNumber = value;
                            });
                          },
                          items: isSwitchedPlayOnlyWithMistakes
                              ? null
                              : listNumbers.map<DropdownMenuItem<int>>((e) {
                                  return DropdownMenuItem<int>(
                                    child: Text(e.toString()),
                                    value: e,
                                  );
                                }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    FloatingActionButton(
                      heroTag: 'game',
                      onPressed: () {
                        if (selectedNumber == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                alertNoSelectedNumber(context),
                          );
                        } else {
                          _tabIndex == 0
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AutoCheckGame(
                                        listName: widget.listName,
                                        listId: widget.listId,
                                        personsMistakesList:
                                            widget.listMistakes,
                                        personsList: widget.personsList,
                                        nbQuestions: selectedNumber,
                                        playWithMistakes:
                                            isSwitchedPlayOnlyWithMistakes),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Game(
                                      listName: widget.listName,
                                      listId: widget.listId,
                                      personsMistakesList: widget.listMistakes,
                                      personsList: widget.personsList,
                                      nbQuestions: selectedNumber,
                                      playWithMistakes:
                                          isSwitchedPlayOnlyWithMistakes,
                                    ),
                                  ),
                                );
                        }
                      },
                      child: Icon(Icons.play_arrow),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class snackBarMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('It seems that you made no mistakes in this list !'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('It seems that you made no mistakes in this list !'),
      ),
    );
  }
}
