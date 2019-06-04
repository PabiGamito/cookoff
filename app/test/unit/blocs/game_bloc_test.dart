import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var initialChallenge = Challenge('test_ingredient');
  var bloc = GameBloc(initialChallenge);
  var owner = NullUser();

  test('Initial state should be unmodified', () {
    expect(bloc.initialState, initialChallenge);
  });
  test('Owner event sets owner of challenge', () {
    bloc.dispatch(SetOwner(owner));
    expectLater(bloc.state, emitsInOrder([initialChallenge,
        predicate((Challenge c) => c.owner == owner.userId)]));
  });
  test('Friend button adds participant', () {
    String participant = 'test_participant';
    bloc.dispatch(FriendButton(participant));
    expectLater(bloc.state,
        emitsInOrder([
        predicate((Challenge c) => c.participants.contains(participant))]));
  });
  test('Friend button removes participant', () {
    String participant = 'test_participant';
    bloc.dispatch(FriendButton(participant));
    expectLater(bloc.state,
        emitsInOrder([
          predicate((Challenge c) => c.participants.contains(participant)),
          predicate((Challenge c) => !c.participants.contains(participant))]));
  });
}
