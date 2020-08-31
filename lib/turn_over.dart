import 'package:flutter/material.dart';

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
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Expanded(
                    child: FittedBox(
                        fit: BoxFit.contain, child: Text(correct.toString()))),
                Text("Correct"),
              ]),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Expanded(
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(incorrect.toString()))),
                Text("Incorrect"),
              ]),
            ),
          ],
        ));
  }
}
