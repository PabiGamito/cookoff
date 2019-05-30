import 'package:bloc/bloc.dart';

class FriendsBloc extends Bloc<String, Set<String>> {
  @override
  Set<String> get initialState => const {};

  @override
  Stream<Set<String>> mapEventToState(String event) async* {
    var nextState = Set.from(currentState);

    if (currentState.contains(event)) {
      nextState.remove(event);
    } else {
      nextState.add(event);
    }

    yield Set.from(nextState);
  }
}
