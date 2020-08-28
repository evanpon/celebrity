import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'game_details.dart';
import 'add_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: MyHomePage(title: 'Celebrity'),
            );
          }
          return Text("Loading", textDirection: TextDirection.ltr);
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget gameWidget(QueryDocumentSnapshot snapshot) {
    return ListTile(
      title: Text(snapshot.get('name')),
      subtitle: Text(
          "${snapshot.get('card_count')} celebrities, round ${snapshot.get('round')}"),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GameDetailsRoute(snapshot)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('games').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading');
            var data = snapshot.data;

            var docs = data.documents.length;

            return ListView.builder(
                itemExtent: 80,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    gameWidget(snapshot.data.documents[index]));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddGameRoute()))
        },
        tooltip: 'Create a new game',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
