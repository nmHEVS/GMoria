import 'package:flutter/material.dart';

class About extends StatefulWidget {
  static String routeName = '/about';
  final String appTitle = 'GMORIA';

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text(
                'About Page',
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
