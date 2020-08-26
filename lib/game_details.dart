import 'package:celebrity/add_celebrity.dart';
import 'package:celebrity/play_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class GameDetailsRoute extends StatelessWidget {
  final QueryDocumentSnapshot _game;
  GameDetailsRoute(QueryDocumentSnapshot game) : _game = game;

  Widget gameDetails(BuildContext context) {
    return new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('games')
            .where("name", isEqualTo: _game.get('name'))
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var document = snapshot.data.documents.first;
          // document.reference.collection('cards')

          if (document != null) {
            int card_count = document.get('card_count');
            var text = Text("Current card count: $card_count");
            var button = RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayGameRoute(game: document)));
                },
                child: Text("Play game!"));
            return Column(
              children: [text, button],
            );
          } else {
            return new Text("Error");
          }
        });
  }

  // void _showPopup(BuildContext context) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => AddCelebrityRoute()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_game.get('name')),
      ),
      body: gameDetails(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddCelebrityRoute(_game)));
        },
        tooltip: "Add celebrity",
        child: Icon(Icons.add),
      ),
    );
  }
}
