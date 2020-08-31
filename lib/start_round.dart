import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'play_game.dart';
import 'game_state.dart';
import 'gridbox.dart';

class StartRoundRoute extends StatelessWidget {
  final GameState state;
  StartRoundRoute({Key key, this.state}) : super(key: key);

  void play(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => PlayGameRoute(state: state)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Round ended"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          GridBox.informationBox(state.time.toString(), "remaining seconds"),
          GridBox.informationBox(state.round.toString(), "next round"),
          GridBox.informationBox(state.correct.toString(), "correct (so far)"),
          GridBox.informationBox(
              state.incorrect.toString(), "incorrect (so far)"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {play(context)},
          tooltip: "Keep playing",
          child: Icon(Icons.play_arrow)),
    );
  }
}
