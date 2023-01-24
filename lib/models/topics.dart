import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String topic;
  Topic({required this.topic});

  Map<String, dynamic> toJson() => {"name": topic};

  static Topic fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Topic(topic: snapshot['name']);
  }
}
