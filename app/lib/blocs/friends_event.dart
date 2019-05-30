import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FriendsEvent extends Equatable {
  FriendsEvent([List props = const []]) : super(props);
}

class FriendTicked extends FriendsEvent {
  final String friend;

  FriendTicked(this.friend) : super([friend]);
}

class FriendUnticked extends FriendsEvent {
  final String friend;

  FriendUnticked(this.friend) : super([friend]);
}
