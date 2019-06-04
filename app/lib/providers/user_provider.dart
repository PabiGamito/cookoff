import 'package:cookoff/models/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class UserProvider {
  // get all friends of user uid
  Observable<Iterable<User>> friendsStream(String uid);

  // get a user uid
  Observable<User> user(String uid);
}
