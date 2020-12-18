import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria/Pages/Game/ScorePage.dart';

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

Future updateScore(int score, String listId, String listname) async {
  debugPrint(score.toString());

  return await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('lists')
      .doc(listId)
      .set({'name': listname, 'score': score});
}

class _GameState extends State<Game> {
  int _i = 0;
  int score = 0;
  int randomNumber;
  var nbQuestions;
  List numbers = [];
  var playedList;

  @override
  void initState() {
    //if the user wants to play with mitakes only
    if (widget.playWithMistakes) {
      playedList = widget.personsMistakesList;
    } else {
      playedList = widget.personsList;
    }

    print(playedList.toString());

    //fill an array with numbers
    for (int i = 0; i < playedList.length; i++) {
      numbers.add(i);
    }

    //mix the numbers to have random questions
    numbers = shuffle(numbers);
    randomQuestions();

    super.initState();
  }

  randomQuestions() {
    randomNumber = numbers[_i];
  }

  //Methode to mix the order of the questions
  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = 0; i < items.length; i++) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

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
    var correct = false;

    void _validateQuestion() {
      //Check if what the user wrote is correct
      if (_controller.text.toLowerCase() ==
          (playedList.elementAt(randomNumber)['firstname'].toLowerCase() +
              ' ' +
              playedList.elementAt(randomNumber)['name'].toLowerCase())) {
        //it's correct, so we increment the score and update the field is correct in the DB
        score++;
        updateIsCorrect(playedList.elementAt(randomNumber).id, true);
        correct = true;
      } else {
        //it's not correct, so we update the field is correct in the DB
        updateIsCorrect(playedList.elementAt(randomNumber).id, false);
        correct = false;
      }

      //if we don't choose a number of question, then play with all the list
      if (widget.nbQuestions == null) {
        nbQuestions = playedList.length - 1;
      } else {
        nbQuestions = widget.nbQuestions - 1;
      }

      //check if the game id finished
      if (_i == nbQuestions) {
        scorePercent = ((score / playedList.length) * 100).round();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScorePage(
              score: scorePercent,
              listName: widget.listName,
            ),
          ),
        );
        //post score on FireBase
        updateScore(scorePercent, widget.listId, widget.listName);
      } else {
        //if not finished, pass to the next question
        setState(() {
          _i++;
          _controller.clear();
          randomQuestions();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle + " - " + widget.listName),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Firstname Lastname'),
                  controller: _controller,
                ),
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  backgroundImage: Image.file(
                    File(playedList.elementAt(numbers[randomNumber])['image']),
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
