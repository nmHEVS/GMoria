import 'package:flutter/material.dart';
import 'package:gmoria/Pages/Drawer/DrawerApp.dart';

class ScorePage extends StatefulWidget {
  static String routeName = '/score';
  final String appTitle = 'GMORIA';

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    final int score = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      drawer: DrawerApp(
        appTitle: widget.appTitle,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Text(
                'Your score :',
                style: TextStyle(fontSize: 50),
              ),
            ),
            Container(
              child: Text(
                '$score',
                style: TextStyle(fontSize: 50),
              ),
            ),
            IconButton(
              icon: Icon(Icons.home_rounded),
              iconSize: 150,
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            )
          ],
        ),
      ),
    );
  }
}
