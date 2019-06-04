import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class UserFirebaseAdapter implements UserProvider {
  Firestore _firestore = Firestore.instance;
  static const String usersCollection = "users";

  @override
  Observable<Iterable<User>> friendsStream(String uid) {
    return Observable(_firestore
        .collection(usersCollection)
        .where("friends", arrayContains: uid)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) =>
                User.fromJson(document.data..['userId'] = document.documentID))
            .toList()));
  }

  @override
  Observable<User> user(String uid) {
    return Observable(_firestore
        .collection(usersCollection)
        .document(uid)
        .snapshots()
        .map((snapshot) => User.fromJson(snapshot.data)));
  }
}
