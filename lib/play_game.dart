import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'turn_over.dart';
import 'start_round.dart';
import 'dart:math';
import 'celebrity.dart';
import 'game_state.dart';

class PlayGameRoute extends StatefulWidget {
  final GameState state;
  const PlayGameRoute({Key key, this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayGameState();
  }
}

class PlayGameState extends State<PlayGameRoute> {
  Celebrity _celebrity;
  int _timeLeft;
  int _correct;
  int _incorrect;
  List<Celebrity> _celebrities;
  List<Celebrity> _correctCelebs = [];
  List<Celebrity> _incorrectCelebs = [];
  DocumentSnapshot game;

  @override
  void initState() {
    GameState state = widget.state;
    _timeLeft = state.time;
    _correct = state.correct;
    _incorrect = state.incorrect;
    loadCelebrities();
    super.initState();
  }

  Future<void> loadCelebrities() async {
    game = await widget.state.game.get();
    final data = await widget.state.game
        .collection('cards')
        .where("round", isLessThan: game.get("round"))
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
    updateCorrectCelebs();
  }

  // Mark all the celebs that are correct so they are ready for the next round.
  void updateCorrectCelebs() {
    _correctCelebs.forEach((celebrity) {
      celebrity.reference.update({"round": celebrity.round + 1});
    });
  }

  void endRound() {
    int nextRound = game.get("round") + 1;
    updateCorrectCelebs();
    game.reference.update({"round": nextRound});
    GameState state = GameState(
        round: nextRound,
        time: _timeLeft,
        game: game.reference,
        correct: _correct,
        incorrect: _incorrect);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => StartRoundRoute(state: state)));
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
