import 'package:celebrity/add_celebrity.dart';
import 'package:celebrity/play_game.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_state.dart';
import 'gridbox.dart';

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

  Scaffold simpleScreen(String text) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Text(
        text,
        style: TextStyle(fontSize: 32),
      )),
    );
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
            return simpleScreen("Loading...");
          }
          var document = snapshot.data.documents.first;

          if (!document.exists) {
            return simpleScreen("Error");
          }
          GameState state = GameState(time: 3, game: document.reference);
          Column column = Column(
            children: [
              Ink(
                  color: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_up),
                    iconSize: 64,
                    onPressed: () => {},
                  )),
              IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 64,
                  onPressed: () => {}),
            ],
          );
          return Scaffold(
            appBar: AppBar(
              title: Text(document.get('name')),
            ),
            body: GridView.count(crossAxisCount: 2, children: [
              GridBox.informationBox(
                  document.get('card_count').toString(), "Celebrities"),
              GridBox.informationBox(document.get("round").toString(), "Round"),
              GridBox.informationBox(state.time.toString(), "Seconds per turn"),
              GridBox.widgetBox(column, "Adjust time"),
            ]),
            floatingActionButton: floatingActionButtons(context, state),
          );
        });
  }
}
