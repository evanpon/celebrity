import 'package:cloud_firestore/cloud_firestore.dart';

class Celebrity {
  final String name;
  final DocumentReference reference;
  final int round;

  const Celebrity({this.name, this.reference, this.round});
}
