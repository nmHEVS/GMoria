import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Game/ScorePage.dart';
import '../../Applocalizations.dart';

//Created by GF
//Class to play the game with the mode Quiz, the user must write or dictate the name of the displaying contact

class Game extends StatefulWidget {
  static String routeName = '/game';
  final String appTitle = 'GMORIA';
  final personsList;
  final nbQuestions;
  final listName;
  final listId;
  final personsMistakesList;
  final playWithMistakes;

  Game(
      {this.listName,
      this.personsList,
      this.listId,
      this.nbQuestions,
      this.personsMistakesList,
      this.playWithMistakes});

  @override
  _GameState createState() => _GameState();
}

var firestoreInstance = FirebaseFirestore.instance;
var firebaseUser = FirebaseAuth.instance.currentUser;

//GF
//Method to update the score at the end of the game
Future updateScore(int score, String listId) async {
  return await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('lists')
      .doc(listId)
      .update({'score': score});
}

class _GameState extends State<Game> {
  int currentQuestion = 0;
  int score = 0;
  int randomNumber;
  var nbQuestions;
  List numbers = [];
  var playedList;
  var validate;

  @override
  void initState() {
    //GF
    //if the user wants to play with mitakes only
    if (widget.playWithMistakes) {
      playedList = widget.personsMistakesList;
    } else {
      playedList = widget.personsList;
    }

    nbQuestions = widget.nbQuestions;

    //GF
    //fill an array with numbers
    for (int i = 0; i < nbQuestions; i++) {
      numbers.add(i);
    }

    //GF
    //mix the numbers to have random questions
    numbers = shuffle(numbers);
    randomQuestions();

    super.initState();
  }

  randomQuestions() {
    randomNumber = numbers[currentQuestion];
  }

  //GF
  //Methode to mix the order of the questions
  List shuffle(List items) {
    var random = new Random();

    //GF
    // Go through all elements.
    for (var i = 0; i < items.length; i++) {
      //GF
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  //GF
  //Method to update the field 'isCorrect' in the DB
  void updateIsCorrect(personId, correct) async {
    await firestoreInstance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('persons')
        .doc(personId)
        .update({'isCorrect': correct});
  }

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();
    int scorePercent = 0;

    void _validateQuestion() {
      //GF
      //Check if what the user wrote is correct
      if (_controller.text.toLowerCase() ==
          (playedList.elementAt(randomNumber)['firstname'].toLowerCase() +
              ' ' +
              playedList.elementAt(randomNumber)['name'].toLowerCase())) {
        //GF
        //it's correct, so we increment the score and update the field is correct in the DB
        score++;
        updateIsCorrect(playedList.elementAt(randomNumber).id, true);
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              backgroundColor: Colors.green[300],
              title: Text(
                AppLocalizations.of(context).translate('labelCorrect'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
      } else {
        //GF
        //it's not correct, so we update the field is correct in the DB
        updateIsCorrect(playedList.elementAt(randomNumber).id, false);
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                backgroundColor: Colors.red[400],
                title: Text(
                  AppLocalizations.of(context).translate('labelFalse'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              );
            });
      }

      //GF
      //check if the game id finished
      if (currentQuestion == nbQuestions - 1) {
        scorePercent = ((score / nbQuestions) * 100).round();
        Timer(Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScorePage(
                score: scorePercent,
                listName: widget.listName,
              ),
            ),
          );
        });

        updateScore(scorePercent, widget.listId);
      } else {
        //GF
        //if not finished, pass to the next question
        Timer(Duration(seconds: 2), () {
          setState(() {
            currentQuestion++;
            _controller.clear();
            randomQuestions();
          });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context).translate('labelHint')),
                  controller: _controller,
                ),
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  backgroundImage: Image.file(
                    File(playedList.elementAt(randomNumber)['image']),
                  ).image,
                  radius: 150,
                  backgroundColor: Colors.black,
                ),
                SizedBox(
                  height: 30,
                ),
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    _validateQuestion();
                  },
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
