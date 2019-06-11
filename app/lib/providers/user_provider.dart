import 'package:cookoff/models/user.dart';

abstract class UserProvider {
  // Get a user by ID
  Stream<User> userStream(String id);

  // Add a friend by email. Returns if successful or not
  Future<bool> addFriend(String email, User currentUser);
}
