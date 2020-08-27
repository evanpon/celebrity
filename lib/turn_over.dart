import 'package:flutter/material.dart';

class TurnOverRoute extends StatelessWidget {
  final int correct;
  final int incorrect;
  TurnOverRoute({Key key, this.correct, this.incorrect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("End Of Turn"),
        ),
        body: Text(
            "You got $correct celebrities correct, and $incorrect wrong."));
  }
}
