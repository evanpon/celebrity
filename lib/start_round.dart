import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'play_game.dart';
import 'game_state.dart';

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
        title: Text("Beginning of Round ${state.round}"),
      ),
      body: Column(children: [
        Text("You have ${state.time} seconds left for the next round."),
        RaisedButton(
            onPressed: () => {play(context)}, child: Text("Start next round")),
      ]),
    );
  }
}
