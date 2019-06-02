import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AuthBloc auth = AuthBloc.instance;

  test('Initial state should be null user', () {
    expect(auth.initialState, isA<NullUser>());
  });
  test('State is updated on dispatch', () {
    String name = 'cookoff';
    String email = 'me@cookoff.me';
    String uid = 'asdf';
    String profileUrl = 'http://test.com';
    User user = User(email, profileUrl, name, uid);
    auth.dispatch(user);
    expectLater(auth.state, emitsInOrder([isA<NullUser>(), user]));
  });
}

