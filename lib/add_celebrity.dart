import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCelebrityRoute extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final QueryDocumentSnapshot _game;
  String celebrityName;

  AddCelebrityRoute(QueryDocumentSnapshot game) : _game = game;

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    _game.reference
        .collection('cards')
        .add({"name": celebrityName, "round": 0});
    _game.reference.update({"card_count": FieldValue.increment(1)});
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
      decoration: InputDecoration(labelText: "Celebrity"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Celebrity can't be blank.";
        }
      },
      onSaved: (String value) {
        celebrityName = value;
      },
    );
    Form form = Form(child: textField, key: _formKey);
    Padding padding = Padding(padding: EdgeInsets.all(8), child: form);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add celebrity'),
          actions: <Widget>[saveButton],
        ),
        body: padding);
  }
}
