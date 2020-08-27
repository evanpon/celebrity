import 'package:cloud_firestore/cloud_firestore.dart';

class GameState {
  int correct = 0;
  int incorrect = 0;
  DocumentReference game;
  int time;
  int round;

  GameState(
      {this.correct = 0, this.incorrect = 0, this.game, this.time, this.round});
}
