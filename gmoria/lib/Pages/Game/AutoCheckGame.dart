import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Game/ScorePage.dart';

//Created by GF
//Class to play the game with the mode self-check, the user choose himself if its response is correct or not

class AutoCheckGame extends StatefulWidget {
  static String routeName = '/game';
  final String appTitle = 'GMORIA';
  final personsList;
  final nbQuestions;
  final listName;
  final listId;
  final personsMistakesList;
  final playWithMistakes;

  AutoCheckGame(
      {this.listName,
      this.personsList,
      this.listId,
      this.nbQuestions,
      this.personsMistakesList,
      this.playWithMistakes});

  @override
  _AutoCheckGameState createState() => _AutoCheckGameState();
}

var firestoreInstance = FirebaseFirestore.instance;
var firebaseUser = FirebaseAuth.instance.currentUser;

//GF
//Method to update the score at the end of the game
Future updateScore(int score, String listId) async {
  debugPrint(score.toString());
  return await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('lists')
      .doc(listId)
      .update({'score': score});
}

class _AutoCheckGameState extends State<AutoCheckGame> {
  int currentQuestion = 0;
  int score = 0;
  int randomNumber;
  var nbQuestions;
  List numbers = [];
  var playedList;
  String response = 'Show me';

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
      print(playedList[i].id);
    }
    //GF
    //mix the numbers to have random questions
    numbers = shuffle(numbers);
    randomQuestions();

    super.initState();
  }

  //GF
  //set up the next question
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
    int scorePercent = 0;

    void _validate(String correct) {
      //GF
      //it's correct, so we increment the score and update the field is correct in the DB
      if (correct == 'correct') {
        score++;
        updateIsCorrect(playedList.elementAt(randomNumber).id, true);
        print(nbQuestions);
      } else {
        updateIsCorrect(playedList.elementAt(randomNumber).id, false);
      }

      //GF
      //check if the game id finished
      if (currentQuestion == nbQuestions - 1) {
        print(nbQuestions);
        scorePercent = ((score / nbQuestions) * 100).round();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScorePage(
              score: scorePercent,
              listName: widget.listName,
            ),
          ),
        );

        updateScore(scorePercent, widget.listId);
      } else {
        //GF
        //if not finished, pass to the next question
        setState(() {
          currentQuestion++;
          randomQuestions();
          response = 'Show me';
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle + " - " + widget.listName),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Card(
                  elevation: 10,
                  child: CircleAvatar(
                    backgroundImage: Image.file(
                      File(playedList.elementAt(randomNumber)['image']),
                    ).image,
                    radius: 150,
                    backgroundColor: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: Card(
                    child: InkWell(
                      child: Center(child: Text(response)),
                      onTap: () {
                        setState(() {
                          response = playedList
                                  .elementAt(randomNumber)['name'] +
                              ' ' +
                              playedList.elementAt(randomNumber)['firstname'];
                        });
                      },
                    ),
                    elevation: 10,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle),
                      color: Colors.green,
                      onPressed: () {
                        _validate('correct');
                      },
                      iconSize: 50,
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.red,
                      onPressed: () {
                        _validate('false');
                      },
                      iconSize: 50,
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
