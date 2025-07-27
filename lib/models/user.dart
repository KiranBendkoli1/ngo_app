import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String name;
  final String imageUrl;

  const User(
      {
      required this.uid,
      required this.imageUrl,
      required this.email,
      required this.name});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot["uid"],
      email: snapshot["email"],
      name: snapshot["name"],
      imageUrl: snapshot["imageUrl"],
      
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "imageUrl": imageUrl
        
      };
}
