import 'dart:io';
import 'package:flutter/material.dart';
import '../../Applocalizations.dart';

//Created by GF & MF & NM
//Class to edit a contact

class PersonLearnCard extends StatefulWidget {
  static String routeName = '/learn';
  final String appTitle = 'GMORIA';
  final personsList;
  final listName;

  PersonLearnCard({this.listName, this.personsList, listId});

  @override
  _PersonLearnCardState createState() => _PersonLearnCardState();
}

class _PersonLearnCardState extends State<PersonLearnCard> {
  int currentQuestion = 0;

  @override
  Widget build(BuildContext context) {
    //GF MF NM
    //Method to increment the counter to display the next contact
    void _incrementCounter() {
      if (currentQuestion == widget.personsList.length - 1) {
        setState(() {
          currentQuestion = 0;
        });
      } else {
        setState(() {
          currentQuestion++;
        });
      }
    }

    //GF MF NM
    //Method to increment the counter to display the previous contact
    void _decrementCounter() {
      if (currentQuestion == 0) {
        setState(() {
          currentQuestion = widget.personsList.length - 1;
        });
      } else {
        setState(() {
          currentQuestion--;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: Image.file(
                    File(
                        widget.personsList.elementAt(currentQuestion)['image']),
                  ).image,
                  radius: 130,
                  backgroundColor: Colors.black,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  widget.personsList.elementAt(currentQuestion)['firstname'] +
                      ' ' +
                      widget.personsList.elementAt(currentQuestion)['name'],
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 30,
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildAboutDialog(
                          context,
                          widget.personsList
                              .elementAt(currentQuestion)['notes']),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: _decrementCounter,
                      iconSize: 80,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: _incrementCounter,
                      iconSize: 80,
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

//NM
//Pop-up infos of the person when click on (i)
Widget _buildAboutDialog(BuildContext context, String notes) {
  return new AlertDialog(
    title: Text(AppLocalizations.of(context).translate('labelNotes')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          notes,
          style: TextStyle(fontSize: 30),
        ),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: Text(AppLocalizations.of(context).translate('labelCancel')),
      ),
    ],
  );
}
