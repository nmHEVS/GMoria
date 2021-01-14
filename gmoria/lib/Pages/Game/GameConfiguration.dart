import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Game/AutoCheckGame.dart';
import 'package:gmoria/Pages/Game/Game.dart';
import 'package:gmoria/alerts/alertHelpGameSCGame.dart';
import 'package:gmoria/alerts/alertHelpQuizGame.dart';
import 'package:gmoria/alerts/alertNoMistakesMode.dart';
import 'package:gmoria/alerts/alertNoSelectedNumber.dart';
import '../../Applocalizations.dart';

//Created by GF & MF
//Page to set up the game's configuration, choose the mode and the number of question

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
  //GF
  //Set up the two tabs for the game mode
  final List<Widget> myTabs = [
    Tab(text: 'Self-Check Game'),
    Tab(text: 'Quiz Game'),
  ];
  TabController _tabController;
  int _tabIndex = 0;
  List listNumbers = [];
  int selectedNumber;

  //GF
  //fill the dropdown list & add the controller to change tabs
  @override
  void initState() {
    listNumbers = [];
    fillDropdown();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  //GF
  //method to handle the changing tab
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  //GF
  //Remove the controller
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //GF
  //Method to fill the dropdown with the number of possible question
  fillDropdown() {
    listNumbers = [];
    var list;
    if (isSwitchedPlayOnlyWithMistakes) {
      list = widget.listMistakes.length;
    } else {
      list = widget.personsList.length;
    }
    for (int i = 1; i < list + 1; i++) {
      listNumbers.add(i);
    }
  }

  //MF
  //Form that displays the options for the game
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: Text(widget.listName),
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
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('labelGameConfig'),
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: "Help",
                          icon: Icon(Icons.help_outline),
                          onPressed: () {
                            _tabIndex == 0
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        alertHelpSCGame(context),
                                  )
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        alertHelpQuizGame(context),
                                  );
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)
                            .translate('labelPlayMistakes')),
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
                              fillDropdown();
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
                          hint: Text(AppLocalizations.of(context)
                              .translate('labelNbrOfQuestions')),
                          onChanged: (value) {
                            setState(() {
                              selectedNumber = value;
                            });
                          },
                          items: listNumbers.map<DropdownMenuItem<int>>((e) {
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
