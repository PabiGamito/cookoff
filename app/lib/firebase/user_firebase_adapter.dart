import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/user_provider.dart';

class UserFirebaseAdapter implements UserProvider {
  static const String _collection = 'users';

  static final Firestore _firestore = Firestore.instance;

  @override
  Stream<User> userStream(String id) => _firestore
      .collection(_collection)
      .document(id)
      .snapshots()
      .map((snapshot) =>
          User.fromJson(snapshot.data..['id'] = snapshot.documentID));
}
