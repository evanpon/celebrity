import 'package:celebrity/add_celebrity.dart';
import 'package:celebrity/play_game.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_state.dart';
import 'gridbox.dart';
import 'main.dart';

class GameDetailsRoute extends StatefulWidget {
  final QueryDocumentSnapshot game;
  const GameDetailsRoute({Key key, this.game}) : super(key: key);

  @override
  _GameDetailsRouteState createState() => _GameDetailsRouteState();
}

class _GameDetailsRouteState extends State<GameDetailsRoute> with RouteAware {
  GameState gameState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void didPop() {
    widget.game.reference.update({"time": gameState.time});
  }

  void didPushNext() {
    widget.game.reference.update({"time": gameState.time});
  }

  @override
  void initState() {
    gameState =
        GameState(time: widget.game.get("time"), game: widget.game.reference);
    super.initState();
  }

  // void _showPopup(BuildContext context) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => AddCelebrityRoute()));
  // }
  FloatingActionButton playButton(BuildContext context, GameState gameState) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayGameRoute(gameState: gameState)));
      },
      tooltip: "Play Game",
      child: Icon(Icons.play_arrow),
      heroTag: null,
    );
  }

  FloatingActionButton addButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddCelebrityRoute(widget.game)));
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

  void incrementTime() {
    setState(() {
      gameState.time = gameState.time + 1;
    });
  }

  void decrementTime() {
    setState(() {
      gameState.time = gameState.time - 1;
      if (gameState.time <= 0) {
        gameState.time = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('games')
            .where("name", isEqualTo: widget.game.get('name'))
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return simpleScreen("Loading...");
          }
          var document = snapshot.data.documents.first;

          if (!document.exists) {
            return simpleScreen("Error");
          }
          Column column = Column(
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_up),
                iconSize: 64,
                onPressed: incrementTime,
              ),
              IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 64,
                  onPressed: decrementTime),
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
              GridBox.informationBox(
                  gameState.time.toString(), "Seconds per turn"),
              GridBox.widgetBox(column, "Adjust time"),
            ]),
            floatingActionButton: floatingActionButtons(context, gameState),
          );
        });
  }
}
