import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../Applocalizations.dart';

//Created by GF & NM
//Page to display the score at the end of the game

class ScorePage extends StatefulWidget {
  final String appTitle = 'GMORIA';
  final score;
  final listName;

  ScorePage({this.score, this.listName});

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  ConfettiController controller;

  //GF
  //Add the listener for the animation Confetti
  @override
  void initState() {
    controller = ConfettiController(duration: Duration(seconds: 3));
    if (widget.score > 80) {
      controller.play();
    }

    super.initState();
  }

  //MF
  //Form that displays the scorePage
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appTitle),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(25),
          child: Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConfettiWidget(
                      confettiController: controller,
                      blastDirection: -pi / 2,
                      emissionFrequency: 0.5,
                      numberOfParticles: 10,
                    ),
                  ),
                  Container(
                    child: Text(
                      widget.listName,
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: widget.score > 80
                        ? Text(
                            AppLocalizations.of(context)
                                .translate('labelGoodScore'),
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            AppLocalizations.of(context)
                                .translate('labelBadScore'),
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Text(
                      AppLocalizations.of(context).translate('labelYourScore'),
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    child: Text(
                      widget.score.toString() + '%',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  IconButton(
                    icon: Icon(Icons.home_rounded),
                    iconSize: 50,
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
