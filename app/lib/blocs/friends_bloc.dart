import 'package:bloc/bloc.dart';

import 'friends_event.dart';

class FriendsBloc extends Bloc<FriendsEvent, Set<String>> {
  @override
  Set<String> get initialState => const {};

  @override
  Stream<Set<String>> mapEventToState(FriendsEvent event) async* {
    if (event is FriendTicked) {
      yield currentState..add(event.friend);
    }

    if (event is FriendUnticked) {
      yield currentState..remove(event.friend);
    }
  }
}
