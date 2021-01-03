import 'package:flutter/material.dart';
import 'package:gmoria/Forms/EditPersonForm.dart';

import '../../Applocalizations.dart';

class EditPersonPage extends StatefulWidget {
  final String appTitle = 'GMORIA';

  final name;
  final firstname;
  final image;
  final notes;
  final personId;

  EditPersonPage(
      {this.name, this.firstname, this.notes, this.image, this.personId});

  @override
  _EditPersonPageState createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('labelEditContact')),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: EditPersonForm(
          name: widget.name,
          firstname: widget.firstname,
          notes: widget.notes,
          image: widget.image,
          personId: widget.personId),
    );
  }
}
