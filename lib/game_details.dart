import 'package:celebrity/add_celebrity.dart';
import 'package:celebrity/play_game.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_state.dart';

class GameDetailsRoute extends StatelessWidget {
  final QueryDocumentSnapshot _game;
  GameDetailsRoute(QueryDocumentSnapshot game) : _game = game;

  // void _showPopup(BuildContext context) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => AddCelebrityRoute()));
  // }
  FloatingActionButton playButton(BuildContext context, GameState state) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayGameRoute(state: state)));
      },
      tooltip: "Play Game",
      child: Icon(Icons.play_arrow),
      heroTag: null,
    );
  }

  FloatingActionButton addButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddCelebrityRoute(_game)));
      },
      tooltip: "Add celebrity",
      child: Icon(Icons.add),
      heroTag: null,
    );
  }

  Widget floatingActionButtons(BuildContext context, GameState state) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      addButton(context),
      SizedBox(height: 10),
      playButton(context, state),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('games')
            .where("name", isEqualTo: _game.get('name'))
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          var document = snapshot.data.documents.first;

          if (!document.exists) {
            return Text("Error");
          }
          Text cardCount = Text(document.get('card_count').toString());
          // cardCount = Text("50");
          var subtitle = Text("Celebrities");
          GameState state = GameState(time: 10, game: document.reference);

          return Scaffold(
            appBar: AppBar(
              title: Text(document.get('name')),
            ),
            body: Center(
                child: Column(children: [
              Expanded(
                  child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: FittedBox(fit: BoxFit.contain, child: cardCount)),
                  flex: 2),
              Expanded(
                  child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: FittedBox(fit: BoxFit.fitWidth, child: subtitle)),
                  flex: 1),
              Expanded(
                  child: SizedBox(
                    height: 10,
                  ),
                  flex: 1),
            ])),
            floatingActionButton: floatingActionButtons(context, state),
          );
        });
  }
}
