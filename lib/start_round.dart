import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'play_game.dart';
import 'game_state.dart';
import 'gridbox.dart';

class StartRoundRoute extends StatelessWidget {
  final GameState gameState;
  StartRoundRoute({Key key, this.gameState}) : super(key: key);

  void play(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PlayGameRoute(gameState: gameState)));
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
          GridBox.informationBox(
              gameState.time.toString(), "remaining seconds"),
          GridBox.informationBox(gameState.round.toString(), "next round"),
          GridBox.informationBox(
              gameState.correct.toString(), "correct (so far)"),
          GridBox.informationBox(
              gameState.incorrect.toString(), "incorrect (so far)"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {play(context)},
          tooltip: "Keep playing",
          child: Icon(Icons.play_arrow)),
    );
  }
}
