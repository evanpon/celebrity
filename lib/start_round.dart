import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'play_game.dart';

class StartRoundRoute extends StatelessWidget {
  final int time;
  final int round;
  final QueryDocumentSnapshot game;
  StartRoundRoute({Key key, this.game, this.time, this.round})
      : super(key: key);

  void play(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PlayGameRoute(game: game, time: time)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beginning of Round $round"),
      ),
      body: Column(children: [
        Text("You have $time seconds left for the next round."),
        RaisedButton(
            onPressed: () => {play(context)}, child: Text("Start next round")),
      ]),
    );
  }
}
