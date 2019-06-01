import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/user_provider.dart';
import 'package:rxdart/src/observables/observable.dart';

class UserFirebaseAdapter implements UserProvider {
  Firestore _firestore = Firestore.instance;
  static const String usersCollection = "users";

  @override
  Observable<Iterable<User>> friends(String uid) {
    return Observable(_firestore
        .collection(usersCollection)
        .where("friends", arrayContains: uid)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((json) =>
                User.copyWithId(User.fromJson(json.data), json.documentID))
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
