import 'package:cookoff/models/user.dart';

abstract class AuthProvider {
  Future signIn();

  Future signOut();

  Stream<User> get profile;
}
