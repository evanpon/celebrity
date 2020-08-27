import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'turn_over.dart';
import 'start_round.dart';
import 'dart:math';
import 'celebrity.dart';

class PlayGameRoute extends StatefulWidget {
  final QueryDocumentSnapshot game;
  final int time;
  const PlayGameRoute({Key key, this.game, this.time}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayGameState();
  }
}

class PlayGameState extends State<PlayGameRoute> {
  Celebrity _celebrity;
  int _timeLeft;
  int _correct = 0;
  int _incorrect = 0;
  List<Celebrity> _celebrities;
  List<Celebrity> _correctCelebs = [];
  List<Celebrity> _incorrectCelebs = [];

  @override
  void initState() {
    _timeLeft = widget.time;
    loadCelebrities();
    super.initState();
  }

  Future<void> loadCelebrities() async {
    final data = await widget.game.reference
        .collection('cards')
        .where("round", isLessThan: widget.game.get("round"))
        .get();
    setState(() {
      _celebrities = data.docs
          .map((querySnapshot) => Celebrity(
                name: querySnapshot.get("name"),
                reference: querySnapshot.reference,
                round: querySnapshot.get("round"),
              ))
          .toList();
      _getNextCelebrity();
    });
    startTimer();
  }

  void _getNextCelebrity() {
    int length = _celebrities.length;
    if (length > 0) {
      Random random = new Random();
      int index = random.nextInt(length);
      Celebrity nextCeleb = _celebrities.removeAt(index);
      setState(() {
        _celebrity = nextCeleb;
      });
    } else if (_incorrectCelebs.length > 0) {
      _celebrities = _incorrectCelebs;
      _incorrectCelebs = [];
      _getNextCelebrity();
    } else {
      endRound();
    }
  }

  void gotIt() {
    _correct += 1;
    _correctCelebs.add(_celebrity);
    _getNextCelebrity();
  }

  void missedIt() {
    _incorrect += 1;
    _incorrectCelebs.add(_celebrity);
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
    _correctCelebs.forEach((celebrity) {
      celebrity.reference.update({"round": celebrity.round + 1});
    });
  }

  void endRound() {
    int nextRound = widget.game.get("round") + 1;
    widget.game.reference.update({"round": nextRound});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => StartRoundRoute(
                game: widget.game, time: _timeLeft, round: nextRound)));
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
    String celebrityName = _celebrity == null ? "Loading..." : _celebrity.name;
    return Scaffold(
      appBar: AppBar(
        title: Text("Play game"),
      ),
      body: Column(
          children: [Text(_timeLeft.toString()), Text(celebrityName), row]),
    );
  }
}
