import 'package:cookoff/models/user.dart';

abstract class AuthProvider {
  Stream<User> userStream();

  Future signIn();

  Future signOut();
}
