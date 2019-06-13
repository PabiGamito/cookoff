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
          .where((snapshot) => snapshot.exists)
          .map((snapshot) {
        return User.fromJson(snapshot.data..['id'] = snapshot.documentID);
      });

  Future updateUser(User user) async => _firestore
      .collection(_collection)
      .document(user.id)
      .updateData(user.toJson());

  @override
  Future<bool> addFriend(String email, User currentUser) async {
    // Find friend with given email address
    var snapshot = await _firestore
        .collection(_collection)
        .where("email", isEqualTo: email)
        .snapshots()
        .first;
    var doc = snapshot.documents.first;
    // If the user doesn't exist, return false
    if (doc == null) {
      return false;
    }
    User friend = User.fromJson(doc.data..['id'] = doc.documentID);

    // Add each other as friends
    currentUser.copyWithFriends([...currentUser.friends, friend.id]);
    friend.copyWithFriends([...friend.friends, currentUser.id]);

    // Update both users in database
    Future.wait([updateUser(friend), updateUser(currentUser)]);
    return true;
  }

  @override
  Future<User> changeDiet(User user, String dietName) async {
    var newUser = user.copyWithDiet(dietName);
    await _firestore
        .collection(_collection)
        .document(newUser.id)
        .setData(newUser.toJson());
    return newUser;
  }
}
