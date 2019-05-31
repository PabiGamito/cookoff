import 'package:cookoff/models/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthProvider {
  Future signIn();
  Future signOut();
  Observable<User> profile;
}
