import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonGameCard extends StatefulWidget {
  static String routeName = '/game';
  final String appTitle = 'GMORIA';
  final personsList;
  final listName;
  final listId;
  final bool isSwitchedPlayOnlyWithMistakes;

  PersonGameCard(
      {this.listName,
      this.personsList,
      this.listId,
      this.isSwitchedPlayOnlyWithMistakes});

  @override
  _PersonGameCardState createState() => _PersonGameCardState();
}

Future updateScore(int score, String listId, String listname) async {
  var firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  debugPrint(score.toString());

  return await firestoreInstance
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('lists')
      .doc(listId)
      .set({'name': listname, 'score': score});
}

class _PersonGameCardState extends State<PersonGameCard> {
  int _i = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();
    int scorePercent = 0;

    void _randomQuestion() {
      if (widget.isSwitchedPlayOnlyWithMistakes == false) {
        if (_controller.text ==
            (widget.personsList.elementAt(_i)['firstname'] +
                ' ' +
                widget.personsList.elementAt(_i)['name'])) {
          score++;
        }
      }
      /*else {
        if (widget.personsList.elemantAt(_i)['isCorrect'] == false) {

        }
      }*/

      if (_i == widget.personsList.length - 1) {
        Navigator.pushNamed(context, '/score', arguments: score);
        scorePercent = ((score / widget.personsList.length) * 100).round();
        //post score on FireBase
        updateScore(scorePercent, widget.listId, widget.listName);
      } else {
        setState(() {
          _i++;
          _controller.clear();
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
                  backgroundImage:
                      AssetImage(widget.personsList.elementAt(_i)['image']),
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
