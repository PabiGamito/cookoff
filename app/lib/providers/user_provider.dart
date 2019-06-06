import 'package:cookoff/models/user.dart';

abstract class UserProvider {
  // Get a user by ID
  Stream<User> userStream(String id);
}
