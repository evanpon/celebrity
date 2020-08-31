import 'package:flutter/material.dart';
import 'gridbox.dart';

class TurnOverRoute extends StatelessWidget {
  final int correct;
  final int incorrect;
  TurnOverRoute({Key key, this.correct, this.incorrect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("End Of Your Turn"),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            GridBox.informationBox(correct.toString(), "Correct"),
            GridBox.informationBox(incorrect.toString(), "Incorrect")
          ],
        ));
  }
}
