import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    controller = ConfettiController(duration: Duration(seconds: 3));
    if (widget.score > 80) {
      controller.play();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Center(
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
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: widget.score > 80
                    ? Text(
                        'Well Done ! Almost perfect !',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        'You need a little more work... ',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  'Your score for the list ' + widget.listName + ' : ',
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
    );
  }
}
