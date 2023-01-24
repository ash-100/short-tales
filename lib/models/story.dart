import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  String name;
  String description;
  String id;
  List genre;
  String thumbnail;
  int readCount;
  int likeCount;
  List pdfUrl;
  bool partwise;

  Story(
      {required this.name,
      required this.description,
      required this.id,
      required this.genre,
      required this.thumbnail,
      required this.readCount,
      required this.likeCount,
      required this.pdfUrl,
      required this.partwise});

  Map<String, dynamic> toJson() => {}; // required only in admin

  static Story fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Story(
        name: snapshot['name'],
        description: snapshot['description'],
        id: snapshot['id'],
        genre: snapshot['genre'],
        thumbnail: snapshot['thumbnail'],
        readCount: snapshot['readCount'],
        likeCount: snapshot['likeCount'],
        pdfUrl: snapshot['pdfUrl'],
        partwise: snapshot['partwise']);
  }
}
