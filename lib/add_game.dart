import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGameRoute extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String name;

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    FirebaseFirestore.instance
        .collection('games')
        .add({"name": name, "round": 1, "card_count": 0});
  }

  @override
  Widget build(BuildContext context) {
    FlatButton saveButton = FlatButton(
      child: Text("SAVE", style: TextStyle(color: Colors.white)),
      onPressed: () {
        _submitForm();
        Navigator.of(context).pop();
      },
    );
    TextFormField textField = TextFormField(
      decoration: InputDecoration(labelText: "Name your game"),
      validator: (String value) {
        if (value.isEmpty) {
          return "You need a name for your game.";
        }
      },
      onSaved: (String value) {
        name = value;
      },
    );
    Form form = Form(child: textField, key: _formKey);
    Padding padding = Padding(padding: EdgeInsets.all(8), child: form);
    return Scaffold(
        appBar: AppBar(
          title: Text('Create a game'),
          actions: <Widget>[saveButton],
        ),
        body: padding);
  }
}
