import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String email;
  String uid;
  bool premium;
  DateTime premiumEndDate;
  List favouriteGenres;
  int noOfFreeStories;
  List favouriteStories;

  User(
      {required this.name,
      required this.email,
      required this.uid,
      required this.premium,
      required this.premiumEndDate,
      required this.favouriteGenres,
      required this.noOfFreeStories,
      required this.favouriteStories});
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "uid": uid,
        "premium": premium,
        "premiumEndDate": premiumEndDate,
        "favouriteGenres": favouriteGenres,
        "noOfFreeStories": noOfFreeStories,
        "favouriteStories": favouriteStories
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        name: snapshot['name'],
        email: snapshot['email'],
        uid: snapshot['uid'],
        premium: snapshot['premium'],
        premiumEndDate: snapshot['premiumEndDate'].toDate(),
        favouriteGenres: snapshot['favouriteGenres'],
        noOfFreeStories: snapshot['noOfFreeStories'],
        favouriteStories: snapshot['favouriteStories']);
  }
}
