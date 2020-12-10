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
          children: [
            Container(
              child: Text(
                'SCORE : $score',
                style: TextStyle(fontSize: 50),
              ),
            ),
            IconButton(
              icon: Icon(Icons.home),
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
