import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'turn_over.dart';
import 'dart:math';

class PlayGameRoute extends StatefulWidget {
  final QueryDocumentSnapshot game;

  const PlayGameRoute({Key key, this.game}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayGameState();
  }
}

class PlayGameState extends State<PlayGameRoute> {
  String _celebrity = 'Loading...';
  int _timeLeft = 5;
  int _correct = 0;
  int _incorrect = 0;
  List celebrities;

  @override
  void initState() {
    loadCelebrities();
    super.initState();
  }

  Future<void> loadCelebrities() async {
    final data = await widget.game.reference
        .collection('cards')
        .where("round", isLessThan: widget.game.get("round"))
        .get();
    setState(() {
      celebrities =
          data.docs.map((querySnapshot) => querySnapshot.get("name")).toList();
      _getNextCelebrity();
    });
    startTimer();
  }

  void _getNextCelebrity() {
    int length = celebrities.length;
    String nextCeleb = "Finished round";
    if (length > 0) {
      Random random = new Random();
      int index = random.nextInt(length);
      nextCeleb = celebrities.removeAt(index);
    }
    setState(() {
      _celebrity = nextCeleb;
    });
  }

  void gotIt() {
    _correct += 1;
    _getNextCelebrity();
  }

  void missedIt() {
    _incorrect += 1;
    _getNextCelebrity();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      handleTimeout();
    });
  }

  void handleTimeout() {
    setState(() {
      _timeLeft -= 1;
    });
    if (_timeLeft > 0) {
      startTimer();
    } else {
      endTurn();
    }
  }

  void endTurn() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TurnOverRoute(
                  correct: _correct,
                  incorrect: _incorrect,
                )));
  }

  Widget build(BuildContext context) {
    final successButton = RaisedButton(
      onPressed: gotIt,
      child: Text("Success"),
    );
    final failureButton = RaisedButton(
      onPressed: missedIt,
      child: Text("Failure"),
    );
    final row = Row(
      children: [
        successButton,
        Padding(
          padding: EdgeInsets.all(16),
        ),
        failureButton
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Play game"),
      ),
      body:
          Column(children: [Text(_timeLeft.toString()), Text(_celebrity), row]),
    );
  }
}
