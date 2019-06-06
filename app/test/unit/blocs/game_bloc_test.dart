import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var owner = NullUser();
  var initialChallenge = Challenge(
      owner: owner.id,
      ingredient: 'test_ingredient',
      end: DateTime.now().add(Duration(days: 1)));

  var bloc = GameBloc(initialChallenge);

  test('Initial state should be unmodified', () {
    expect(bloc.initialState, initialChallenge);
  });
  test('Owner of challenge is set on creation', () {
    expect(bloc.state,
        emitsInOrder([predicate((Challenge c) => c.owner == owner.id)]));
  });
  test('Owner of challenge is added as a participant', () {
    expect(
        bloc.state,
        emitsInOrder(
            [predicate((Challenge c) => c.participants.contains(owner.id))]));
  });
  test('Friend button adds participant', () {
    String participant = 'test_participant';
    bloc.dispatch(FriendButton(participant));
    expectLater(
        bloc.state,
        emitsInOrder([
          initialChallenge,
          predicate((Challenge c) => c.participants.contains(participant))
        ]));
  });
  test('Friend button removes participant', () {
    String participant = 'test_participant';
    bloc.dispatch(FriendButton(participant));
    expectLater(
        bloc.state,
        emitsInOrder([
          predicate((Challenge c) => c.participants.contains(participant)),
          predicate((Challenge c) => !c.participants.contains(participant))
        ]));
  });
}
