import 'package:cookoff/blocs/friends_selection_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FriendsSelectionBloc bloc = FriendsSelectionBloc();

  test('Initial state should be empty set', () {
    expect(bloc.initialState, Set());
  });
  test('Event adds new item to state', () {
    bloc = FriendsSelectionBloc();
    String firstEvent = 'the event';
    String secondEvent = 'second event';
    bloc.dispatch(firstEvent);
    bloc.dispatch(secondEvent);
    expectLater(bloc.state, emitsInOrder([isEmpty, contains(firstEvent), containsAll([firstEvent, secondEvent])]));
  });
  test('Event removes item from state', () {
    bloc = FriendsSelectionBloc();
    String event = 'removal event';
    bloc.dispatch(event);
    bloc.dispatch(event);
    expectLater(bloc.state, emitsInOrder([isEmpty, contains(event), isEmpty]));
  });
}
